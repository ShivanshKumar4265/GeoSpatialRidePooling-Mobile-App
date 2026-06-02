
import '../../../core/services/base_api_response.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}
// logout state


class StateLogoutLoading extends HomeState {
  bool isLoading;
  StateLogoutLoading({required this.isLoading});
}

class StateLogoutSuccess extends HomeState {
  bool isLoading;

  BaseApiResponse<void> logoutResponse;
  StateLogoutSuccess({required this.logoutResponse, required this.isLoading});
}

class StateLogoutFailure extends HomeState {
  bool isLoading;
  final String error;
  StateLogoutFailure({required this.error, required this.isLoading});
}

