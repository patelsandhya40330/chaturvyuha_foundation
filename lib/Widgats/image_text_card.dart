import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ImageTextCard extends StatelessWidget {
  final String imagePath;
  final String? text;

  const ImageTextCard({super.key, required this.imagePath, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.primary),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          if (text != null && text!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
