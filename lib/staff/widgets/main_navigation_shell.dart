import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class MainNavigationShell extends StatefulWidget {
  final Widget content;
  final int currentMenuIndex;
  final ValueChanged<int> onMenuSelected;

  const MainNavigationShell({
    super.key,
    required this.content,
    required this.currentMenuIndex,
    required this.onMenuSelected,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'title': 'Articles / Content', 'icon': Icons.article_outlined},
    {'title': 'Pages', 'icon': Icons.pages_outlined},
    {'title': 'Programs', 'icon': Icons.school_outlined},
    {'title': 'Events', 'icon': Icons.event_outlined},
    {'title': 'Media', 'icon': Icons.perm_media_outlined},
    {'title': 'Announcements', 'icon': Icons.campaign_outlined},
    {'title': 'Messages', 'icon': Icons.message_outlined},
    {'title': 'Notifications', 'icon': Icons.notifications_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: !isDesktop
          ? AppBar(
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/WhatsApp Image 2026-09-20 at 10.29.20.jpeg',
                      height: 32,
                      width: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.auto_awesome,
                        color: AppColors.secondary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.s16),
                  const Text(
                    'CHATURVYUHA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.surface,
              elevation: 1,
            )
          : null,
      drawer: !isDesktop
          ? Drawer(
              child: _buildSidebar(context),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.s24),
                  child: widget.content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      height: double.infinity,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: AppSizes.s16),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final bool isSelected = widget.currentMenuIndex == index;

                return InkWell(
                  onTap: () {
                    widget.onMenuSelected(index);
                    if (!ResponsiveLayout.isDesktop(context)) {
                      Navigator.pop(context); // Close drawer on mobile/tablet
                    }
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  child: Container(
                    height: AppSizes.navItemHeight,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Stack(
                      children: [
                        if (isSelected)
                          Positioned(
                            left: 0,
                            top: 10,
                            bottom: 10,
                            child: Container(
                              width: 3,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(2),
                                  bottomRight: Radius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'],
                                color: isSelected ? AppColors.secondary : AppColors.textDisabled,
                                size: AppSizes.iconSize,
                              ),
                              const SizedBox(width: AppSizes.s16),
                              Expanded(
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    color: isSelected ? AppColors.textWhite : AppColors.textDisabled,
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF374151))),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              'assets/images/WhatsApp Image 2026-09-20 at 10.29.20.jpeg',
              height: 32,
              width: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.auto_awesome,
                color: AppColors.secondary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.s16),
          const Text(
            'CF STAFF',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
