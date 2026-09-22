import 'package:cfoundation/core/auth/permission_service.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

/// Structured navigation model for the dashboard sidebar
class SidebarItemModel {
  final String title;
  final IconData icon;
  final String? permission;
  final int index;
  final int badgeCount;

  const SidebarItemModel({
    required this.title,
    required this.icon,
    required this.index,
    this.permission,
    this.badgeCount = 0,
  });
}

class ResponsiveStaffScaffold extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final Widget body;

  const ResponsiveStaffScaffold({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.body,
  });

  /// Master list of navigation items
  static const List<SidebarItemModel> navigationItems = [
    SidebarItemModel(title: 'Dashboard', icon: Icons.dashboard_outlined, index: 0),
    SidebarItemModel(title: 'Content', icon: Icons.article_outlined, permission: AppPermissions.articlesView, index: 1),
    SidebarItemModel(title: 'Pages', icon: Icons.pages_outlined, permission: AppPermissions.pagesView, index: 2),
    SidebarItemModel(title: 'Programs', icon: Icons.school_outlined, permission: AppPermissions.programsView, index: 3),
    SidebarItemModel(title: 'Events', icon: Icons.event_outlined, permission: AppPermissions.eventsView, index: 4),
    SidebarItemModel(title: 'Media', icon: Icons.perm_media_outlined, permission: AppPermissions.mediaView, index: 5),
    SidebarItemModel(title: 'Announcements', icon: Icons.campaign_outlined, permission: AppPermissions.announcementsView, index: 6),
    SidebarItemModel(title: 'Messages', icon: Icons.message_outlined, permission: AppPermissions.messagesView, index: 7, badgeCount: 5),
    SidebarItemModel(title: 'Notifications', icon: Icons.notifications_outlined, index: 8, badgeCount: 12),
    SidebarItemModel(title: 'Members', icon: Icons.people_outline, permission: AppPermissions.membersView, index: 10),
    SidebarItemModel(title: 'Reports', icon: Icons.bar_chart_outlined, permission: AppPermissions.reportsView, index: 11),
    SidebarItemModel(title: 'SEO', icon: Icons.search_outlined, permission: AppPermissions.seoManage, index: 12),
    SidebarItemModel(title: 'Settings', icon: Icons.settings_outlined, index: 9),
  ];

  static List<SidebarItemModel> getFilteredItems() {
    return navigationItems.where((item) {
      if (item.permission == null) return true;
      return PermissionService.hasPermission(item.permission!);
    }).toList();
  }

  @override
  State<ResponsiveStaffScaffold> createState() => _ResponsiveStaffScaffoldState();
}

class _ResponsiveStaffScaffoldState extends State<ResponsiveStaffScaffold> {
  bool _isDesktopSidebarOpen = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleSidebar() {
    if (context.isMobile || context.isTablet) {
      if (_scaffoldKey.currentState?.isDrawerOpen == true) {
        Navigator.pop(context);
      } else {
        _scaffoldKey.currentState?.openDrawer();
      }
    } else {
      setState(() {
        _isDesktopSidebarOpen = !_isDesktopSidebarOpen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.isDesktop;
    final bool isTablet = context.isTablet;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: StaffSidebar(
          currentIndex: widget.currentIndex,
          onIndexChanged: widget.onIndexChanged,
          isCollapsed: false,
          isMobileDrawer: true,
        ),
      ),
      body: Row(
        children: [
          // Adaptive Sidebar Display
          if (isDesktop && _isDesktopSidebarOpen)
            StaffSidebar(
              currentIndex: widget.currentIndex,
              onIndexChanged: widget.onIndexChanged,
              isCollapsed: false,
            ),
          if (isTablet && _isDesktopSidebarOpen)
            StaffSidebar(
              currentIndex: widget.currentIndex,
              onIndexChanged: widget.onIndexChanged,
              isCollapsed: true,
            ),
          
          Expanded(
            child: Column(
              children: [
                StaffTopBar(
                  currentIndex: widget.currentIndex,
                  onIndexChanged: widget.onIndexChanged,
                  onToggleSidebar: _toggleSidebar,
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    bottom: true,
                    child: Padding(
                      padding: EdgeInsets.all(context.responsive(
                        mobile: AppSizes.s12,
                        desktop: AppSizes.s24,
                      )),
                      child: widget.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StaffSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final bool isCollapsed;
  final bool isMobileDrawer;

  const StaffSidebar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.isCollapsed = false,
    this.isMobileDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final double width = isCollapsed ? 72.0 : AppSizes.sidebarWidth;
    final filteredItems = ResponsiveStaffScaffold.getFilteredItems();

    return Container(
      width: width,
      height: double.infinity,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          _buildHeader(context),
          if (!isCollapsed) _buildProfileSection(context),
          if (isCollapsed) const SizedBox(height: AppSizes.s16),
          
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: AppSizes.s8),
              itemBuilder: (context, index) {
                return SidebarTile(
                  item: filteredItems[index],
                  isSelected: currentIndex == filteredItems[index].index,
                  isCollapsed: isCollapsed,
                  onTap: () {
                    onIndexChanged(filteredItems[index].index);
                    if (isMobileDrawer) Navigator.pop(context);
                  },
                );
              },
            ),
          ),

          _buildLogoutSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final bool canCloseDrawer = isMobileDrawer || (Scaffold.maybeOf(context)?.isDrawerOpen ?? false);

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? AppSizes.s12 : AppSizes.s16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF374151))),
      ),
      alignment: Alignment.center,
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
          if (!isCollapsed) ...[
            const SizedBox(width: AppSizes.s12),
            const Expanded(
              child: Text(
                'CHATURVYUHA',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          if (canCloseDrawer && !isCollapsed)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: AppColors.textWhite, size: 20),
              tooltip: 'Close Navigation',
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      margin: const EdgeInsets.only(top: AppSizes.s16, left: AppSizes.s16, right: AppSizes.s16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: const Text('AD', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: AppSizes.s16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Acharya Dev', style: TextStyle(color: AppColors.textWhite, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 2),
                Text('Administrator', style: TextStyle(color: AppColors.textDisabled, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFF374151)))),
      child: isCollapsed
          ? Tooltip(
              message: 'Logout',
              child: IconButton(onPressed: () => _showLogoutDialog(context), icon: const Icon(Icons.logout, color: AppColors.error)),
            )
          : InkWell(
              onTap: () => _showLogoutDialog(context),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.s8, vertical: AppSizes.s8),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.error, size: AppSizes.iconSize),
                    SizedBox(width: AppSizes.s16),
                    Text('Logout', style: TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of the Chaturvyuha staff portal?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// A reusable Sidebar Tile component with support for badges and hover effects
class SidebarTile extends StatelessWidget {
  final SidebarItemModel item;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const SidebarTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Tooltip(
        message: item.title,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: Container(
            height: AppSizes.navItemHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? AppColors.secondary : AppColors.textDisabled,
                  size: AppSizes.iconSize,
                ),
                if (item.badgeCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(
                        '${item.badgeCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        height: AppSizes.navItemHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
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
                    borderRadius: BorderRadius.only(topRight: Radius.circular(2), bottomRight: Radius.circular(2)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
              child: Row(
                children: [
                  Icon(item.icon, color: isSelected ? AppColors.secondary : AppColors.textDisabled, size: AppSizes.iconSize),
                  const SizedBox(width: AppSizes.s16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? AppColors.textWhite : AppColors.textDisabled,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (item.badgeCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : AppColors.error.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${item.badgeCount}',
                        style: TextStyle(
                          color: isSelected ? AppColors.textPrimary : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
  }
}

class StaffTopBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onToggleSidebar;

  const StaffTopBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    
    // Find the current item by index safely
    final currentItem = ResponsiveStaffScaffold.navigationItems.firstWhere(
      (item) => item.index == currentIndex,
      orElse: () => ResponsiveStaffScaffold.navigationItems.first,
    );
    
    final bool canPop = Navigator.canPop(context);

    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: EdgeInsets.symmetric(horizontal: context.responsive(mobile: AppSizes.s12, desktop: AppSizes.s24)),
        child: Row(
          children: [
            IconButton(
              onPressed: onToggleSidebar ?? () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              tooltip: 'Toggle Sidebar',
            ),
            const SizedBox(width: AppSizes.s4),
            if (canPop || currentIndex != 0) ...[
              IconButton(
                onPressed: () => canPop ? Navigator.maybePop(context) : onIndexChanged(0),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                tooltip: 'Go Back',
              ),
              const SizedBox(width: AppSizes.s4),
            ],
            Expanded(
              child: Text(
                currentItem.title,
                style: TextStyle(color: AppColors.textPrimary, fontSize: context.responsive(mobile: 16, desktop: 18), fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Global Notifications Badge
            _buildTopBarAction(
              context,
              icon: Icons.notifications_none_outlined,
              badgeCount: 12,
              onTap: () => onIndexChanged(8),
              tooltip: 'Notifications',
            ),
            const SizedBox(width: AppSizes.s8),
            // Global Messages Badge
            _buildTopBarAction(
              context,
              icon: Icons.chat_bubble_outline,
              badgeCount: 5,
              onTap: () => onIndexChanged(7),
              tooltip: 'Messages',
            ),
            const SizedBox(width: AppSizes.s16),
            _buildProfileAvatar(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarAction(BuildContext context, {required IconData icon, required int badgeCount, required VoidCallback onTap, required String tooltip}) {
    return Stack(
      children: [
        IconButton(onPressed: onTap, icon: Icon(icon, color: AppColors.textPrimary), tooltip: tooltip),
        if (badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text('$badgeCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileAvatar(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Text('AD', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        if (!isMobile) ...[
          const SizedBox(width: AppSizes.s8),
          const Text('Acharya Dev', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ],
    );
  }
}
