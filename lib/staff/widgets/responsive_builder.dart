import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
