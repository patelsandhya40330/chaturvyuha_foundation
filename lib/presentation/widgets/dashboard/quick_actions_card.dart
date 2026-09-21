import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/dashboard_models.dart';
import '../../pages/create_announcement/create_announcement_page.dart';
import '../../pages/create_article/create_article_page.dart';
import '../../pages/create_event/create_event_page.dart';
import '../../pages/create_program/create_program_page.dart';
import '../../pages/upload_media/upload_media_page.dart';
import 'section_card.dart';

class QuickActionsCard extends StatelessWidget {
  final List<QuickActionItem> actions;

  const QuickActionsCard({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Quick Actions',
      child: Column(
        children: [
          for (final action in actions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _QuickActionButton(
                action: action,
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final QuickActionItem action;

  const _QuickActionButton({
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppConstants.softRed,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _openPage(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            child: Row(
              children: [
                Icon(
                  _getIcon(action.icon),
                  size: 17,
                  color: AppConstants.primaryRed,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    action.title,
                    style: const TextStyle(
                      color: AppConstants.primaryRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppConstants.primaryRed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPage(BuildContext context) {
    Widget page;

    switch (action.routeKey) {
      case 'article':
        page = const CreateArticlePage();
        break;

      case 'program':
        page = const CreateProgramPage();
        break;

      case 'event':
        page = const CreateEventPage();
        break;

      case 'announcement':
        page = const CreateAnnouncementPage();
        break;

      case 'media':
        page = const UploadMediaPage();
        break;

      default:
        return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  IconData _getIcon(String key) {
    switch (key) {
      case 'article':
        return Icons.article_outlined;

      case 'program':
        return Icons.auto_awesome_outlined;

      case 'event':
        return Icons.event_outlined;

      case 'announcement':
        return Icons.campaign_outlined;

      case 'upload':
        return Icons.cloud_upload_outlined;

      default:
        return Icons.add_circle_outline;
    }
  }
}