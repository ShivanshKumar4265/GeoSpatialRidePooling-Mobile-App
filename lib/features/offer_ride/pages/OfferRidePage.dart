import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/SnackbarUtil.dart';
import '../../../core/widgets/CustomDropdownField.dart';
import '../../../shared/AppColors.dart';
import '../../../core/widgets/app_text.dart';
import '../bloc/offer_ride_bloc.dart';
import '../bloc/offer_ride_event.dart';
import '../bloc/offer_ride_state.dart';
import '../widgets/GreyFilledInput.dart';
import '../widgets/PreferenceChip.dart';


class OfferRidePage extends StatefulWidget {
  const OfferRidePage({Key? key}) : super(key: key);

  @override
  State<OfferRidePage> createState() => _OfferRidePageState();
}

class _OfferRidePageState extends State<OfferRidePage> {
  final _formKey = GlobalKey<FormState>();

  final _pickupCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _routeStopsCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  double _pickupRadius = 5.0;

  // Controllers - Schedule
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  bool _isReturnRide = false;
  bool _isRepeatRide = true;
  String _repeatType = 'Weekdays';

  // Controllers - Seats & Pricing
  int _availableSeats = 3;
  final _costCtrl = TextEditingController(text: "12");

  // State - Preferences (Using a Set for easy toggling)
  final Set<String> _selectedPreferences = {
    'Luggage Allowed',
    'AC Available',
    'Music Allowed'
  };

  // Controllers - Vehicle Details
  String _vehicleType = 'Sedan';
  final _modelCtrl = TextEditingController(text: "Toyota Camry");
  final _numberCtrl = TextEditingController(text: "ABC-1234");
  final _colorCtrl = TextEditingController(text: "Silver");
  final _totalSeatsCtrl = TextEditingController(text: "5");

  // State - Safety
  bool _shareLocation = true;

  // --- Validation Helpers ---
  String? _requireText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // --- Submit Handler ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Gather all data into a Map
      final rideData = {
        'pickup': _pickupCtrl.text.trim(),
        'landmark': _landmarkCtrl.text.trim(),
        'destination': _destinationCtrl.text.trim(),
        'stops': _routeStopsCtrl.text.trim(),
        'instructions': _instructionsCtrl.text.trim(),
        'radius': _pickupRadius,
        'date': _dateCtrl.text.trim(),
        'time': _timeCtrl.text.trim(),
        'isReturn': _isReturnRide,
        'isRepeat': _isRepeatRide,
        'repeatType': _repeatType,
        'availableSeats': _availableSeats,
        'cost': double.tryParse(_costCtrl.text.trim()) ?? 0.0,
        'preferences': _selectedPreferences.toList(),
        'vehicleType': _vehicleType,
        'vehicleModel': _modelCtrl.text.trim(),
        'vehicleNumber': _numberCtrl.text.trim(),
        'vehicleColor': _colorCtrl.text.trim(),
        'totalSeats': _totalSeatsCtrl.text.trim(),
        'shareLocation': _shareLocation,
      };

      // Fire event to BLoC
      context.read<OfferRideBloc>().add(SubmitOfferRideEvent(rideData: rideData));
    } else {
      SnackbarUtil.showSnackbar(
        context,
        message: "Please fill in all required fields correctly.",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OfferRideBloc, OfferRideState>(
      listener: (context, state) {
        if (state is OfferRideLoading) {
          // You can show a loading dialog here if you want
        } else if (state is OfferRideSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: state.message,
            backgroundColor: AppColors.buttonGreen,
          );
          // Navigator.pop(context); // Go back or to success screen
        } else if (state is OfferRideFailure) {
          SnackbarUtil.showSnackbar(
            context,
            message: state.error,
            backgroundColor: Colors.red,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: AppText(
            text: "Offer Ride",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textGreen,
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder for profile
              ),
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(Icons.route_outlined, "Route Details"),
                _buildCard(_buildRouteDetails()),
                const SizedBox(height: 24),

                _buildSectionTitle(Icons.calendar_month_outlined, "Schedule"),
                _buildCard(_buildScheduleDetails()),
                const SizedBox(height: 24),

                _buildSectionTitle(Icons.payments_outlined, "Seats & Pricing"),
                _buildSeatsPricingSection(), // Custom layout, not standard card
                const SizedBox(height: 24),

                _buildSectionTitle(Icons.tune_outlined, "Preferences"),
                _buildPreferencesSection(),
                const SizedBox(height: 24),

                _buildSectionTitle(Icons.directions_car_outlined, "Vehicle Details"),
                _buildCard(_buildVehicleDetails()),
                const SizedBox(height: 24),

                _buildSectionTitle(Icons.security_outlined, "Safety"),
                _buildCard(_buildSafetyDetails()),
                const SizedBox(height: 100), // Padding for sticky bottom button
              ],
            ),
          ),
        ),
        // Sticky Bottom Button
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: BlocBuilder<OfferRideBloc, OfferRideState>(
                builder: (context, state) {
                  if (state is OfferRideLoading) {
                    return const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    );
                  }
                  return const AppText(
                    text: "Review Ride",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // SUB-WIDGET BUILDERS (Keeping it in one file for copy/paste ease,
  // but logically separated)
  // =========================================================================

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGreen, size: 22),
          const SizedBox(width: 8),
          AppText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildRouteDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GreyFilledInput(
          label: "Pickup Location",
          hint: "Enter pickup point",
          controller: _pickupCtrl,
          validator: (v) => _requireText(v, "Pickup Location"),
        ),
        GreyFilledInput(
          label: "Pickup Landmark",
          hint: "e.g. Near Central Park Gate",
          controller: _landmarkCtrl,
        ),
        GreyFilledInput(
          label: "Destination Location",
          hint: "Enter destination",
          controller: _destinationCtrl,
          validator: (v) => _requireText(v, "Destination"),
        ),
        const Divider(height: 32),
        GreyFilledInput(
          label: "Route Stops (Optional)",
          hint: "Add waypoints separated by commas",
          controller: _routeStopsCtrl,
        ),
        GreyFilledInput(
          label: "Pickup Instructions",
          hint: "e.g. Wait at the blue awning",
          controller: _instructionsCtrl,
          maxLines: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(text: "Flexible Pickup Radius", fontWeight: FontWeight.w600),
            AppText(text: "${_pickupRadius.toStringAsFixed(1)} km", color: AppColors.textGreen, fontWeight: FontWeight.bold),
          ],
        ),
        Slider(
          value: _pickupRadius,
          min: 0,
          max: 10,
          activeColor: AppColors.buttonGreen,
          inactiveColor: Colors.grey.shade300,
          onChanged: (val) => setState(() => _pickupRadius = val),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: "0 km", fontSize: 12, color: Colors.grey),
            AppText(text: "10 km", fontSize: 12, color: Colors.grey),
          ],
        )
      ],
    );
  }

  Widget _buildScheduleDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GreyFilledInput(
                label: "Ride Date",
                hint: "mm/dd/yyyy",
                controller: _dateCtrl,
                validator: (v) => _requireText(v, "Date"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GreyFilledInput(
                label: "Departure Time",
                hint: "--:-- --",
                controller: _timeCtrl,
                validator: (v) => _requireText(v, "Time"),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(text: "Return Ride Toggle", fontSize: 14),
            Switch(
              value: _isReturnRide,
              activeColor: AppColors.buttonGreen,
              onChanged: (val) => setState(() => _isReturnRide = val),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(text: "Repeat Ride Toggle", fontSize: 14),
            Switch(
              value: _isRepeatRide,
              activeColor: AppColors.buttonGreen,
              onChanged: (val) => setState(() => _isRepeatRide = val),
            ),
          ],
        ),
        if (_isRepeatRide)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomDropdownField(
              label: "Repeat Type",
              value: _repeatType,
              items: const ['Weekdays', 'Weekends', 'Daily'],
              onChanged: (val) {
                if (val != null) setState(() => _repeatType = val);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSeatsPricingSection() {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "Available Seats", fontSize: 12, color: Colors.grey.shade700),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        if (_availableSeats > 1) _availableSeats--;
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                        child: const Icon(Icons.remove, size: 16),
                      ),
                    ),
                    AppText(text: "$_availableSeats", fontSize: 20, fontWeight: FontWeight.bold),
                    InkWell(
                      onTap: () => setState(() => _availableSeats++),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
                        child: const Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCard(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "Cost Per Seat", fontSize: 12, color: Colors.grey.shade700),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const AppText(text: "\$ ", fontSize: 18, color: Colors.grey),
                    Expanded(
                      child: TextFormField(
                        controller: _costCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    final prefs = [
      'Luggage Allowed', 'AC Available', 'Women-Only Ride',
      'Smoking Allowed', 'Music Allowed', 'Silent Ride', 'Pets Allowed'
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: prefs.map((pref) {
        final isSelected = _selectedPreferences.contains(pref);
        return PreferenceChip(
          label: pref,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPreferences.remove(pref);
              } else {
                _selectedPreferences.add(pref);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildVehicleDetails() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to top so error texts don't break layout
          children: [
            Expanded(
              child: CustomDropdownField(
                label: "Vehicle Type",
                value: _vehicleType,
                items: const ['Sedan', 'SUV', 'Hatchback', 'Minivan'],
                onChanged: (val) {
                  if (val != null) setState(() => _vehicleType = val);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GreyFilledInput(
                label: "Vehicle Model",
                hint: "Model",
                controller: _modelCtrl,
                validator: (v) => _requireText(v, "Model"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Padding fix for row above
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GreyFilledInput(
                label: "Vehicle Number",
                hint: "ABC-1234",
                controller: _numberCtrl,
                validator: (v) => _requireText(v, "Number"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: GreyFilledInput(
                label: "Color",
                hint: "Color",
                controller: _colorCtrl,
                validator: (v) => _requireText(v, "Color"),
              ),
            ),
          ],
        ),
        GreyFilledInput(
          label: "Total Seats (incl. driver)",
          hint: "Seats",
          controller: _totalSeatsCtrl,
          keyboardType: TextInputType.number,
          validator: (v) => _requireText(v, "Total Seats"),
        ),
      ],
    );
  }

  Widget _buildSafetyDetails() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.contact_mail_outlined, color: Colors.black87),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(text: "Emergency Contact Sharing", fontWeight: FontWeight.bold),
              AppText(text: "Share live location with emergency contacts", fontSize: 12, color: Colors.grey.shade600),
            ],
          ),
        ),
        Switch(
          value: _shareLocation,
          activeColor: AppColors.buttonGreen,
          onChanged: (val) => setState(() => _shareLocation = val),
        )
      ],
    );
  }
}