import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'offer_ride_event.dart';
import 'offer_ride_state.dart';
import '../../../core/utils/log.dart'; // Using your provided log.dart

class OfferRideBloc extends Bloc<OfferRideEvent, OfferRideState> {
  OfferRideBloc() : super(OfferRideInitial()) {
    on<SubmitOfferRideEvent>(_onSubmitOfferRide);
  }

  Future<void> _onSubmitOfferRide(
      SubmitOfferRideEvent event, Emitter<OfferRideState> emit) async {
    emit(OfferRideLoading());
    try {
      mylog('API Call Triggered: Submitting Offer Ride Data: ${event.rideData}');

      // ==========================================
      // 📍 PUT YOUR API CALL HERE
      // final response = await repository.submitRide(event.rideData);
      // ==========================================

      // Simulating network delay
      await Future.delayed(const Duration(seconds: 2));

      emit(OfferRideSuccess("Ride offered successfully!"));
    } catch (e) {
      mylog('API Error: $e');
      emit(OfferRideFailure("Failed to submit ride. Please try again."));
    }
  }
}