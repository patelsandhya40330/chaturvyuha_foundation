import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

/// A grid system that automatically adjusts the number of columns based on screen size.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final int desktopCrossAxisCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.mobileCrossAxisCount = 1,
    this.tabletCrossAxisCount = 2,
    this.desktopCrossAxisCount = 4,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = context.responsive<int>(
          mobile: mobileCrossAxisCount,
          tablet: tabletCrossAxisCount,
          desktop: desktopCrossAxisCount,
        );

        // Using Wrap for flexibility, but could also use GridView.builder
        final double itemWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth.floorToDouble(),
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
