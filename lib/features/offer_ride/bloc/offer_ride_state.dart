abstract class OfferRideState {}

class OfferRideInitial extends OfferRideState {}

class OfferRideLoading extends OfferRideState {}

class OfferRideSuccess extends OfferRideState {
  final String message;
  OfferRideSuccess(this.message);
}

class OfferRideFailure extends OfferRideState {
  final String error;
  OfferRideFailure(this.error);
}
