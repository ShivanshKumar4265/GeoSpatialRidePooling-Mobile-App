import 'package:flutter/material.dart';
import 'package:geo_spatial_ride_pooling_system_2/shared/AppColors.dart';
import '../../../core/widgets/app_text.dart'; // Verify this path matches your AppText layout

class CustomActionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final IconData? headerIcon;
  final Color? iconColor;

  const CustomActionDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.headerIcon,
    this.iconColor,
  }) : super(key: key);

  /// Convenient static helper to trigger the dialog smoothly from anywhere in your code
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonText,
    required String secondaryButtonText,
    required VoidCallback onPrimaryPressed,
    required VoidCallback onSecondaryPressed,
    IconData? headerIcon,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing accidentally by clicking background shadow
      builder: (context) => CustomActionDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        headerIcon: headerIcon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Matches premium curved design language
      ),
      elevation: 6,
      child: Container(
        // Keeps dialog layout perfectly dimensioned across tiny phones and wide tablets
        constraints: BoxConstraints(
          maxWidth: screenWidth > 600 ? 400 : screenWidth * 0.88,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Hugs content perfectly to avoid blank empty heights
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Optional Modern Header Decoration (if provided)
            if (headerIcon != null) ...[
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.buttonGreen).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  headerIcon,
                  color: iconColor ?? AppColors.buttonGreen,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 2. Dynamic Title Section
            AppText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // 3. Dynamic Message Body (Wrapped in Flexible + Scrollable to guarantee ZERO overflows)
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: AppText(
                  text: message,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Responsive Dual Action Buttons Row
            Row(
              children: [
                // Secondary Button (Cancel / Back Action)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryPressed,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.grey.shade50,
                    ),
                    child: AppText(
                      text: secondaryButtonText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Primary Button (Confirm / Proceed Action)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: AppText(
                      text: primaryButtonText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}