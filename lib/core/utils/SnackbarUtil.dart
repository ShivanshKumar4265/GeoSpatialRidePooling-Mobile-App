import 'package:flutter/material.dart';

class SnackbarUtil {
  // Private constructor to prevent instantiation
  SnackbarUtil._();

  /// Shows a SnackBar with a dynamic message and color
  static void showSnackbar(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        Duration duration = const Duration(seconds: 3),
      }) {
    // Remove any existing SnackBars
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show the new SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
