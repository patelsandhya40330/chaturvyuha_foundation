import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ActivityDataPoint {
  final String label; // e.g. 'Jan', 'Feb'
  final int articles;
  final int events;
  final int programs;
  final int announcements;

  const ActivityDataPoint({
    required this.label,
    required this.articles,
    required this.events,
    required this.programs,
    required this.announcements,
  });

  int getValueForMetric(String metric) {
    switch (metric) {
      case 'Articles Published':
        return articles;
      case 'Events':
        return events;
      case 'Programs':
        return programs;
      case 'Announcements':
        return announcements;
      default:
        return articles + events + programs + announcements;
    }
  }
}

class ContentStatusItem {
  final String category;
  final int count;
  final Color color;

  const ContentStatusItem({
    required this.category,
    required this.count,
    required this.color,
  });
}

class AnalyticsRepository {
  static List<ActivityDataPoint> getActivityOverviewData(String filter) {
    switch (filter) {
      case 'Last 7 Days':
        return const [
          ActivityDataPoint(label: 'Mon', articles: 12, events: 2, programs: 3, announcements: 5),
          ActivityDataPoint(label: 'Tue', articles: 18, events: 4, programs: 5, announcements: 8),
          ActivityDataPoint(label: 'Wed', articles: 15, events: 1, programs: 4, announcements: 6),
          ActivityDataPoint(label: 'Thu', articles: 22, events: 3, programs: 6, announcements: 9),
          ActivityDataPoint(label: 'Fri', articles: 28, events: 5, programs: 8, announcements: 12),
          ActivityDataPoint(label: 'Sat', articles: 10, events: 6, programs: 2, announcements: 4),
          ActivityDataPoint(label: 'Sun', articles: 8, events: 3, programs: 1, announcements: 2),
        ];

      case 'Last 30 Days':
        return const [
          ActivityDataPoint(label: 'Week 1', articles: 65, events: 12, programs: 18, announcements: 24),
          ActivityDataPoint(label: 'Week 2', articles: 82, events: 15, programs: 22, announcements: 30),
          ActivityDataPoint(label: 'Week 3', articles: 74, events: 10, programs: 20, announcements: 28),
          ActivityDataPoint(label: 'Week 4', articles: 95, events: 18, programs: 25, announcements: 35),
        ];

      case 'This Year':
        return const [
          ActivityDataPoint(label: 'Q1', articles: 280, events: 45, programs: 60, announcements: 90),
          ActivityDataPoint(label: 'Q2', articles: 340, events: 58, programs: 72, announcements: 110),
          ActivityDataPoint(label: 'Q3', articles: 310, events: 50, programs: 68, announcements: 102),
          ActivityDataPoint(label: 'Q4', articles: 390, events: 65, programs: 85, announcements: 130),
        ];

      case 'Last 6 Months':
      default:
        return const [
          ActivityDataPoint(label: 'Jan', articles: 42, events: 8, programs: 12, announcements: 15),
          ActivityDataPoint(label: 'Feb', articles: 58, events: 12, programs: 16, announcements: 22),
          ActivityDataPoint(label: 'Mar', articles: 50, events: 10, programs: 14, announcements: 18),
          ActivityDataPoint(label: 'Apr', articles: 72, events: 15, programs: 20, announcements: 28),
          ActivityDataPoint(label: 'May', articles: 68, events: 14, programs: 18, announcements: 25),
          ActivityDataPoint(label: 'Jun', articles: 85, events: 18, programs: 24, announcements: 32),
        ];
    }
  }

  static List<ContentStatusItem> getContentStatusData() {
    return const [
      ContentStatusItem(category: 'Published', count: 1462, color: AppColors.success),
      ContentStatusItem(category: 'Draft', count: 120, color: AppColors.warning),
      ContentStatusItem(category: 'Pending Review', count: 45, color: AppColors.info),
      ContentStatusItem(category: 'Unpublished', count: 18, color: AppColors.error),
    ];
  }
}
