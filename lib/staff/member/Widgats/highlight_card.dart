import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HighlightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0DC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.primary, size: 28),
          ),
          const SizedBox(height: 20),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: 12),
          Text(description, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
