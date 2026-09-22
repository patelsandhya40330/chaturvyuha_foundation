import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/form_widgets.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum NotificationCategory {
  registration,
  message,
  content,
  event,
  system,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String relatedEntity; // User name or Module name
  final DateTime timestamp;
  final NotificationCategory category;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.relatedEntity,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late List<NotificationModel> _allNotifications;
  List<NotificationModel> _filteredNotifications = [];
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    final now = DateTime.now();
    _allNotifications = [
      NotificationModel(
        id: '1',
        category: NotificationCategory.registration,
        title: 'New Event Registration',
        message: 'A member registered for the upcoming Vedic Yoga Workshop.',
        relatedEntity: 'Rahul Verma',
        timestamp: now.subtract(const Duration(minutes: 25)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        category: NotificationCategory.message,
        title: 'New Contact Message',
        message: 'A visitor submitted a new inquiry through the website regarding donation receipts.',
        relatedEntity: 'Sarah Jenkins',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        category: NotificationCategory.content,
        title: 'Article Submitted for Review',
        message: 'A new Sanskriti article "Vedic Rituals in Modern Life" is waiting for content review.',
        relatedEntity: 'Acharya Sharma',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        category: NotificationCategory.registration,
        title: 'Program Registration',
        message: 'A member registered for the Meditation & Wellness program starting next month.',
        relatedEntity: 'Elena Rossi',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        category: NotificationCategory.event,
        title: 'Event Reminder',
        message: 'Vedic Education orientation is scheduled for tomorrow at the Main Ashram Hall.',
        relatedEntity: 'Vedic Education',
        timestamp: now.subtract(const Duration(days: 1, hours: 4)),
        isRead: true,
      ),
      NotificationModel(
        id: '6',
        category: NotificationCategory.system,
        title: 'Media Uploaded',
        message: 'New images have been added to the Foundation media library for the Annual Heritage Assembly.',
        relatedEntity: 'Media Library',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '7',
        category: NotificationCategory.content,
        title: 'Content Published',
        message: 'A new Dharma & Sanskriti article "Historical Timeline of Ashrams" has been published.',
        relatedEntity: 'Dharma & Sanskriti',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '8',
        category: NotificationCategory.system,
        title: 'User Permission Changed',
        message: 'Administrative permissions for "Manning D." were updated by the system admin.',
        relatedEntity: 'User Management',
        timestamp: now.subtract(const Duration(days: 3, hours: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '9',
        category: NotificationCategory.message,
        title: 'New Comment on Post',
        message: 'Arin Gansihram commented on "Preserving Ancient Sanskrit Manuscripts".',
        relatedEntity: 'Arin Gansihram',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
      NotificationModel(
        id: '10',
        category: NotificationCategory.event,
        title: 'Event Attendance Updated',
        message: 'Attendance list for "Spring Yoga Retreat" has been finalized.',
        relatedEntity: 'Events Module',
        timestamp: now.subtract(const Duration(days: 4, hours: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '11',
        category: NotificationCategory.system,
        title: 'Database Backup Successful',
        message: 'The weekly automated database registry backup completed without errors.',
        relatedEntity: 'System Registry',
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '12',
        category: NotificationCategory.registration,
        title: 'Volunteer Application',
        message: 'Priya Mani submitted a new volunteer application for the heritage preservation team.',
        relatedEntity: 'Priya Mani',
        timestamp: now.subtract(const Duration(days: 6)),
        isRead: true,
      ),
    ];
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredNotifications = _allNotifications.where((n) {
        final matchesSearch = n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            n.message.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            n.relatedEntity.toLowerCase().contains(_searchQuery.toLowerCase());

        bool matchesFilter = true;
        if (_activeFilter == 'Unread') {
          matchesFilter = !n.isRead;
        } else if (_activeFilter == 'Events') {
          matchesFilter = n.category == NotificationCategory.event;
        } else if (_activeFilter == 'Messages') {
          matchesFilter = n.category == NotificationCategory.message;
        } else if (_activeFilter == 'Content') {
          matchesFilter = n.category == NotificationCategory.content;
        } else if (_activeFilter == 'System') {
          matchesFilter = n.category == NotificationCategory.system;
        }

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _allNotifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _allNotifications[index].isRead = true;
        _applyFilters();
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _allNotifications) {
        n.isRead = true;
      }
      _applyFilters();
    });
  }

  void _dismissNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((n) => n.id == id);
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationToolbar(
            unreadCount: _allNotifications.where((n) => !n.isRead).length,
            onMarkAllRead: _markAllAsRead,
          ),
          const SizedBox(height: AppSizes.s24),
          NotificationFilterBar(
            activeFilter: _activeFilter,
            onFilterChanged: (filter) {
              setState(() => _activeFilter = filter);
              _applyFilters();
            },
            searchController: _searchController,
            onSearchChanged: (val) {
              setState(() => _searchQuery = val);
              _applyFilters();
            },
          ),
          const SizedBox(height: AppSizes.s24),
          Expanded(
            child: _filteredNotifications.isEmpty
                ? const NotificationEmptyState()
                : NotificationList(
                    notifications: _filteredNotifications,
                    onMarkRead: _markAsRead,
                    onDismiss: _dismissNotification,
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationToolbar extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const NotificationToolbar({
    super.key,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    final content = [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'You have $unreadCount unread administrative alerts.',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
      if (unreadCount > 0)
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              onPressed: onMarkAllRead,
              icon: Icons.done_all,
              label: 'Mark All as Read',
            ),
          ),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 700;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'You have $unreadCount unread administrative alerts.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(height: 12),
                PrimaryButton(
                  onPressed: onMarkAllRead,
                  icon: Icons.done_all,
                  label: 'Mark All as Read',
                ),
              ],
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: content,
        );
      },
    );
  }
}

class NotificationFilterBar extends StatelessWidget {
  final String activeFilter;
  final Function(String) onFilterChanged;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const NotificationFilterBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Unread', 'Events', 'Messages', 'Content', 'System'];
    final bool isMobile = context.isMobile;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SearchField(
                controller: searchController,
                onChanged: onSearchChanged,
                hintText: 'Search notifications...',
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: AppSizes.s16),
              const Spacer(),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((f) {
              final isSelected = activeFilter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: isSelected,
                  onSelected: (_) => onFilterChanged(f),
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(String) onMarkRead;
  final Function(String) onDismiss;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onMarkRead,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          return NotificationTile(
            notification: notifications[index],
            onMarkRead: () => onMarkRead(notifications[index].id),
            onDismiss: () => onDismiss(notifications[index].id),
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onMarkRead;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onMarkRead,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool isDesktop = context.isDesktop;

    return InkWell(
      onTap: notification.isRead ? null : onMarkRead,
      child: Container(
        padding: EdgeInsets.all(context.responsive(mobile: 12, desktop: 20)),
        color: notification.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Action (leading left as per reference)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.textDisabled),
              onPressed: onDismiss,
              tooltip: 'Dismiss',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationCategoryBadge(category: notification.category),
                  const SizedBox(height: 8),
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.relatedEntity,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary, // Using primary as the accent color for user/module
                    ),
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 12),
                    _buildTimestamp(),
                  ],
                ],
              ),
            ),

            // Timestamp (Desktop/Tablet)
            if (!isMobile) ...[
              const SizedBox(width: 24),
              _buildTimestamp(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimestamp() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, size: 14, color: AppColors.textDisabled),
        const SizedBox(width: 6),
        Text(
          DateFormat('dd MMM yyyy \'at\' h:mm a').format(notification.timestamp),
          style: const TextStyle(fontSize: 11, color: AppColors.textDisabled),
        ),
      ],
    );
  }
}

class NotificationCategoryBadge extends StatelessWidget {
  final NotificationCategory category;

  const NotificationCategoryBadge({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (category) {
      case NotificationCategory.registration:
        color = AppColors.success;
        label = 'Registration';
        break;
      case NotificationCategory.message:
        color = AppColors.warning;
        label = 'Message';
        break;
      case NotificationCategory.content:
        color = AppColors.info;
        label = 'Content';
        break;
      case NotificationCategory.event:
        color = AppColors.secondary;
        label = 'Event';
        break;
      case NotificationCategory.system:
        color = AppColors.primary;
        label = 'System';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EmptyState(
        title: 'No Notifications Found',
        message: 'Your administrative registry is currently empty for the selected filters.',
        icon: Icons.notifications_off_outlined,
      ),
    );
  }
}
