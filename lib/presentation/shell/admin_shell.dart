import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../member/UserInterface/Dashboard/dashboard_screen.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/placeholder/placeholder_page.dart';
import '../widgets/sidebar/app_sidebar.dart';
import '../widgets/topbar/admin_topbar.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;
  String _searchQuery = '';

  final _pageKeys = const [
    'Dashboard',
    'Content',
    'Pages',
    'Programs',
    'Events',
    'Media',
    'Announcements',
    'Messages',
    'Member Site',
  ];

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppConstants.mobileBreakpoint;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              width: 270,
              child: AppSidebar(
                selectedIndex: _selectedIndex,
                collapsed: false,
                onItemSelected: (index) {
                  _selectPage(index);
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            AppSidebar(
              selectedIndex: _selectedIndex,
              collapsed: _sidebarCollapsed,
              onItemSelected: _selectPage,
            ),
          Expanded(
            child: Column(
              children: [
                Builder(
                  builder: (scaffoldContext) {
                    return AdminTopbar(
                      showMenuButton: isMobile,
                      onMenuPressed: () =>
                          Scaffold.of(scaffoldContext).openDrawer(),
                      onSearch: (value) {
                        setState(() => _searchQuery = value.trim());
                      },
                      onCollapseSidebar: isMobile
                          ? null
                          : () => setState(
                                () => _sidebarCollapsed = !_sidebarCollapsed,
                              ),
                    );
                  },
                ),
                Expanded(
                  child: _buildSelectedPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPage() {
    if (_selectedIndex == 0) {
      return DashboardPage(searchQuery: _searchQuery);
    }

    if (_selectedIndex == 8) {
      return const DashboardScreen();
    }

    return PlaceholderPage(
      title: _pageKeys[_selectedIndex],
      subtitle: 'This module has its own page and can be implemented next.',
      icon: _pageIcon(_selectedIndex),
    );
  }

  IconData _pageIcon(int index) {
    switch (index) {
      case 1:
        return Icons.article_outlined;
      case 2:
        return Icons.web_outlined;
      case 3:
        return Icons.auto_awesome_outlined;
      case 4:
        return Icons.event_outlined;
      case 5:
        return Icons.perm_media_outlined;
      case 6:
        return Icons.campaign_outlined;
      case 7:
        return Icons.mail_outline;
      case 8:
        return Icons.public_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }
}
