import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool showIcon;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.showIcon = true,
    this.width,
    this.padding,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppColor.primary
              : const Color(0xFFF2EEE7),
          foregroundColor: isPrimary ? Colors.white : AppColor.heading,
          elevation: 0,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : AppColor.heading,
                ),
              ),
            ),
            if (showIcon) ...[
              const SizedBox(width: 8),
              Icon(
                icon ??
                    (isPrimary ? Icons.arrow_forward : Icons.explore_outlined),
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
