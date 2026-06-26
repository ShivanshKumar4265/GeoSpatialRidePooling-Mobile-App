
abstract class OfferRideEvent {}

class SubmitOfferRideEvent extends OfferRideEvent {
  // We pass a map of the validated data. You can easily convert this to a Model class later.
  final Map<String, dynamic> rideData;

  SubmitOfferRideEvent({required this.rideData});
}
