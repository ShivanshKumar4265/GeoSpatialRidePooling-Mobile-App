import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/modal/user.dart';

class AuthData {
  final String? accessToken;
  final String? refreshToken;
  final User? user;

  AuthData({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null,
    );
  }
}