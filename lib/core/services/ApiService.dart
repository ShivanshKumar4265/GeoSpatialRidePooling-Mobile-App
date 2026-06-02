import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Env.dart';
import 'api_exception.dart';

class ApiService {
  final String baseUrl;

  ApiService([String? baseUrl]) : baseUrl = baseUrl ?? Env.baseUrl;

  // General method to handle various HTTP methods like GET, POST, etc.
  Future<Map<String, dynamic>> request(String method, String endpoint,
      {Map<String, dynamic>? body,
        Map<String, String>? headers,
        bool isFormData = false,
        List<http.MultipartFile>? files}) async {
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
        // throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to make API call: $e');
    }
  }

  void _logRequest(String url, Map<String, dynamic>? body, Map<String, String> headers) {
    print('\x1B[32mREQUEST URL: $url\x1B[0m');
    print('\x1B[33mHEADERS: $headers\x1B[0m');
    print('\x1B[34mBODY: ${jsonEncode(body)}\x1B[0m');
  }

  void _logResponse(http.Response response) {
    print('\x1B[31mRESPONSE CODE: ${response.statusCode}\x1B[0m');
    print('\x1B[36mRESPONSE BODY: ${response.body}\x1B[0m');
  }
}