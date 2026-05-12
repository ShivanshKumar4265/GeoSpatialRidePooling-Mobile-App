import 'package:flutter/material.dart';

import '../../shared/AppColors.dart';
import '../utils/custom_text.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  // ADDED THIS
  final bool isEditable;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,

    // OPTIONAL BY DEFAULT TRUE
    this.isEditable = true,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),

        const SizedBox(height: 8),

        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,

          // ADDED THIS
          enabled: widget.isEditable,

          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),

            prefixIcon: Icon(
              widget.prefixIcon,
              color: Colors.grey.shade600,
              size: 20,
            ),

            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureText = !_obscureText),
            )
                : null,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.buttonGreen,
                width: 1.5,
              ),
            ),

            // OPTIONAL LOOK FOR DISABLED FIELD
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            filled: !widget.isEditable,
            fillColor: widget.isEditable
                ? Colors.transparent
                : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}