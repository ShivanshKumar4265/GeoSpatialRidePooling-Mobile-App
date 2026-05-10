import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color color;
  final TextAlign textAlign; // Added textAlign property
  final Widget? leadingIcon; // Added the leadingIcon property
  final bool isUnderlined; // New property to control underlining

  // Constructor to receive parameters
  const CustomText({
    Key? key,
    required this.text,
    this.fontSize = 16.0, // Default font size
    this.fontFamily = 'Outfit', // Default font family
    this.fontWeight = FontWeight.normal, // Default font weight
    this.fontStyle = FontStyle.normal, // Default font style
    this.color = Colors.black, // Default text color
    this.textAlign = TextAlign.start, // Default text alignment (left aligned)
    this.leadingIcon, // Optional leading icon
    this.isUnderlined = false, // Default to no underline
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Apply the alignment here
      style: TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        color: color,
        decoration: isUnderlined
            ? TextDecoration.underline
            : TextDecoration.none, // Conditionally add underline
      ),
    );
  }
}
