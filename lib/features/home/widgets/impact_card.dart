// features/home/widgets/impact_card.dart
import 'package:flutter/material.dart';
import '../../../core/utils/custom_text.dart'; // Verify this path matches your folder structure

class ImpactCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final IconData icon; // Replaced problematic web/GIF links with standard Icons
  final Color backgroundColor;

  const ImpactCard({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
    this.valueColor = const Color(0xFF2E7D32),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Styled Icon Head Box
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: valueColor,
              size: 20,
            ),
          ),

          // Data Content Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: value,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: valueColor,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}