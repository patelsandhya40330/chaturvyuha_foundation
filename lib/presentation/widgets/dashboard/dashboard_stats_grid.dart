import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/dashboard_models.dart';

class DashboardStatsGrid extends StatelessWidget {
  final List<DashboardStat> stats;

  const DashboardStatsGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1250
            ? 6
            : width >= 850
                ? 3
                : width >= 560
                    ? 2
                    : 1;

        const gap = 12.0;
        final itemWidth = (width - (columns - 1) * gap) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map(
                (stat) => SizedBox(
                  width: itemWidth,
                  child: _StatCard(stat: stat),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final DashboardStat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFFE2E2),
      const Color(0xFFE1F5E9),
      const Color(0xFFFFEBD7),
      const Color(0xFFE7E4FF),
      const Color(0xFFFFDDEB),
      const Color(0xFFDFF3F1),
    ];

    final iconColors = [
      AppConstants.primaryRed,
      const Color(0xFF219653),
      const Color(0xFFF2994A),
      const Color(0xFF5B55C8),
      const Color(0xFFB83B76),
      const Color(0xFF238C86),
    ];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${stat.title} selected')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppConstants.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors[stat.colorIndex],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _icon(stat.icon),
                  color: iconColors[stat.colorIndex],
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      stat.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      stat.subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(String key) {
    switch (key) {
      case 'article':
        return Icons.description_outlined;
      case 'star':
        return Icons.star_outline_rounded;
      case 'calendar':
        return Icons.calendar_month_outlined;
      case 'timer':
        return Icons.timer_outlined;
      case 'message':
        return Icons.chat_bubble_outline_rounded;
      case 'mail':
        return Icons.mark_email_unread_outlined;
      default:
        return Icons.dashboard_outlined;
    }
  }
}
