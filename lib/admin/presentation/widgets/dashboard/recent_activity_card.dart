import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/dashboard_models.dart';
import 'section_card.dart';

class RecentActivityCard extends StatelessWidget {
  final List<ActivityItem> items;

  const RecentActivityCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Recent Activity',
      actionText: 'View all',
      onAction: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All activities selected')),
      ),
      child: items.isEmpty
          ? const _EmptyState(message: 'No activity found.')
          : Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _ActivityRow(item: items[i]),
                  if (i != items.length - 1) const Divider(height: 20),
                ],
              ],
            ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;

  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name}: ${item.action}')),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFFFE5E5),
            child: Text(
              item.avatarText,
              style: const TextStyle(
                color: AppConstants.primaryRed,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppConstants.textSecondary,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: item.name,
                    style: const TextStyle(
                      color: AppConstants.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: ' ${item.action}'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.time,
            style: const TextStyle(
              fontSize: 10,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        message,
        style: const TextStyle(color: AppConstants.textSecondary),
      ),
    );
  }
}
