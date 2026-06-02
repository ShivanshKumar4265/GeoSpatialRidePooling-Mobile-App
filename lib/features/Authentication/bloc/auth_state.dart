import 'package:geo_spatial_ride_pooling_system_2/core/services/base_api_response.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/modal/refresh_token_data.dart';

import '../modal/auth_response.dart';

sealed class AuthState {}

class AuthInitialEvent extends AuthState {}


// state for create password
class StateCreatePasswordLoading extends AuthState {}

class StateCreatePasswordSuccess extends AuthState {
  final BaseApiResponse<AuthData> passwrodResponse;
  StateCreatePasswordSuccess(this.passwrodResponse);
}

class StateCreatePasswordFailure extends AuthState {
  final String error;
  StateCreatePasswordFailure(this.error);
}

class StateInvalidInput extends AuthState {
  final String message;
  StateInvalidInput(this.message);
}

// state for login

class StateLoginLoading extends AuthState {}

class StateLoginSuccess extends AuthState {
  final BaseApiResponse<AuthData> loginResponse;
  StateLoginSuccess(this.loginResponse);
}

class StateLoginFailure extends AuthState {
  final String error;
  StateLoginFailure(this.error);
}

class StateLoginInvalidInput extends AuthState {
  final String message;
  StateLoginInvalidInput(this.message);
}

// refresh token state

class StateRefreshTokenLoading extends AuthState {}

class StateRefreshTokenSuccess extends AuthState {
  final BaseApiResponse<RefreshTokenData> refreshTokenResponse;
  StateRefreshTokenSuccess(this.refreshTokenResponse);
}

class StateRefreshTokenFailure extends AuthState {
  final String error;
  StateRefreshTokenFailure(this.error);
}