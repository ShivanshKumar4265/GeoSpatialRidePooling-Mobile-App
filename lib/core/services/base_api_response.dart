class BaseApiResponse<T> {
  final bool status;
  final String message;
  final dynamic error;
  final T? data;

  BaseApiResponse({
    required this.status,
    required this.message,
    this.error,
    this.data,
  });

  factory BaseApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic)? fromJsonT,
      ) {
    return BaseApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      error: json['error'],
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }
}