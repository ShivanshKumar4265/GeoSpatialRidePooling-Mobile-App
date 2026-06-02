import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/error_mapper.dart';
import '../repository/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<EventLogout>(_onEventLogout);
  }

  Future<void> _onEventLogout(
    EventLogout event,
    Emitter<HomeState> emit,
  ) async {
    emit(StateLogoutLoading(isLoading: true));

    try {
      final result = await _repository.logout();
      emit(StateLogoutSuccess(logoutResponse: result, isLoading: false));
    } catch (e) {
      emit(
        StateLogoutFailure(
          error: ErrorMapper.map(e),
          // Maps to your custom error type/UI handler
          isLoading: false,
        ),
      );
    }
  }
}
