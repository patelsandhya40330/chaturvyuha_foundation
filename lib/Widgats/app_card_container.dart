import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';

class AppCardContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final DecorationImage? image;
  final double? height;
  final double? width;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const AppCardContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor = AppColor.white,
    this.borderColor = AppColor.border,
    this.onTap,
    this.image,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.boxShadow,
    this.clipBehavior = Clip.none,
  });

  @override
  State<AppCardContainer> createState() => _AppCardContainerState();
}

class _AppCardContainerState extends State<AppCardContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          padding: widget.padding,
          alignment: widget.alignment,
          clipBehavior: widget.clipBehavior,
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.02, 1.02, 1.0)
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            image: widget.image,
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.borderRadius)
                : null,
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!)
                : null,
            boxShadow: [
              ...?widget.boxShadow,
              if (_isHovered)
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
