import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/modal/password_response.dart';

sealed class AuthState {}

class AuthInitialEvent extends AuthState {}

class StateCreatePasswordLoading extends AuthState {}

class StateCreatePasswordSuccess extends AuthState {
  final PasswrodResponse passwrodResponse;
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