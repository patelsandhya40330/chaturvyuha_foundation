import 'package:flutter/material.dart';

import '../../../data/repositories/dashboard_repository.dart';
import '../../../data/repositories/dummy_dashboard_repository.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/dashboard_stats_grid.dart';
import '../../widgets/dashboard/quick_actions_card.dart';
import '../../widgets/dashboard/recent_activity_card.dart';
import '../../widgets/dashboard/upcoming_events_card.dart';

class DashboardPage extends StatelessWidget {
  final String searchQuery;

  const DashboardPage({
    super.key,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final DashboardRepository repository = DummyDashboardRepository();
    final query = searchQuery.toLowerCase();

    final activities = repository
        .getRecentActivities()
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.action.toLowerCase().contains(query),
        )
        .toList();

    final events = repository
        .getUpcomingEvents()
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query),
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: 16),
          DashboardStatsGrid(stats: repository.getStats()),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 1050;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          RecentActivityCard(items: activities),
                          const SizedBox(height: 16),
                          UpcomingEventsCard(items: events),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: QuickActionsCard(
                        actions: repository.getQuickActions(),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  QuickActionsCard(actions: repository.getQuickActions()),
                  const SizedBox(height: 16),
                  RecentActivityCard(items: activities),
                  const SizedBox(height: 16),
                  UpcomingEventsCard(items: events),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
