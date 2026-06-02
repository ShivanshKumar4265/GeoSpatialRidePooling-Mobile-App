import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/Env.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/utils/validate.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/modal/password_response.dart';

import '../../../core/constant/shared_pref_constant.dart';
import '../../../core/services/ApiService.dart';
import '../../../core/services/api_exception.dart';
import '../../../core/utils/shared_pref_util.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;
  AuthBloc(this._apiService) : super(AuthInitialEvent()) {
    on<EventCreatePassword>(_onEventCreatePassword);
  }

  Future<void> _onEventCreatePassword(
    EventCreatePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(StateCreatePasswordLoading());

    if(!isValidEmail(event.email)) {
      emit(StateInvalidInput('Invalid email format'));
      return;
    }

    if (!isValidPassword(event.password)) {
      emit(StateInvalidInput(
          "Password must be at least 8 characters, include an uppercase letter, and a number or symbol"));
      return;
    }

    if (!isValidPassword(event.confirmPassword)) {
      emit(StateInvalidInput(
          "Confirm Password must be at least 8 characters, include an uppercase letter, and a number or symbol"));
      return;
    }

    if(event.password != event.confirmPassword) {
      emit(StateInvalidInput('Passwords do not match'));
      return;
    }

    try {
      final response = await _apiService.request(
        'POST',
        Env.passwrod,
        body: {
          'email': event.email,
          'password': event.password,
          'confirm_password': event.confirmPassword,
        },
      );
      final model = PasswrodResponse.fromJson(response);
      if(model.status ?? false){
        SharedPreferencesUtil.instance.setBoolData(SharedPrefConstant.isLoggedIn, true);
        SharedPreferencesUtil.instance.setStringData(SharedPrefConstant.accessToken, model.data?.accessToken ?? '');
        SharedPreferencesUtil.instance.setStringData(SharedPrefConstant.refreshToken, model.data?.refreshToken ?? '');
        emit(StateCreatePasswordSuccess(model));
      }else{
        emit(StateCreatePasswordFailure(model.message??"Something went wrong, try again"));
      }

    } catch (e) {
      if (e is ApiException) {

        switch (e.statusCode) {

          case 400:
            emit(
              StateCreatePasswordFailure(
                e.response?['message'] ?? 'Bad Request',
              ),
            );
            break;

          case 401:
            emit(
              StateCreatePasswordFailure(
                e.response?['message'] ?? 'Unauthorized',
              ),
            );
            break;

          case 409:
            emit(
              StateCreatePasswordFailure(
                e.response?['message'] ?? 'Conflict',
              ),
            );
            break;

          case 500:
            emit(
              StateCreatePasswordFailure(
                'Internal Server Error',
              ),
            );
            break;

          default:
            emit(
              StateCreatePasswordFailure(
                e.response?['message'] ?? 'Something went wrong',
              ),
            );
        }

      } else {
        emit(
          StateCreatePasswordFailure(
            e.toString(),
          ),
        );
      }
    }
  }
}
