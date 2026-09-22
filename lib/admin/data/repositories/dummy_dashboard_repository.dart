import '../models/dashboard_models.dart';
import 'dashboard_repository.dart';

class DummyDashboardRepository implements DashboardRepository {
  @override
  List<DashboardStat> getStats() {
    return const [
      DashboardStat(
        title: 'Articles',
        value: '24',
        subtitle: 'Published',
        icon: 'article',
        colorIndex: 0,
      ),
      DashboardStat(
        title: 'Programs',
        value: '8',
        subtitle: 'Active',
        icon: 'star',
        colorIndex: 1,
      ),
      DashboardStat(
        title: 'Events',
        value: '12',
        subtitle: 'Upcoming',
        icon: 'calendar',
        colorIndex: 2,
      ),
      DashboardStat(
        title: 'Registrations',
        value: '156',
        subtitle: 'This month',
        icon: 'timer',
        colorIndex: 3,
      ),
      DashboardStat(
        title: 'Messages',
        value: '18',
        subtitle: 'Unresolved',
        icon: 'message',
        colorIndex: 4,
      ),
      DashboardStat(
        title: 'Announcements',
        value: '5',
        subtitle: 'Active',
        icon: 'mail',
        colorIndex: 5,
      ),
    ];
  }

  @override
  List<ActivityItem> getRecentActivities() {
    return const [
      ActivityItem(
        name: 'Sitaram',
        action: 'published "Yoga & Meditation for Better Life"',
        time: '2 hours ago',
        avatarText: 'S',
      ),
      ActivityItem(
        name: 'Ram',
        action: 'created "Vedic Education Program"',
        time: '4 hours ago',
        avatarText: 'R',
      ),
      ActivityItem(
        name: 'Hari',
        action: 'uploaded 12 event photos',
        time: '6 hours ago',
        avatarText: 'H',
      ),
      ActivityItem(
        name: 'Krishna',
        action: 'replied to an inquiry',
        time: '8 hours ago',
        avatarText: 'K',
      ),
    ];
  }

  @override
  List<UpcomingEvent> getUpcomingEvents() {
    return const [
      UpcomingEvent(
        title: 'Yoga & Meditation Camp',
        date: 'Jun 25, 2025',
        location: 'Kathmandu',
        tag: '12%',
        colorIndex: 0,
      ),
      UpcomingEvent(
        title: 'Vedic Discourse',
        date: 'Jun 28, 2025',
        location: 'Lalitpur',
        tag: '8/30',
        colorIndex: 1,
      ),
      UpcomingEvent(
        title: 'Cultural Awareness Program',
        date: 'Jul 03, 2025',
        location: 'Pokhara',
        tag: '4/50',
        colorIndex: 2,
      ),
    ];
  }

  @override
  List<QuickActionItem> getQuickActions() {
    return const [
      QuickActionItem(
        title: 'Create Article',
        icon: 'article',
        routeKey: 'article',
      ),
      QuickActionItem(
        title: 'Create Program',
        icon: 'program',
        routeKey: 'program',
      ),
      QuickActionItem(
        title: 'Create Event',
        icon: 'event',
        routeKey: 'event',
      ),
      QuickActionItem(
        title: 'Create Announcement',
        icon: 'announcement',
        routeKey: 'announcement',
      ),
      QuickActionItem(
        title: 'Upload Media',
        icon: 'upload',
        routeKey: 'media',
      ),
    ];
  }
}
