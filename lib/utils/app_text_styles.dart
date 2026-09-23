import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Hero main heading - Large, bold, serif-like
  static const TextStyle heroHeading = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    color: AppColor.heading,
    fontFamily: 'Georgia',
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Secondary hero text (italic/serif)
  static const TextStyle heroSubheading = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: AppColor.primary,
    fontFamily: 'Georgia',
    height: 1.25,
  );

  // Legacy heading (used in some screens)
  static const TextStyle heading = TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.w700,
    color: AppColor.heading,
    height: 1.2,
    letterSpacing: -0.5,
  );

  // Standard headings
  static const TextStyle heading2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColor.heading,
    height: 1.3,
  );

  // Smaller section heading
  static const TextStyle subheading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColor.heading,
    height: 1.35,
  );

  // Card title
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColor.heading,
    height: 1.35,
  );

  // Nav buttons - centered, multi-line support
  static const TextStyle navButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColor.heading,
    height: 1.3,
  );

  static const TextStyle navButtonActive = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
    height: 1.3,
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyText,
    height: 1.6,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyText,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.bodyText,
    height: 1.5,
  );

  // Labels (e.g., WISDOM • WELLNESS)
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
    letterSpacing: 1.5,
    height: 1.5,
  );

  // Wisdom / Wellness / Community labels
  static const TextStyle bulletLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColor.primary,
    letterSpacing: 1.2,
    height: 1.5,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Explore / Learn more links
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColor.primary,
    height: 1.5,
  );

  // Tagline
  static const TextStyle tagline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColor.bodyText,
    height: 1.5,
  );

  // Caption styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.bodyText,
    letterSpacing: 0.5,
  );
}
