import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/dashboard_models.dart';
import 'section_card.dart';

class UpcomingEventsCard extends StatelessWidget {
  final List<UpcomingEvent> items;

  const UpcomingEventsCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Upcoming Events',
      actionText: 'View all',
      onAction: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All upcoming events selected')),
      ),
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No upcoming events found.',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            )
          : Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _EventRow(item: items[i]),
                  if (i != items.length - 1) const Divider(height: 20),
                ],
              ],
            ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final UpcomingEvent item;

  const _EventRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.title} selected')),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade400,
                ],
              ),
            ),
            child: const Icon(
              Icons.landscape_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.date} • ${item.location}',
                  style: const TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: item.colorIndex == 0
                  ? const Color(0xFFE1F5E9)
                  : item.colorIndex == 1
                      ? const Color(0xFFFFEBD7)
                      : const Color(0xFFE7E4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
