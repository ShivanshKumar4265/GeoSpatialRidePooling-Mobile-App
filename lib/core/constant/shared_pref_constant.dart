class SharedPrefConstant {
  static const String isFirstTime = 'isFirstTime';
  static const String isLoggedIn = 'isLoggedIn';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  // if access token is expired then we can use refresh token to get new access token,
  // but if refresh token is expired then user need to login again
  static  const String REFRESH_TOKEN_EXPIRED = "REFRESH_TOKEN_EXPIRED";
  static const String ACCESS_TOKEN_EXPIRED = "ACCESS_TOKEN_EXPIRED";
}
