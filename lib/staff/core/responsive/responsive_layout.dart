import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

/// Define the device types supported by the application
enum DeviceType { mobile, tablet, desktop }

/// A utility class and widget to handle responsive layouts across the app.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  /// Returns true if the screen width is less than [AppSizes.mobileBreakpoint]
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;

  /// Returns true if the screen width is between [AppSizes.mobileBreakpoint] and [AppSizes.tabletBreakpoint]
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.mobileBreakpoint &&
      MediaQuery.of(context).size.width < AppSizes.tabletBreakpoint;

  /// Returns true if the screen width is greater than or equal to [AppSizes.tabletBreakpoint]
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.tabletBreakpoint;

  /// Returns the current [DeviceType] based on the screen width
  static DeviceType deviceType(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width >= AppSizes.tabletBreakpoint) return DeviceType.desktop;
    if (width >= AppSizes.mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppSizes.tabletBreakpoint) {
          return desktop;
        }
        if (constraints.maxWidth >= AppSizes.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

/// A widget that shows its child only on specific device types.
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    final type = ResponsiveLayout.deviceType(context);
    switch (type) {
      case DeviceType.mobile:
        return visibleOnMobile ? child : const SizedBox.shrink();
      case DeviceType.tablet:
        return visibleOnTablet ? child : const SizedBox.shrink();
      case DeviceType.desktop:
        return visibleOnDesktop ? child : const SizedBox.shrink();
    }
  }
}

/// A helper class to return different values based on the current screen size.
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  T get(BuildContext context) {
    final type = ResponsiveLayout.deviceType(context);
    switch (type) {
      case DeviceType.desktop:
        return desktop;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

/// Extension on [BuildContext] to provide easy access to responsive utilities.
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveLayout.isMobile(this);
  bool get isTablet => ResponsiveLayout.isTablet(this);
  bool get isDesktop => ResponsiveLayout.isDesktop(this);
  DeviceType get deviceType => ResponsiveLayout.deviceType(this);
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  T responsive<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) =>
      ResponsiveValue<T>(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ).get(this);
}
