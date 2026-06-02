class PasswrodResponse {
  bool? status;
  String? message;
  String? error;
  Data? data;

  PasswrodResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  PasswrodResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];

    if (json['data'] is Map<String, dynamic>) {
      data = Data.fromJson(json['data']);
    } else {
      data = json['data'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'error': error,
      'data': data is Data ? (data as Data).toJson() : data,
    };
  }
}

class Data {
  String? accessToken;
  String? refreshToken;

  Data({
    this.accessToken,
    this.refreshToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}