import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const SectionLabel({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Replaced generic circle with Foundation Logo image
        Image.asset(
          'assets/chaturvedal-logo.png',
          width: 14,
          height: 14,
          color: color ?? const Color(0xFFF18406),
          errorBuilder: (context, error, stackTrace) => Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color ?? const Color(0xFFC19A6B),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: color ?? const Color(0xFFC19A6B),
            ),
          ),
        ),
      ],
    );
  }
}
