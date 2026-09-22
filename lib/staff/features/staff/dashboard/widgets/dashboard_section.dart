import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: context.responsive<double>(mobile: 16, tablet: 18, desktop: 20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (actions != null) ...[
              const SizedBox(width: 8),
              Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.s16),
        Card(
          color: AppColors.cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            side: const BorderSide(color: AppColors.border),
          ),
          child: child,
        ),
      ],
    );
  }
}
