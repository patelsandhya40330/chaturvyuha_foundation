import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum StatusType { success, error, warning, info }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case StatusType.success:
        color = AppColors.success;
        break;
      case StatusType.error:
        color = AppColors.error;
        break;
      case StatusType.warning:
        color = AppColors.warning;
        break;
      case StatusType.info:
        color = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
