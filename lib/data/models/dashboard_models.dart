class DashboardStat {
  final String title;
  final String value;
  final String subtitle;
  final String icon;
  final int colorIndex;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.colorIndex,
  });
}

class ActivityItem {
  final String name;
  final String action;
  final String time;
  final String avatarText;

  const ActivityItem({
    required this.name,
    required this.action,
    required this.time,
    required this.avatarText,
  });
}

class UpcomingEvent {
  final String title;
  final String date;
  final String location;
  final String tag;
  final int colorIndex;

  const UpcomingEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.tag,
    required this.colorIndex,
  });
}

class QuickActionItem {
  final String title;
  final String icon;
  final String routeKey;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.routeKey,
  });
}
