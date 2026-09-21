import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'sidebar_item.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final bool collapsed;
  final ValueChanged<int> onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.collapsed,
    required this.onItemSelected,
  });

  static const _items = [
    (title: 'Dashboard', icon: Icons.dashboard_outlined),
    (title: 'Content', icon: Icons.article_outlined),
    (title: 'Pages', icon: Icons.web_outlined),
    (title: 'Programs', icon: Icons.auto_awesome_outlined),
    (title: 'Events', icon: Icons.event_outlined),
    (title: 'Media', icon: Icons.perm_media_outlined),
    (title: 'Announcements', icon: Icons.campaign_outlined),
    (title: 'Messages', icon: Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: collapsed
          ? AppConstants.collapsedSidebarWidth
          : AppConstants.sidebarWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryRed,
            AppConstants.deepRed,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _Logo(collapsed: collapsed),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return SidebarItem(
                    title: item.title,
                    icon: item.icon,
                    selected: selectedIndex == index,
                    collapsed: collapsed,
                    hasChevron: index > 0 && index < 4,
                    onTap: () => onItemSelected(index),
                  );
                },
              ),
            ),
            const Divider(
              color: Colors.white24,
              indent: 14,
              endIndent: 14,
            ),
            _UserFooter(collapsed: collapsed),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool collapsed;

  const _Logo({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54),
            ),
            alignment: Alignment.center,
            child: Image.asset("assets/logo.jpeg",
            
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(height: 8),
            const Text(
              'ESTO 2082',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserFooter extends StatelessWidget {
  final bool collapsed;

  const _UserFooter({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
      child: Row(
        mainAxisAlignment:
            collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Text(
              'S',
              style: TextStyle(
                color: AppConstants.primaryRed,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sitaram Rokka',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Staff',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.settings_outlined,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ],
      ),
    );
  }
}
