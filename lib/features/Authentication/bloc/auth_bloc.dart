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


  String? _validate(EventCreatePassword event) {
    if (!isValidEmail(event.email)) {
      return 'Invalid email format';
    }

    if (!isValidPassword(event.password)) {
      return 'Password must be at least 8 characters, include an uppercase letter, and a number or symbol';
    }

    if (!isValidPassword(event.confirmPassword)) {
      return 'Confirm Password must be at least 8 characters, include an uppercase letter, and a number or symbol';
    }

    if (event.password != event.confirmPassword) {
      return 'Passwords do not match';
    }

    return null; // means everything is valid
  }

  // Future<void> _onEventCreatePassword(
  //   EventCreatePassword event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(StateCreatePasswordLoading());
  //
  //   if (!isValidEmail(event.email)) {
  //     emit(StateInvalidInput('Invalid email format'));
  //     return;
  //   }
  //
  //   if (!isValidPassword(event.password)) {
  //     emit(
  //       StateInvalidInput(
  //         "Password must be at least 8 characters, include an uppercase letter, and a number or symbol",
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (!isValidPassword(event.confirmPassword)) {
  //     emit(
  //       StateInvalidInput(
  //         "Confirm Password must be at least 8 characters, include an uppercase letter, and a number or symbol",
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (event.password != event.confirmPassword) {
  //     emit(StateInvalidInput('Passwords do not match'));
  //     return;
  //   }
  //
  //   try {
  //     final passwordResponse = await _repository.createPassword(
  //       email: event.email,
  //       password: event.password,
  //       confirmPassword: event.confirmPassword,
  //     );
  //
  //     if (passwordResponse.status ?? false) {
  //       SharedPreferencesUtil.instance.setBoolData(
  //         SharedPrefConstant.isLoggedIn,
  //         true,
  //       );
  //       SharedPreferencesUtil.instance.setStringData(
  //         SharedPrefConstant.accessToken,
  //         passwordResponse.data?.accessToken ?? '',
  //       );
  //       SharedPreferencesUtil.instance.setStringData(
  //         SharedPrefConstant.refreshToken,
  //         passwordResponse.data?.refreshToken ?? '',
  //       );
  //       emit(StateCreatePasswordSuccess(passwordResponse));
  //     } else {
  //       emit(
  //         StateCreatePasswordFailure(
  //           passwordResponse.message ?? "Something went wrong, try again",
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     if (e is ApiException) {
  //       switch (e.statusCode) {
  //         case 400:
  //           emit(
  //             StateCreatePasswordFailure(
  //               e.response?['message'] ?? 'Bad Request',
  //             ),
  //           );
  //           break;
  //
  //         case 401:
  //           emit(
  //             StateCreatePasswordFailure(
  //               e.response?['message'] ?? 'Unauthorized',
  //             ),
  //           );
  //           break;
  //
  //         case 409:
  //           emit(
  //             StateCreatePasswordFailure(e.response?['message'] ?? 'Conflict'),
  //           );
  //           break;
  //
  //         case 500:
  //           emit(StateCreatePasswordFailure('Internal Server Error'));
  //           break;
  //
  //         default:
  //           emit(
  //             StateCreatePasswordFailure(
  //               e.response?['message'] ?? 'Something went wrong',
  //             ),
  //           );
  //       }
  //     } else {
  //       emit(StateCreatePasswordFailure(e.toString()));
  //     }
  //   }
  // }
}
