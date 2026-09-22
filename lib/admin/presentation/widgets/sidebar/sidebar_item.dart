import 'package:flutter/material.dart';


class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final bool collapsed;
  final bool hasChevron;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.collapsed,
    required this.onTap,
    this.hasChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: EdgeInsets.symmetric(
        horizontal: collapsed ? 0 : 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: selected ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment:
            collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: selected ? Colors.white : Colors.white.withValues(alpha: 0.84),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.84),
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (hasChevron)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 17,
                color: Colors.white.withValues(alpha: 0.7),
              ),
          ],
        ],
      ),
    );

    return Tooltip(
      message: collapsed ? title : '',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
