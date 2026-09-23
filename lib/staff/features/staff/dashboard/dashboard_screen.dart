import 'package:chaturvyuha_foundation/staff/core/auth/permission_service.dart';
import 'package:chaturvyuha_foundation/staff/core/routing/app_router.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/dashboard_home_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/content_inventory_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/article_editor_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/pages_list_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/page_editor_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/programs_list_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/program_editor_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/events_list_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/event_editor_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/media_library_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/announcements_list_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/announcement_editor_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/messages_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/notifications_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/settings_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/members_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/reports_view.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/seo_view.dart';
import 'package:chaturvyuha_foundation/staff/widgets/responsive_staff_scaffold.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final String? route;
  final String? id;

  const DashboardScreen({super.key, this.route, this.id});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String _currentRoute;

  @override
  void initState() {
    super.initState();
    _currentRoute = widget.route ?? AppRouter.dashboard;
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.route != null && widget.route != _currentRoute) {
      setState(() {
        _currentRoute = widget.route!;
      });
    }
  }

  int _getRouteIndex() {
    final route = _currentRoute;
    
    if (route == AppRouter.dashboard) return 0;
    if (route.startsWith(AppRouter.articles)) return 1;
    if (route.startsWith(AppRouter.pages)) return 2;
    if (route.startsWith(AppRouter.programs)) return 3;
    if (route.startsWith(AppRouter.events)) return 4;
    if (route == AppRouter.media) return 5;
    if (route.startsWith(AppRouter.announcements)) return 6;
    if (route == AppRouter.messages) return 7;
    if (route == AppRouter.notifications) return 8;
    if (route == AppRouter.settings) return 9;
    if (route == AppRouter.members) return 10;
    if (route == AppRouter.reports) return 11;
    if (route == AppRouter.seo) return 12;
    
    return 0;
  }

  void _onMenuSelected(int index) {
    String routeName = AppRouter.dashboard;
    switch (index) {
      case 0: routeName = AppRouter.dashboard; break;
      case 1: routeName = AppRouter.articles; break;
      case 2: routeName = AppRouter.pages; break;
      case 3: routeName = AppRouter.programs; break;
      case 4: routeName = AppRouter.events; break;
      case 5: routeName = AppRouter.media; break;
      case 6: routeName = AppRouter.announcements; break;
      case 7: routeName = AppRouter.messages; break;
      case 8: routeName = AppRouter.notifications; break;
      case 9: routeName = AppRouter.settings; break;
      case 10: routeName = AppRouter.members; break;
      case 11: routeName = AppRouter.reports; break;
      case 12: routeName = AppRouter.seo; break;
    }
    
    setState(() {
      _currentRoute = routeName;
    });
    
    // Optionally update URL without pushing a new screen onto stack
    // For simplicity in this mock, we just update local state
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveStaffScaffold(
      currentIndex: _getRouteIndex(),
      onIndexChanged: _onMenuSelected,
      body: _buildPageContent(_currentRoute),
    );
  }

  Widget _buildPageContent(String route) {
    if (route == AppRouter.dashboard) return const DashboardHomeView();
    
    // Articles
    if (route == AppRouter.articles) {
      if (!PermissionService.hasPermission(AppPermissions.articlesView)) return _buildAccessDenied();
      return const ContentInventoryView();
    }
    if (route == AppRouter.articlesCreate) {
      if (!PermissionService.hasPermission(AppPermissions.articlesCreate)) return _buildAccessDenied();
      return const ArticleEditorView();
    }
    if (route == AppRouter.articlesEdit) {
      if (!PermissionService.hasPermission(AppPermissions.articlesEdit)) return _buildAccessDenied();
      return ArticleEditorView(articleId: widget.id);
    }
    
    // Pages
    if (route == AppRouter.pages) {
      if (!PermissionService.hasPermission(AppPermissions.pagesView)) return _buildAccessDenied();
      return const PagesListView();
    }
    if (route == AppRouter.pagesCreate) {
      if (!PermissionService.hasPermission(AppPermissions.pagesCreate)) return _buildAccessDenied();
      return const PageEditorView();
    }
    if (route == AppRouter.pagesEdit) {
      if (!PermissionService.hasPermission(AppPermissions.pagesEdit)) return _buildAccessDenied();
      return PageEditorView(pageId: widget.id);
    }
    
    // Programs
    if (route == AppRouter.programs) {
      if (!PermissionService.hasPermission(AppPermissions.programsView)) return _buildAccessDenied();
      return const ProgramsListView();
    }
    if (route == AppRouter.programsCreate) {
      if (!PermissionService.hasPermission(AppPermissions.programsCreate)) return _buildAccessDenied();
      return const ProgramEditorView();
    }
    if (route == AppRouter.programsEdit) {
      if (!PermissionService.hasPermission(AppPermissions.programsEdit)) return _buildAccessDenied();
      return ProgramEditorView(programId: widget.id);
    }
    
    // Events
    if (route == AppRouter.events) {
      if (!PermissionService.hasPermission(AppPermissions.eventsView)) return _buildAccessDenied();
      return const EventsListView();
    }
    if (route == AppRouter.eventsCreate) {
      if (!PermissionService.hasPermission(AppPermissions.eventsCreate)) return _buildAccessDenied();
      return const EventEditorView();
    }
    if (route == AppRouter.eventsEdit) {
      if (!PermissionService.hasPermission(AppPermissions.eventsEdit)) return _buildAccessDenied();
      return EventEditorView(eventId: widget.id);
    }
    
    // Others
    if (route == AppRouter.media) {
      if (!PermissionService.hasPermission(AppPermissions.mediaView)) return _buildAccessDenied();
      return const MediaLibraryView();
    }
    
    // Announcements
    if (route == AppRouter.announcements) {
      if (!PermissionService.hasPermission(AppPermissions.announcementsView)) return _buildAccessDenied();
      return const AnnouncementsListView();
    }
    if (route == AppRouter.announcementsCreate) {
      if (!PermissionService.hasPermission(AppPermissions.announcementsCreate)) return _buildAccessDenied();
      return const AnnouncementEditorView();
    }
    if (route == AppRouter.announcementsEdit) {
      if (!PermissionService.hasPermission(AppPermissions.announcementsEdit)) return _buildAccessDenied();
      return AnnouncementEditorView(announcementId: widget.id);
    }
    
    if (route == AppRouter.messages) {
      if (!PermissionService.hasPermission(AppPermissions.messagesView)) return _buildAccessDenied();
      return const MessagesView();
    }
    if (route == AppRouter.notifications) return const NotificationsView();
    if (route == AppRouter.settings) return const SettingsView();
    
    if (route == AppRouter.members) {
      if (!PermissionService.hasPermission(AppPermissions.membersView)) return _buildAccessDenied();
      return const MembersView();
    }
    if (route == AppRouter.reports) {
      if (!PermissionService.hasPermission(AppPermissions.reportsView)) return _buildAccessDenied();
      return const ReportsView();
    }
    if (route == AppRouter.seo) {
      if (!PermissionService.hasPermission(AppPermissions.seoManage)) return _buildAccessDenied();
      return const SEOView();
    }

    return const DashboardHomeView();
  }

  Widget _buildAccessDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Access Denied', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('You do not have permission to view this section.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.dashboard),
            child: const Text('Back to Dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderView(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.layers_outlined,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (title.contains('Edit') || title.contains('Create'))
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to List'),
            ),
        ],
      ),
    );
  }
}
