import 'api_exception.dart';

class ErrorMapper {
  static String map(Object e) {
    if (e is ApiException) {
      return e.response?['message'] ??
          _mapStatusCode(e.statusCode);
    }

    return e.toString();
  }

  static String _mapStatusCode(int code) {
    switch (code) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 409:
        return 'Conflict';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Something went wrong';
    }
  }
}