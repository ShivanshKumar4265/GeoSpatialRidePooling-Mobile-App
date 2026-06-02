class ApiException implements Exception {
  final int statusCode;
  final Map<String, dynamic>? response;

  ApiException({
    required this.statusCode,
    this.response,
  });

  @override
  String toString() {
    return response?['message'] ??
        'Request failed with status $statusCode';
  }
}