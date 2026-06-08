import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Env.dart';
import '../../features/Authentication/Pages/SignInPage.dart';
import '../../features/Authentication/modal/refresh_token_data.dart';
import '../constant/shared_pref_constant.dart';
import '../utils/shared_pref_util.dart';
import 'api_exception.dart';
import 'base_api_response.dart';

class ApiService {
  final String baseUrl;

  ApiService([String? baseUrl]) : baseUrl = baseUrl ?? Env.baseUrl;

  /// Global navigator key — set this from main.dart so we can navigate from anywhere
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  // ── Token refresh queue ──────────────────────────────────────────────
  // If a refresh is already in progress, other callers wait on the same
  // Completer instead of firing duplicate refresh requests.
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

  // ── Endpoints that should NEVER trigger token-refresh logic ─────────
  static final Set<String> _excludedEndpoints = {
    Env.login,
    Env.passwrod, // createPassword
    Env.refresh_token,
  };

  // ── Public request method ────────────────────────────────────────────
  Future<Map<String, dynamic>> request(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        bool isFormData = false,
        List<http.MultipartFile>? files,
      }) async {
    try {
      final responseJson = await _executeRequest(
        method,
        endpoint,
        body: body,
        headers: headers,
        isFormData: isFormData,
        files: files,
      );

      // ── Check token errors in successful (2xx) responses too ─────────
      if (!_excludedEndpoints.contains(endpoint)) {
        final tokenResult = await _checkAndHandleTokenError(
          responseJson['error'],
          method, endpoint,
          body: body, headers: headers,
          isFormData: isFormData, files: files,
        );
        if (tokenResult != null) return tokenResult;
      }

      return responseJson;
    } on ApiException catch (e) {
      // ── Check token errors in failed (non-2xx) responses ─────────────
      if (!_excludedEndpoints.contains(endpoint) && e.response != null) {
        final tokenResult = await _checkAndHandleTokenError(
          e.response!['error'],
          method, endpoint,
          body: body, headers: headers,
          isFormData: isFormData, files: files,
        );
        if (tokenResult != null) return tokenResult;
      }
      rethrow;
    }
  }

  /// Checks the `error` value from an API response and handles token refresh
  /// or forced logout. Returns `null` if the error is not token-related,
  /// otherwise returns the retried response or throws.
  Future<Map<String, dynamic>?> _checkAndHandleTokenError(
      dynamic error,
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        bool isFormData = false,
        List<http.MultipartFile>? files,
      }) async {
    if (error == SharedPrefConstant.ACCESS_TOKEN_EXPIRED ||
        error == SharedPrefConstant.TOKEN_INVALID) {
      // Access token expired → refresh and retry the original request
      debugPrint(
          '\x1B[35m[ApiService] Access token expired ($error). Refreshing…\x1B[0m');

      final refreshed = await _handleTokenRefresh();

      if (refreshed) {
        // Re-read the NEW access token and inject it into the headers
        final newAccessToken = await SharedPreferencesUtil.instance
            .getStringData(SharedPrefConstant.accessToken);

        final updatedHeaders = Map<String, String>.from(headers ?? {});
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          updatedHeaders['Authorization'] = 'Bearer $newAccessToken';
        }

        // Retry the original request with the refreshed access token
        return _executeRequest(
          method,
          endpoint,
          body: body,
          headers: updatedHeaders,
          isFormData: isFormData,
          files: files,
        );
      } else {
        // Refresh itself failed — _handleTokenRefresh already handled logout
        throw ApiException(
          statusCode: 401,
          response: {'message': 'Session expired. Please login again.'},
        );
      }
    }

    if (error == SharedPrefConstant.REFRESH_TOKEN_EXPIRED) {
      // Refresh token expired → force logout
      debugPrint(
          '\x1B[35m[ApiService] Refresh token expired. Logging out…\x1B[0m');
      await _forceLogout();
      throw ApiException(
        statusCode: 401,
        response: {'message': 'Session expired. Please login again.'},
      );
    }

    return null; // Not a token error — let the caller handle normally
  }

  // ── Core HTTP execution (no interception logic here) ─────────────────
  Future<Map<String, dynamic>> _executeRequest(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
        bool isFormData = false,
        List<http.MultipartFile>? files,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final defaultHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    try {
      http.Response response;

      if (method == 'POST' && isFormData) {
        var request = http.MultipartRequest('POST', url)
          ..headers.addAll(defaultHeaders);

        if (files != null) {
          for (var file in files) {
            request.files.add(file);
          }
        }

        if (body != null) {
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        response = await http.Response.fromStream(await request.send());
      } else {
        if (method == 'POST') {
          response = await http.post(url,
              headers: defaultHeaders, body: jsonEncode(body));
        } else if (method == 'PUT') {
          response = await http.put(url,
              headers: defaultHeaders, body: jsonEncode(body));
        } else if (method == 'DELETE') {
          response = await http.delete(url,
              headers: defaultHeaders, body: jsonEncode(body));
        } else if (method == 'PATCH') {
          response = await http.patch(url,
              headers: defaultHeaders, body: jsonEncode(body));
        } else if (method == 'GET') {
          response = await http.get(url, headers: defaultHeaders);
        } else {
          throw Exception('Unsupported HTTP method');
        }
      }

      _logRequest(url.toString(), body, defaultHeaders);
      _logResponse(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          response: jsonDecode(response.body),
        );
      }
    } catch (e) {
      debugPrint('in API SERVICE Error in API request: $e');
      rethrow;
    }
  }

  // ── Token refresh handler ────────────────────────────────────────────
  Future<bool> _handleTokenRefresh() async {
    // If another call is already refreshing, wait for it
    if (_isRefreshing) {
      debugPrint(
          '\x1B[35m[ApiService] Refresh already in progress. Waiting…\x1B[0m');
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final storedRefreshToken = await SharedPreferencesUtil.instance
          .getStringData(SharedPrefConstant.refreshToken);

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        debugPrint(
            '\x1B[31m[ApiService] No refresh token found. Forcing logout.\x1B[0m');
        await _forceLogout();
        _refreshCompleter!.complete(false);
        return false;
      }

      // Call refresh token API directly (bypasses interception).
      // Wrap in try-catch because the server returns non-2xx when the
      // refresh token is expired, which causes _executeRequest to throw.
      Map<String, dynamic> refreshResponse;
      try {
        refreshResponse = await _executeRequest(
          'POST',
          Env.refresh_token,
          body: {'refreshToken': storedRefreshToken},
        );
      } on ApiException catch (e) {
        // Check if the server told us the refresh token itself is expired
        final refreshError = e.response?['error'];
        if (refreshError == SharedPrefConstant.REFRESH_TOKEN_EXPIRED ||
            refreshError == SharedPrefConstant.TOKEN_INVALID) {
          debugPrint(
              '\x1B[31m[ApiService] Refresh token expired (from error response). Forcing logout.\x1B[0m');
          await _forceLogout();
          _refreshCompleter!.complete(false);
          return false;
        }
        // Some other API error — treat as refresh failure
        rethrow;
      }

      final refreshApiResponse = BaseApiResponse<RefreshTokenData>.fromJson(
        refreshResponse,
            (data) => RefreshTokenData.fromJson(data),
      );

      // Also check for refresh token expired in a successful (2xx) response body
      final refreshError = refreshResponse['error'];
      if (refreshError == SharedPrefConstant.REFRESH_TOKEN_EXPIRED) {
        debugPrint(
            '\x1B[31m[ApiService] Refresh token expired. Forcing logout.\x1B[0m');
        await _forceLogout();
        _refreshCompleter!.complete(false);
        return false;
      }

      if (refreshApiResponse.status && refreshApiResponse.data != null) {
        // Save the new tokens
        await SharedPreferencesUtil.instance.setStringData(
          SharedPrefConstant.accessToken,
          refreshApiResponse.data!.accessToken,
        );
        await SharedPreferencesUtil.instance.setStringData(
          SharedPrefConstant.refreshToken,
          refreshApiResponse.data!.refreshToken,
        );

        debugPrint(
            '\x1B[32m[ApiService] Token refreshed successfully.\x1B[0m');
        _refreshCompleter!.complete(true);
        return true;
      } else {
        debugPrint(
            '\x1B[31m[ApiService] Refresh API returned failure. Forcing logout.\x1B[0m');
        await _forceLogout();
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      debugPrint('\x1B[31m[ApiService] Token refresh failed: $e\x1B[0m');
      await _forceLogout();
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ── Force logout: clear data + navigate to SignIn ────────────────────
  static Future<void> _forceLogout() async {
    debugPrint(
        '\x1B[31m[ApiService] Force logout — clearing user data…\x1B[0m');

    // Clear all auth-related data from SharedPreferences
    await SharedPreferencesUtil.instance
        .removeData(SharedPrefConstant.accessToken);
    await SharedPreferencesUtil.instance
        .removeData(SharedPrefConstant.refreshToken);
    await SharedPreferencesUtil.instance
        .removeData(SharedPrefConstant.isLoggedIn);

    // Navigate to SignIn page and remove all previous routes
    final context = navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SignInPage()),
            (route) => false,
      );
    }
  }

  // ── Logging helpers ──────────────────────────────────────────────────
  void _logRequest(
      String url, Map<String, dynamic>? body, Map<String, String> headers) {
    print('\x1B[32mREQUEST URL: $url\x1B[0m');
    print('\x1B[33mHEADERS: $headers\x1B[0m');
    print('\x1B[34mBODY: ${jsonEncode(body)}\x1B[0m');
  }

  void _logResponse(http.Response response) {
    print('\x1B[31mRESPONSE CODE: ${response.statusCode}\x1B[0m');
    print('\x1B[36mRESPONSE BODY: ${response.body}\x1B[0m');
  }
}