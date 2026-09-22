import 'package:cfoundation/core/auth/permission_service.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/core/routing/app_router.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/dialogs.dart';
import 'package:cfoundation/widgets/common/form_widgets.dart';
import 'package:cfoundation/widgets/common/navigation_widgets.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:cfoundation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class EventModel {
  final String id;
  final String title;
  final String slug;
  final String description;
  final String date;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String location;
  final int capacity;
  final int registeredCount;
  bool isRegistrationEnabled;
  String status; // 'Upcoming', 'Live', 'Completed', 'Cancelled'
  final String imageUrl;
  final List<String> galleryUrls;
  final String createdDate;
  final String updatedDate;

  EventModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.capacity,
    required this.registeredCount,
    required this.isRegistrationEnabled,
    required this.status,
    required this.imageUrl,
    required this.galleryUrls,
    required this.createdDate,
    required this.updatedDate,
  });
}

class EventsListView extends StatefulWidget {
  const EventsListView({super.key});

  @override
  State<EventsListView> createState() => _EventsListViewState();
}

class _EventsListViewState extends State<EventsListView> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedDateFilter = 'All';
  String _selectedLocation = 'All';
  String _sortBy = 'Newest';

  int _currentPage = 1;
  final int _rowsPerPage = 5;

  late List<EventModel> _events;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    _events = [
      EventModel(
        id: 'EVT-001',
        title: 'Global Peace Meditation Gathering',
        slug: 'global-peace-meditation',
        description:
            'A worldwide synchronized meditation conference fostering global harmony and spiritual consciousness.',
        date: '2024-10-15',
        startDate: '2024-10-15',
        endDate: '2024-10-15',
        startTime: '08:00 AM',
        endTime: '11:00 AM',
        location: 'Main Ashram Hall',
        capacity: 200,
        registeredCount: 165,
        isRegistrationEnabled: true,
        status: 'Upcoming',
        imageUrl:
            'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800&h=500&fit=crop',
        galleryUrls: [
          'https://cfoundation.org/images/evt1-1.jpg',
          'https://cfoundation.org/images/evt1-2.jpg',
        ],
        createdDate: '2024-09-01',
        updatedDate: '2024-10-01',
      ),
      EventModel(
        id: 'EVT-002',
        title: 'Vedic Literature & Philosophy Seminar',
        slug: 'vedic-literature-seminar',
        description:
            'An international academic symposium exploring ancient Sanskrit manuscripts and philosophical citations.',
        date: '2024-10-22',
        startDate: '2024-10-22',
        endDate: '2024-10-23',
        startTime: '10:30 AM',
        endTime: '04:00 PM',
        location: 'Conference Auditorium',
        capacity: 150,
        registeredCount: 150,
        isRegistrationEnabled: false,
        status: 'Upcoming',
        imageUrl:
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=800&h=500&fit=crop',
        galleryUrls: ['https://cfoundation.org/images/evt2-1.jpg'],
        createdDate: '2024-09-10',
        updatedDate: '2024-10-05',
      ),
      EventModel(
        id: 'EVT-003',
        title: 'Institutional Seva Training Workshop',
        slug: 'institutional-seva-training',
        description:
            'Preparing volunteers and staff for digital archiving and rural outreach initiatives.',
        date: '2024-11-02',
        startDate: '2024-11-02',
        endDate: '2024-11-02',
        startTime: '09:00 AM',
        endTime: '01:00 PM',
        location: 'Virtual Workspace',
        capacity: 100,
        registeredCount: 48,
        isRegistrationEnabled: true,
        status: 'Upcoming',
        imageUrl:
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&h=500&fit=crop',
        galleryUrls: [],
        createdDate: '2024-09-15',
        updatedDate: '2024-10-10',
      ),
      EventModel(
        id: 'EVT-004',
        title: 'Sanskrit Chanting & Recitation Symposium',
        slug: 'sanskrit-chanting-symposium',
        description:
            'Live interactive recitation of Vedic mantras with traditional acoustics and scholar guidance.',
        date: '2024-09-28',
        startDate: '2024-09-28',
        endDate: '2024-09-28',
        startTime: '05:00 PM',
        endTime: '08:00 PM',
        location: 'Center Hall B',
        capacity: 80,
        registeredCount: 80,
        isRegistrationEnabled: false,
        status: 'Completed',
        imageUrl:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&h=500&fit=crop',
        galleryUrls: [],
        createdDate: '2024-08-20',
        updatedDate: '2024-09-28',
      ),
      EventModel(
        id: 'EVT-005',
        title: 'Annual Foundation Heritage Assembly',
        slug: 'annual-heritage-assembly',
        description:
            'Live streaming operational report and heritage presentation by foundation acharyas.',
        date: 'Today',
        startDate: '2024-10-12',
        endDate: '2024-10-12',
        startTime: '02:00 PM',
        endTime: '06:00 PM',
        location: 'Main Ashram Hall',
        capacity: 300,
        registeredCount: 280,
        isRegistrationEnabled: true,
        status: 'Live',
        imageUrl:
            'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=800&h=500&fit=crop',
        galleryUrls: [],
        createdDate: '2024-09-01',
        updatedDate: '2024-10-12',
      ),
      EventModel(
        id: 'EVT-006',
        title: 'Monsoon Manuscript Restoration Drive',
        slug: 'monsoon-manuscript-restoration',
        description:
            'Emergency climate control and preservation drive for fragile palm-leaf texts.',
        date: '2024-08-10',
        startDate: '2024-08-10',
        endDate: '2024-08-12',
        startTime: '10:00 AM',
        endTime: '05:00 PM',
        location: 'Preservation Lab',
        capacity: 30,
        registeredCount: 12,
        isRegistrationEnabled: false,
        status: 'Cancelled',
        imageUrl:
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=800&h=500&fit=crop',
        galleryUrls: [],
        createdDate: '2024-07-15',
        updatedDate: '2024-08-01',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> get _statuses => [
    'All',
    'Upcoming',
    'Live',
    'Completed',
    'Cancelled',
  ];
  List<String> get _dateFilters => [
    'All',
    'Upcoming Dates',
    'Past Dates',
    'This Month',
  ];
  List<String> get _locations => [
    'All',
    'Main Ashram Hall',
    'Conference Auditorium',
    'Virtual Workspace',
    'Center Hall B',
  ];
  List<String> get _sortOptions => [
    'Newest',
    'Title (A-Z)',
    'Status',
    'Capacity',
  ];

  List<EventModel> get _filteredEvents {
    if (_isEmptyStateSimulated) return [];

    final filtered = _events.where((event) {
      final matchesSearch =
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _selectedStatus == 'All' || event.status == _selectedStatus;
      final matchesLocation =
          _selectedLocation == 'All' || event.location == _selectedLocation;

      bool matchesDate = true;
      if (_selectedDateFilter == 'Upcoming Dates') {
        matchesDate = event.status == 'Upcoming' || event.status == 'Live';
      } else if (_selectedDateFilter == 'Past Dates') {
        matchesDate =
            event.status == 'Completed' || event.status == 'Cancelled';
      }

      return matchesSearch && matchesStatus && matchesLocation && matchesDate;
    }).toList();

    if (_sortBy == 'Title (A-Z)') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Status') {
      filtered.sort((a, b) => a.status.compareTo(b.status));
    } else if (_sortBy == 'Capacity') {
      filtered.sort((a, b) => b.capacity.compareTo(a.capacity));
    } else {
      filtered.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));
    }

    return filtered;
  }

  List<EventModel> get _paginatedEvents {
    final filtered = _filteredEvents;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];

    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get _totalPages {
    final count = _filteredEvents.length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'Live':
        return StatusType.success;
      case 'Upcoming':
        return StatusType.info;
      case 'Completed':
        return StatusType.warning;
      case 'Cancelled':
      default:
        return StatusType.error;
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
    });
  }

  void _onStatusFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedStatus = newValue;
        _currentPage = 1;
      });
    }
  }

  void _toggleRegistration(EventModel event) {
    setState(() {
      event.isRegistrationEnabled = !event.isRegistrationEnabled;
      UIUtils.showSuccessMessage(
        context,
        event.isRegistrationEnabled
            ? 'Registration opened for "${event.title}"'
            : 'Registration closed for "${event.title}"',
      );
    });
  }

  void _showViewDetailsDialog(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: TextStyle(
                  fontSize: context.responsive<double>(
                    mobile: 16,
                    tablet: 18,
                    desktop: 20,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(
              label: event.status,
              type: _getStatusType(event.status),
            ),
          ],
        ),
        content: SizedBox(
          width: context.responsive<double>(
            mobile: double.maxFinite,
            tablet: 500,
            desktop: 600,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailRow('Event ID', event.id),
                _buildDetailRow('URL Slug', '/${event.slug}'),
                _buildDetailRow('Location', event.location),
                _buildDetailRow('Date', event.date),
                _buildDetailRow(
                  'Schedule Time',
                  '${event.startTime} - ${event.endTime}',
                ),
                _buildDetailRow(
                  'Capacity',
                  '${event.registeredCount} / ${event.capacity} registered',
                ),
                _buildDetailRow(
                  'Registration',
                  event.isRegistrationEnabled
                      ? 'Enabled (Open)'
                      : 'Disabled (Closed)',
                ),
                _buildDetailRow('Created Date', event.createdDate),
                _buildDetailRow('Last Updated', event.updatedDate),
                const SizedBox(height: 16),
                const Text(
                  'Event Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textBody,
                    ),
                  ),
                ),
                if (event.galleryUrls.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Event Media & Gallery:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: event.galleryUrls.map((url) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSmall,
                          ),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              url.split('/').last,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '${AppRouter.eventsEdit}/${event.id}',
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Event'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(EventModel event) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Event',
        confirmLabel: 'Delete Event',
        confirmColor: AppColors.error,
        onConfirm: () {
          setState(() {
            _events.removeWhere((e) => e.id == event.id);
            if (_filteredEvents.isEmpty && _currentPage > 1) {
              _currentPage--;
            }
          });
          Navigator.pop(context);
          UIUtils.showSuccessMessage(
            context,
            'Event "${event.title}" has been deleted.',
          );
        },
        content: Text(
          'Are you sure you want to permanently delete the event "${event.title}"? This action cannot be undone.',
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'All';
      _selectedDateFilter = 'All';
      _selectedLocation = 'All';
      _sortBy = 'Newest';
      _currentPage = 1;
      _isEmptyStateSimulated = false;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSimulationRow(),
          const SizedBox(height: AppSizes.s12),
          _buildHeader(),
          const SizedBox(height: AppSizes.s16),
          _buildOverviewMetrics(),
          const SizedBox(height: AppSizes.s24),
          _buildFilterBar(),
          const SizedBox(height: AppSizes.s24),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSimulationRow() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics_outlined,
            color: AppColors.secondary,
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'Event Simulators:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => setState(() {
              _isEmptyStateSimulated = !_isEmptyStateSimulated;
              _hasError = false;
            }),
            icon: Icon(
              _isEmptyStateSimulated
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              size: 14,
            ),
            label: const Text('Empty State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () => setState(() {
              _hasError = !_hasError;
              _isEmptyStateSimulated = false;
            }),
            icon: Icon(
              _hasError ? Icons.check_box : Icons.check_box_outline_blank,
              size: 14,
            ),
            label: const Text('Error State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _simulateLoading,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text(
              'Loading Spinner',
              style: TextStyle(fontSize: 11),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Schedule conferences, cultural gatherings, and live foundation events.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.eventsCreate)) ...[
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.eventsCreate),
            icon: Icons.add,
            label: 'Add Event',
          ),
        ],
      ],
    );
  }

  Widget _buildOverviewMetrics() {
    final metrics = [
      (
        'Total Events',
        _events.length.toString(),
        Icons.event_note_outlined,
        AppColors.primary,
      ),
      (
        'Upcoming',
        _events.where((event) => event.status == 'Upcoming').length.toString(),
        Icons.schedule_outlined,
        AppColors.info,
      ),
      (
        'Live Now',
        _events.where((event) => event.status == 'Live').length.toString(),
        Icons.wifi_tethering_outlined,
        AppColors.success,
      ),
      (
        'Registrations',
        _events
            .fold<int>(0, (total, event) => total + event.registeredCount)
            .toString(),
        Icons.people_alt_outlined,
        AppColors.secondary,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: metrics
            .map(
              (metric) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.s12),
                child: _buildMetricCard(
                  metric.$1,
                  metric.$2,
                  metric.$3,
                  metric.$4,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: context.isMobile ? 165 : 190,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppSizes.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final bool isMobile = context.isMobile;

    if (isMobile) {
      return Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search event title, venue, or ID...',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterDropdown<String>(
                label: 'Status',
                value: _selectedStatus,
                items: _statuses,
                onChanged: _onStatusFilterChanged,
                itemLabel: (val) => val,
              ),
              FilterDropdown<String>(
                label: 'Date',
                value: _selectedDateFilter,
                items: _dateFilters,
                onChanged: (val) => setState(() => _selectedDateFilter = val!),
                itemLabel: (val) => val,
              ),
              FilterDropdown<String>(
                label: 'Location',
                value: _selectedLocation,
                items: _locations,
                onChanged: (val) => setState(() => _selectedLocation = val!),
                itemLabel: (val) => val,
              ),
              FilterDropdown<String>(
                label: 'Sort',
                value: _sortBy,
                items: _sortOptions,
                onChanged: (val) => setState(() => _sortBy = val!),
                itemLabel: (val) => val,
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search by event title, venue, or ID...',
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          flex: 2,
          child: FilterDropdown<String>(
            label: 'Status',
            value: _selectedStatus,
            items: _statuses,
            onChanged: _onStatusFilterChanged,
            itemLabel: (val) => val,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          flex: 2,
          child: FilterDropdown<String>(
            label: 'Date Range',
            value: _selectedDateFilter,
            items: _dateFilters,
            onChanged: (val) => setState(() => _selectedDateFilter = val!),
            itemLabel: (val) => val,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          flex: 2,
          child: FilterDropdown<String>(
            label: 'Location',
            value: _selectedLocation,
            items: _locations,
            onChanged: (val) => setState(() => _selectedLocation = val!),
            itemLabel: (val) => val,
          ),
        ),
        if (_searchQuery.isNotEmpty ||
            _selectedStatus != 'All' ||
            _selectedDateFilter != 'All' ||
            _selectedLocation != 'All' ||
            _sortBy != 'Newest') ...[
          const SizedBox(width: AppSizes.s12),
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: const Text('Reset'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMainContent() {
    if (_isLoading)
      return const LoadingState(message: 'Retrieving cultural events...');
    if (_hasError) {
      return ErrorState(
        message: 'Failed to load foundation events. Please try again.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredEvents.isEmpty) {
      return EmptyState(
        title: 'No Events Found',
        message:
            'No events correspond to your current search query or filter criteria.',
        icon: Icons.event_outlined,
        onAction: _clearFilters,
        actionLabel: 'Reset Filters',
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileList(),
      desktop: _buildDesktopTable(),
    );
  }

  Widget _buildDesktopTable() {
    final list = _paginatedEvents;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth:
                          context.screenWidth - AppSizes.sidebarWidth - 48,
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.background,
                      ),
                      horizontalMargin: 24,
                      columnSpacing: 24,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Event Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Location',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Capacity',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Registration',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Last Updated',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: list.map((event) {
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 230,
                                child: Row(
                                  children: [
                                    _buildEventThumbnail(
                                      event,
                                      width: 52,
                                      height: 40,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(Text(event.date)),
                            DataCell(
                              Text('${event.startTime} - ${event.endTime}'),
                            ),
                            DataCell(Text(event.location)),
                            DataCell(
                              StatusBadge(
                                label: event.status,
                                type: _getStatusType(event.status),
                              ),
                            ),
                            DataCell(Text('${event.capacity}')),
                            DataCell(
                              Row(
                                children: [
                                  Switch(
                                    value: event.isRegistrationEnabled,
                                    onChanged:
                                        PermissionService.hasPermission(
                                          AppPermissions.eventsEdit,
                                        )
                                        ? (_) => _toggleRegistration(event)
                                        : null,
                                    activeThumbColor: AppColors.primary,
                                  ),
                                  Text(
                                    '${event.registeredCount}/${event.capacity}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(event.updatedDate)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility_outlined,
                                      size: 18,
                                      color: AppColors.info,
                                    ),
                                    tooltip: 'View Details',
                                    onPressed: () =>
                                        _showViewDetailsDialog(event),
                                  ),
                                  if (PermissionService.hasPermission(
                                    AppPermissions.eventsEdit,
                                  ))
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      tooltip: 'Edit Event',
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '${AppRouter.eventsEdit}/${event.id}',
                                      ),
                                    ),
                                  if (PermissionService.hasPermission(
                                    AppPermissions.eventsDelete,
                                  ))
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: AppColors.error,
                                      ),
                                      tooltip: 'Delete Event',
                                      onPressed: () =>
                                          _showDeleteConfirmation(event),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    final list = _paginatedEvents;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.only(bottom: 8),
            itemBuilder: (context, index) {
              final e = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEventThumbnail(e, width: 72, height: 56),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          StatusBadge(
                            label: e.status,
                            type: _getStatusType(e.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Venue: ${e.location}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${e.date} • ${e.startTime} - ${e.endTime}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textBody,
                        ),
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Registered: ${e.registeredCount}/${e.capacity}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Registration: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Switch(
                                value: e.isRegistrationEnabled,
                                onChanged:
                                    PermissionService.hasPermission(
                                      AppPermissions.eventsEdit,
                                    )
                                    ? (_) => _toggleRegistration(e)
                                    : null,
                                activeThumbColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 4,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showViewDetailsDialog(e),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 14,
                              ),
                              label: const Text(
                                'Details',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: Size.zero,
                              ),
                            ),
                            if (PermissionService.hasPermission(
                              AppPermissions.eventsEdit,
                            ))
                              TextButton.icon(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '${AppRouter.eventsEdit}/${e.id}',
                                ),
                                icon: const Icon(Icons.edit_outlined, size: 14),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  minimumSize: Size.zero,
                                ),
                              ),
                            if (PermissionService.hasPermission(
                              AppPermissions.eventsDelete,
                            ))
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: AppColors.error,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                constraints: const BoxConstraints(),
                                onPressed: () => _showDeleteConfirmation(e),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _buildPaginationFooter(),
      ],
    );
  }

  Widget _buildEventThumbnail(
    EventModel event, {
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          event.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.primary.withOpacity(0.08),
            child: const Icon(Icons.event_outlined, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter() {
    return PaginationFooter(
      currentPage: _currentPage,
      totalPages: _totalPages,
      totalItems: _filteredEvents.length,
      itemsPerPage: _rowsPerPage,
      onPrevious: () => setState(() => _currentPage--),
      onNext: () => setState(() => _currentPage++),
      itemLabel: 'events',
    );
  }
}
