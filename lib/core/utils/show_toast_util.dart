import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  static void showToast({
    required String message,
    ToastGravity gravity = ToastGravity.BOTTOM, // Default gravity
    Toast toastLength = Toast.LENGTH_SHORT,   // Default toast length
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,  // Time duration for iOS (Web and iOS have different durations)
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
