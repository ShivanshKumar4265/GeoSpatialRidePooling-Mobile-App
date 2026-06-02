import 'package:flutter/material.dart';

import '../../../core/utils/custom_text.dart';

class CommuteCard extends StatelessWidget {
  final String title;
  final String route;
  final List<String> tags;
  final String? time;
  final bool isActive;
  final IconData icon;

  const CommuteCard({
    Key? key,
    required this.title,
    required this.route,
    required this.tags,
    this.time,
    this.isActive = false,
    this.icon = Icons.business_center_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: Colors.grey.shade700, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: route,
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
              if (isActive)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D631B),
                    shape: BoxShape.circle,
                  ),
                )
              else if (time != null)
                CustomText(
                  text: time!,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: tags.map((tag) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  text: tag,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}