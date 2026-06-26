import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart'; // Verify this path

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 6),

          DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            validator: validator,

            // 1. FIX OVERFLOW: Forces the text to fit within the Expanded constraints
            isExpanded: true,

            // 2. MATCH IMAGE ICON: Uses the sharp drop-down arrow
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),

            // 3. POPUP MENU STYLING (Matches your 2nd image)
            dropdownColor: Colors.white, // Clean white background for the list
            elevation: 4, // Adds the floating shadow
            borderRadius: BorderRadius.circular(12), // Smooth rounded corners

            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Outfit',
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),

            decoration: InputDecoration(
              // 4. FIX HEIGHT: This ensures it matches GreyFilledInput perfectly
              isDense: true,

              filled: true,
              fillColor: Colors.grey.shade100, // Matches your other form fields
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
            ),

            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}