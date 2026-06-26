import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';
import '../../../shared/AppColors.dart';

class PreferenceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferenceChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonGreen : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 4),
            ],
            AppText(
              text: label,
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }
}