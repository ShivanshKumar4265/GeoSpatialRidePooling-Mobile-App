import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/utils/validate.dart';
import 'package:geo_spatial_ride_pooling_system_2/features/Authentication/repository/auth_repo.dart';

import '../../../core/services/error_mapper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitialEvent()) {
    on<EventCreatePassword>(_onEventCreatePassword);
    on<EventLogin>(_onEventLogin);
  }

  Future<void> _onEventCreatePassword(
      EventCreatePassword event,
      Emitter<AuthState> emit,
      ) async {
    emit(StateCreatePasswordLoading());

    final validationError = _validate(event);
    if (validationError != null) {
      emit(StateInvalidInput(validationError));
      return;
    }

    try {
      final result = await _repository.createPassword(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      emit(StateCreatePasswordSuccess(result));
    } catch (e) {
      emit(
        StateCreatePasswordFailure(
          ErrorMapper.map(e),
        ),
      );
    }
  }



  Future<void> _onEventLogin(
      EventLogin event,
      Emitter<AuthState> emit,
      ) async {
    emit(StateLoginLoading());

    final validationError = _validate(event);
    if (validationError != null) {
      emit(StateLoginInvalidInput(validationError));
      return;
    }

    try {
      final result = await _repository.login(
        email: event.email,
        password: event.password,
      );

      emit(StateLoginSuccess(result));
    } catch (e) {
      debugPrint('rr Login error: $e');
      emit(
        StateLoginFailure(
          ErrorMapper.map(e),
        ),
      );
    }
  }


  String? _validate(dynamic event) {
    if (event is EventCreatePassword || event is EventLogin) {
      if (!isValidEmail(event.email)) {
        return 'Please enter a valid email address';
      }

      if (!isValidPassword(event.password)) {
        return 'Password must be at least 8 characters, include an uppercase letter, and a number or symbol';
      }
    }

    if (event is EventCreatePassword) {
      if (!isValidPassword(event.confirmPassword)) {
        return 'Confirm password must be at least 8 characters, include an uppercase letter, and a number or symbol';
      }

      if (event.password != event.confirmPassword) {
        return 'Passwords do not match';
      }
    }

    return null;
  }
}
