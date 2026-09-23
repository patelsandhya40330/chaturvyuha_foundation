import 'package:chaturvyuha_foundation/staff/core/auth/permission_service.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/core/routing/app_router.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/charts/activity_overview_chart.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/charts/content_status_chart.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/dashboard_section.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/dashboard_stats_grid.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/state_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class DashboardHomeView extends StatefulWidget {
  const DashboardHomeView({super.key});

  @override
  State<DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends State<DashboardHomeView> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _simulateLoadingCycle() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _isEmpty = false;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _triggerErrorState() {
    setState(() {
      _hasError = true;
      _isEmpty = false;
      _isLoading = false;
    });
  }

  void _triggerEmptyState() {
    setState(() {
      _isEmpty = true;
      _hasError = false;
      _isLoading = false;
    });
  }

  void _clearSimulationStates() {
    setState(() {
      _isEmpty = false;
      _hasError = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSimulatorControlRow(),
          const SizedBox(height: AppSizes.s12),
          if (_isLoading)
            const Expanded(
              child: LoadingState(
                message: 'Synchronizing Dashboard Workspace...',
              ),
            ),
          if (_hasError && !_isLoading)
            Expanded(
              child: ErrorState(
                title: 'Connection Failure',
                message:
                    'Unable to query workspace metrics from the repository server. Please verify your connection status.',
                onRetry: _clearSimulationStates,
              ),
            ),
          if (_isEmpty && !_isLoading && !_hasError)
            Expanded(
              child: EmptyState(
                title: 'No Operational Data Available',
                message:
                    'The administrative registry is currently empty. Initialize foundation metrics or toggle simulation rows.',
                onAction: _clearSimulationStates,
                actionLabel: 'Restore Data',
              ),
            ),
          if (!_isLoading && !_hasError && !_isEmpty)
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderContent(),
                    const SizedBox(height: AppSizes.s24),
                    _buildStatisticsSection(),
                    const SizedBox(height: AppSizes.s32),
                    _buildAnalyticsSection(),
                    const SizedBox(height: AppSizes.s32),
                    _buildAdaptiveMainLayout(context),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimulatorControlRow() {
    final bool isMobile = context.isMobile;

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.s8),
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  color: AppColors.secondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dashboard View Simulators:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                TextButton.icon(
                  onPressed: _isEmpty
                      ? _clearSimulationStates
                      : _triggerEmptyState,
                  icon: Icon(
                    _isEmpty ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 14,
                  ),
                  label: const Text(
                    'Empty State',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                ),
                TextButton.icon(
                  onPressed: _hasError
                      ? _clearSimulationStates
                      : _triggerErrorState,
                  icon: Icon(
                    _hasError ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 14,
                  ),
                  label: const Text(
                    'Error State',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                ),
                TextButton.icon(
                  onPressed: _simulateLoadingCycle,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text(
                    'Loading Spinner',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: AppColors.secondary,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Dashboard View Simulators:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _isEmpty ? _clearSimulationStates : _triggerEmptyState,
            icon: Icon(
              _isEmpty ? Icons.check_box : Icons.check_box_outline_blank,
              size: 14,
            ),
            label: const Text('Empty State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _hasError ? _clearSimulationStates : _triggerErrorState,
            icon: Icon(
              _hasError ? Icons.check_box : Icons.check_box_outline_blank,
              size: 14,
            ),
            label: const Text('Error State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _simulateLoadingCycle,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text(
              'Loading Spinner',
              style: TextStyle(fontSize: 11),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 16),
          _buildRoleSwitcher(),
        ],
      ),
    );
  }

  Widget _buildRoleSwitcher() {
    return ValueListenableBuilder<MockRole>(
      valueListenable: PermissionService.currentRole,
      builder: (context, role, child) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<MockRole>(
            value: role,
            onChanged: (newRole) {
              if (newRole != null) {
                PermissionService.setRole(newRole);
                // Force rebuild of everything to reflect permission changes
                Navigator.pushReplacementNamed(context, AppRouter.dashboard);
              }
            },
            items: MockRole.values.map((r) {
              return DropdownMenuItem(
                value: r,
                child: Text(
                  'Role: ${r.name.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
            icon: const Icon(
              Icons.person_outline,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Real-time operational metrics, publication queues, and system alerts.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    const statsList = [
      StatItem(
        title: 'Total Articles',
        value: '1,482',
        icon: Icons.article_outlined,
        color: AppColors.primary,
        route: AppRouter.articles,
      ),
      StatItem(
        title: 'Draft Articles',
        value: '12',
        icon: Icons.edit_note_outlined,
        color: AppColors.warning,
        route: AppRouter.articles,
      ),
      StatItem(
        title: 'Pending Review',
        value: '08',
        icon: Icons.rate_review_outlined,
        color: AppColors.info,
        route: AppRouter.articles,
      ),
      StatItem(
        title: 'Published Articles',
        value: '1,462',
        icon: Icons.check_circle_outline,
        color: AppColors.success,
        route: AppRouter.articles,
      ),
      StatItem(
        title: 'Upcoming Events',
        value: '04',
        icon: Icons.event_available_outlined,
        color: AppColors.secondary,
        route: AppRouter.events,
      ),
      StatItem(
        title: 'Active Programs',
        value: '12',
        icon: Icons.school_outlined,
        color: AppColors.primary,
        route: AppRouter.programs,
      ),
      StatItem(
        title: 'Media Items',
        value: '856',
        icon: Icons.perm_media_outlined,
        color: AppColors.info,
        route: AppRouter.media,
      ),
      StatItem(
        title: 'Unread Messages',
        value: '03',
        icon: Icons.mark_unread_chat_alt_outlined,
        color: AppColors.error,
        route: AppRouter.messages,
      ),
    ];

    return const DashboardStatsGrid(stats: statsList);
  }

  Widget _buildAnalyticsSection() {
    final bool isDesktop = context.isDesktop;

    if (isDesktop) {
      return const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: ActivityOverviewChart()),
          SizedBox(width: AppSizes.s24),
          Expanded(flex: 3, child: ContentStatusBarChart()),
        ],
      );
    }

    return const Column(
      children: [
        ActivityOverviewChart(),
        SizedBox(height: AppSizes.s24),
        ContentStatusBarChart(),
      ],
    );
  }

  Widget _buildAdaptiveMainLayout(BuildContext context) {
    final bool isDesktop = context.isDesktop;
    final bool isTablet = context.isTablet;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildQuickActionsWidget(),
                const SizedBox(height: AppSizes.s32),
                _buildRecentContentWidget(),
                const SizedBox(height: AppSizes.s32),
                _buildUpcomingEventsWidget(),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.s32),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildNotificationsWidget(),
                const SizedBox(height: AppSizes.s32),
                _buildRecentActivityWidget(),
              ],
            ),
          ),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          _buildQuickActionsWidget(),
          const SizedBox(height: AppSizes.s32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentContentWidget()),
              const SizedBox(width: AppSizes.s24),
              Expanded(child: _buildUpcomingEventsWidget()),
            ],
          ),
          const SizedBox(height: AppSizes.s32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildNotificationsWidget()),
              const SizedBox(width: AppSizes.s24),
              Expanded(child: _buildRecentActivityWidget()),
            ],
          ),
        ],
      );
    }

    // Mobile layout column layout
    return Column(
      children: [
        _buildQuickActionsWidget(),
        const SizedBox(height: AppSizes.s32),
        _buildRecentContentWidget(),
        const SizedBox(height: AppSizes.s32),
        _buildUpcomingEventsWidget(),
        const SizedBox(height: AppSizes.s32),
        _buildNotificationsWidget(),
        const SizedBox(height: AppSizes.s32),
        _buildRecentActivityWidget(),
      ],
    );
  }

  Widget _buildRecentContentWidget() {
    return DashboardSection(
      title: 'Recent Content',
      actions: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRouter.articles),
          child: const Text('View All'),
        ),
      ],
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final items = [
            {
              'title': 'Introduction to Vedic Studies and Philosophy',
              'author': 'Acharya Sharma',
              'status': 'Published',
              'type': StatusType.success,
              'time': '2 hours ago',
            },
            {
              'title': 'Community Outreach Report 2024 First Quarter',
              'author': 'Admin User',
              'status': 'Draft',
              'type': StatusType.warning,
              'time': '5 hours ago',
            },
            {
              'title': 'Yoga Systems and Contemporary Mental Health Practices',
              'author': 'Dr. K. Rao',
              'status': 'Published',
              'type': StatusType.success,
              'time': 'Yesterday',
            },
            {
              'title': 'Preserving Ancient Sanskrit Manuscripts for Posterity',
              'author': 'Manning D.',
              'status': 'Review',
              'type': StatusType.info,
              'time': '2 days ago',
            },
            {
              'title': 'Historical Timeline of Sacred Himalayan Ashrams',
              'author': 'Acharya Dev',
              'status': 'Published',
              'type': StatusType.success,
              'time': '3 days ago',
            },
            {
              'title': 'Volunteer Training Manual - V2.1 Updates',
              'author': 'Admin User',
              'status': 'Draft',
              'type': StatusType.warning,
              'time': '1 week ago',
            },
          ];
          final item = items[index];

          return ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.responsive<double>(
                mobile: AppSizes.s12,
                tablet: AppSizes.s16,
                desktop: AppSizes.s24,
              ),
              vertical: AppSizes.s12,
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'by ${item['author']} • ${item['time']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            trailing: StatusBadge(
              label: item['status'] as String,
              type: item['type'] as StatusType,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingEventsWidget() {
    final bool isMobile = context.isMobile;
    final double horizontalPadding = context.responsive<double>(
      mobile: AppSizes.s12,
      tablet: AppSizes.s16,
      desktop: AppSizes.s24,
    );

    final events = [
      {
        'title': 'Global Peace Meditation Gathering',
        'dateMonth': 'OCT',
        'dateDay': '15',
        'time': '08:00 AM',
        'location': 'Main Ashram Hall',
      },
      {
        'title': 'Vedic Literature & Philosophy Seminar',
        'dateMonth': 'OCT',
        'dateDay': '22',
        'time': '10:30 AM',
        'location': 'Conference Auditorium',
      },
      {
        'title': 'Institutional Seva Training Workshop',
        'dateMonth': 'NOV',
        'dateDay': '02',
        'time': '09:00 AM',
        'location': 'Virtual Workspace',
      },
      {
        'title': 'Sanskrit Chanting Symposium',
        'dateMonth': 'NOV',
        'dateDay': '12',
        'time': '05:00 PM',
        'location': 'Center Hall B',
      },
      {
        'title': 'Community Outreach Planning',
        'dateMonth': 'DEC',
        'dateDay': '05',
        'time': '11:00 AM',
        'location': 'Meeting Room 4',
      },
    ];

    return DashboardSection(
      title: 'Upcoming Events',
      actions: [
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRouter.events),
          child: const Text('View All'),
        ),
      ],
      child: Column(
        children: events.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          final isLast = index == events.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: AppSizes.s12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            event['dateMonth']!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            event['dateDay']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSizes.s16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event['time']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  event['location']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, thickness: 1, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActionsWidget() {
    final bool isMobile = context.isMobile;
    final double cardPadding = context.responsive<double>(
      mobile: AppSizes.s12,
      tablet: AppSizes.s16,
      desktop: AppSizes.s24,
    );

    return DashboardSection(
      title: 'Quick Actions',
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = isMobile
                ? ((constraints.maxWidth - AppSizes.s12) / 2).floorToDouble()
                : 110.0;

            return Wrap(
              spacing: isMobile ? AppSizes.s12 : AppSizes.s16,
              runSpacing: isMobile ? AppSizes.s12 : AppSizes.s16,
              children: [
                _buildActionButton(
                  Icons.add_circle_outline,
                  'New Article',
                  AppRouter.articlesCreate,
                  itemWidth,
                ),
                _buildActionButton(
                  Icons.add_to_photos_outlined,
                  'New Page',
                  AppRouter.pagesCreate,
                  itemWidth,
                ),
                _buildActionButton(
                  Icons.event_note_outlined,
                  'New Event',
                  AppRouter.eventsCreate,
                  itemWidth,
                ),
                _buildActionButton(
                  Icons.campaign_outlined,
                  'Announce',
                  AppRouter.announcementsCreate,
                  itemWidth,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    String route, [
    double width = 110,
  ]) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.s16,
          horizontal: AppSizes.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsWidget() {
    return DashboardSection(
      title: 'System Notifications',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notes = [
            {
              'msg': 'Storage space utilization has reached 85% capacity.',
              'icon': Icons.storage,
              'color': AppColors.warning,
              'time': '15 mins ago',
            },
            {
              'msg':
                  'New staff authentication parameters updated successfully.',
              'icon': Icons.verified_user,
              'color': AppColors.success,
              'time': '1 hour ago',
            },
            {
              'msg': 'Automated database registry backup completed.',
              'icon': Icons.backup,
              'color': AppColors.info,
              'time': '3 hours ago',
            },
            {
              'msg': 'Security alert: Multiple failed login attempts detected.',
              'icon': Icons.security,
              'color': AppColors.error,
              'time': '5 hours ago',
            },
            {
              'msg': 'Monthly analytics report is ready for download.',
              'icon': Icons.analytics,
              'color': AppColors.primary,
              'time': 'Yesterday',
            },
          ];
          final note = notes[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s24,
              vertical: AppSizes.s8,
            ),
            leading: Icon(
              note['icon'] as IconData,
              color: note['color'] as Color,
              size: 20,
            ),
            title: Text(
              note['msg'] as String,
              style: const TextStyle(fontSize: 13, color: AppColors.textBody),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                note['time'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentActivityWidget() {
    return DashboardSection(
      title: 'Recent Activity Log',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          children: List.generate(5, (index) {
            final acts = [
              {
                'user': 'Acharya Dev',
                'action': 'configured site layout settings',
                'time': '10 mins ago',
              },
              {
                'user': 'Manning D.',
                'action': 'uploaded 4 asset resources to storage',
                'time': '45 mins ago',
              },
              {
                'user': 'Dr. K. Rao',
                'action': 'edited article "Yoga Systems Basics"',
                'time': '2 hours ago',
              },
              {
                'user': 'Admin User',
                'action': 'created a new cultural event: "Winter Retreat"',
                'time': 'Yesterday',
              },
              {
                'user': 'Acharya Sharma',
                'action': 'published "Vedic Grammar Guide"',
                'time': '2 days ago',
              },
            ];
            final act = acts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: AppColors.textBody,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: act['user'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextSpan(text: ' ${act['action']}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          act['time'] as String,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
