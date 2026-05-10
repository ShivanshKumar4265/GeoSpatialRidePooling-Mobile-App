import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Env.dart';
// import '../../core/constants/api_constant.dart';


class ApiService {
  final String baseUrl;

  // ApiService([this.baseUrl = ApiConstants.baseUrl]);

  ApiService([String? baseUrl]) : baseUrl = baseUrl ?? Env.baseUrl;


  // General method to handle various HTTP methods like GET, POST, etc.
  Future<Map<String, dynamic>> request(String method, String endpoint,
      {Map<String, dynamic>? body,
        Map<String, String>? headers,
        bool isFormData = false,
        List<http.MultipartFile>? files}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final defaultHeaders = {
      'Content-Type': 'application/json', // Default content type for JSON
      ...?headers,
    };

    try {
      http.Response response;

      if (method == 'POST' && isFormData) {
        var request = http.MultipartRequest('POST', url)
          ..headers.addAll(defaultHeaders);

        if (files != null) {
          // Add files to the request
          for (var file in files) {
            request.files.add(file);
          }
        }

        if (body != null) {
          // Add form fields (non-file data)
          body.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        response = await http.Response.fromStream(await request.send());
      } else {
        // For GET, POST, PUT, DELETE with JSON body or other headers
        if (method == 'POST' || method == 'PUT' || method == 'DELETE') {
          response = await http.post(url,
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
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to make API call: $e');
    }
  }

  void _logRequest(String url, Map<String, dynamic>? body, Map<String, String> headers) {
    print('\x1B[32mREQUEST URL: $url\x1B[0m'); // Green color for request URL
    print('\x1B[33mHEADERS: $headers\x1B[0m'); // Yellow color for headers
    print('\x1B[34mBODY: ${jsonEncode(body)}\x1B[0m'); // Blue color for body
  }



  // Log response with color coding
  void _logResponse(http.Response response) {
    print('\x1B[31mRESPONSE CODE: ${response.statusCode}\x1B[0m'); // Red color for response code
    print('\x1B[36mRESPONSE BODY: ${response.body}\x1B[0m'); // Cyan color for response body
  }
}
