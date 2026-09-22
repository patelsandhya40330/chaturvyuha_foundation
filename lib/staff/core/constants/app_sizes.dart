import 'package:flutter/material.dart';

class AppSizes {
  // Spacing System (8px)
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s64 = 64.0;

  // Component Specific
  static const double buttonHeight = 44.0;
  static const double inputHeight = 44.0;
  static const double sidebarWidth = 250.0;
  static const double navItemHeight = 44.0;
  static const double iconSize = 20.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0; // Buttons, Inputs
  static const double radiusLarge = 12.0; // Cards
  static const double radiusExtraLarge = 16.0;

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  // Breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;
}
