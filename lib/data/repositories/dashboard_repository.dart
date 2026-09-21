import '../models/dashboard_models.dart';

abstract class DashboardRepository {
  List<DashboardStat> getStats();
  List<ActivityItem> getRecentActivities();
  List<UpcomingEvent> getUpcomingEvents();
  List<QuickActionItem> getQuickActions();
}
