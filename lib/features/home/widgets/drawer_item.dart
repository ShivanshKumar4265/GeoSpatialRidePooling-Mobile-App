import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/custom_text.dart';
import '../../../shared/AppColors.dart';

Widget buildDrawerItem({
  required IconData icon,
  required String title,
  bool isSelected = false,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: isSelected ? Colors.grey.shade100 : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.buttonGreen : Colors.grey.shade700,
        size: 22,
      ),
      title: CustomText(
        text: title,
        fontSize: 15,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? AppColors.buttonGreen : Colors.black87,
      ),
      onTap: () {},
      dense: true,
    ),
  );
}