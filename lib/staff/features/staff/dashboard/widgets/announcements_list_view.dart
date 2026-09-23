import 'package:chaturvyuha_foundation/staff/core/auth/permission_service.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/core/routing/app_router.dart';
import 'package:chaturvyuha_foundation/staff/core/utils/ui_utils.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/buttons.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/dialogs.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/form_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/navigation_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/state_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AnnouncementPriority { low, medium, high }

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final DateTime startDate;
  final DateTime? expiryDate;
  String status; // 'Published', 'Draft', 'Scheduled', 'Expired'

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.startDate,
    this.expiryDate,
    required this.status,
  });
}

class AnnouncementsListView extends StatefulWidget {
  const AnnouncementsListView({super.key});

  @override
  State<AnnouncementsListView> createState() => _AnnouncementsListViewState();
}

class _AnnouncementsListViewState extends State<AnnouncementsListView> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedPriority = 'All';

  int _currentPage = 1;
  final int _rowsPerPage = 10;

  late List<AnnouncementModel> _announcements;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    final now = DateTime.now();
    _announcements = [
      AnnouncementModel(
        id: 'ANN-001',
        title: 'System Maintenance Scheduled',
        content: 'The staff portal will be down for maintenance on Sunday from 2 AM to 4 AM UTC.',
        priority: AnnouncementPriority.high,
        startDate: now.subtract(const Duration(days: 1)),
        expiryDate: now.add(const Duration(days: 2)),
        status: 'Published',
      ),
      AnnouncementModel(
        id: 'ANN-002',
        title: 'New Health Policy for Staff',
        content: 'Please review the updated health insurance policy in the settings module.',
        priority: AnnouncementPriority.medium,
        startDate: now.subtract(const Duration(days: 5)),
        expiryDate: now.add(const Duration(days: 30)),
        status: 'Published',
      ),
      AnnouncementModel(
        id: 'ANN-003',
        title: 'Volunteer Appreciation Day',
        content: 'Join us for a celebration of our volunteers next Friday at the main hall.',
        priority: AnnouncementPriority.low,
        startDate: now.add(const Duration(days: 3)),
        expiryDate: now.add(const Duration(days: 7)),
        status: 'Scheduled',
      ),
      AnnouncementModel(
        id: 'ANN-004',
        title: 'Quarterly Foundation Meeting',
        content: 'Agenda for the upcoming quarterly meeting is now available for download.',
        priority: AnnouncementPriority.high,
        startDate: now.subtract(const Duration(days: 10)),
        expiryDate: now.subtract(const Duration(days: 1)),
        status: 'Expired',
      ),
      AnnouncementModel(
        id: 'ANN-005',
        title: 'Draft: New Office Hours',
        content: 'We are considering changing office hours to 8 AM - 4 PM. Feedback welcome.',
        priority: AnnouncementPriority.low,
        startDate: now.add(const Duration(days: 14)),
        status: 'Draft',
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

  List<String> get _statuses => ['All', 'Published', 'Draft', 'Scheduled', 'Expired'];
  List<String> get _priorities => ['All', 'Low', 'Medium', 'High'];

  List<AnnouncementModel> get _filteredAnnouncements {
    if (_isEmptyStateSimulated) return [];

    return _announcements.where((ann) {
      final matchesSearch = ann.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ann.content.toLowerCase().contains(_searchQuery.toLowerCase());
          
      final matchesStatus = _selectedStatus == 'All' || ann.status == _selectedStatus;
      final matchesPriority = _selectedPriority == 'All' || 
          ann.priority.name.toLowerCase() == _selectedPriority.toLowerCase();

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  List<AnnouncementModel> get _paginatedAnnouncements {
    final filtered = _filteredAnnouncements;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];
    
    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  int get _totalPages {
    final count = _filteredAnnouncements.length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'Published':
        return StatusType.success;
      case 'Draft':
        return StatusType.warning;
      case 'Scheduled':
        return StatusType.info;
      case 'Expired':
        return StatusType.error;
      default:
        return StatusType.info;
    }
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.high:
        return AppColors.error;
      case AnnouncementPriority.medium:
        return AppColors.warning;
      case AnnouncementPriority.low:
        return AppColors.info;
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

  void _onPriorityFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedPriority = newValue;
        _currentPage = 1;
      });
    }
  }

  void _showDeleteConfirmation(AnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Announcement',
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () {
          setState(() {
            _announcements.removeWhere((a) => a.id == announcement.id);
          });
          Navigator.pop(context);
          UIUtils.showSuccessMessage(context, 'Announcement deleted.');
        },
        content: Text('Are you sure you want to permanently delete "${announcement.title}"?'),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'All';
      _selectedPriority = 'All';
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSimulatorRow(),
          const SizedBox(height: AppSizes.s12),
          _buildHeader(),
          const SizedBox(height: AppSizes.s24),
          _buildFilterBar(),
          const SizedBox(height: AppSizes.s24),
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildSimulatorRow() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_outlined, color: AppColors.secondary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Announcements Simulators:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => setState(() { _isEmptyStateSimulated = !_isEmptyStateSimulated; _hasError = false; }),
            icon: Icon(_isEmptyStateSimulated ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Empty State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () => setState(() { _hasError = !_hasError; _isEmptyStateSimulated = false; }),
            icon: Icon(_hasError ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Error State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _simulateLoading,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text('Loading Spinner', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
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
                'Announcements',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Broadcast system alerts and foundation notices to staff.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.announcementsCreate)) ...[
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.announcementsCreate),
            icon: Icons.add_alert_outlined,
            label: 'Create Announcement',
          ),
        ],
      ],
    );
  }

  Widget _buildFilterBar() {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        SizedBox(
          width: isMobile ? double.infinity : 300,
          child: SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search announcements...',
          ),
        ),
        SizedBox(
          width: isMobile ? (MediaQuery.of(context).size.width - 64) / 2 : 150,
          child: FilterDropdown<String>(
            label: 'Status',
            value: _selectedStatus,
            items: _statuses,
            onChanged: _onStatusFilterChanged,
            itemLabel: (val) => val,
          ),
        ),
        SizedBox(
          width: isMobile ? (MediaQuery.of(context).size.width - 64) / 2 : 150,
          child: FilterDropdown<String>(
            label: 'Priority',
            value: _selectedPriority,
            items: _priorities,
            onChanged: _onPriorityFilterChanged,
            itemLabel: (val) => val,
          ),
        ),
        if (_searchQuery.isNotEmpty || _selectedStatus != 'All' || _selectedPriority != 'All')
          IconButton(
            onPressed: _clearFilters,
            icon: const Icon(Icons.filter_alt_off_outlined),
            tooltip: 'Clear Filters',
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) return const LoadingState(message: 'Retrieving Announcements...');
    if (_hasError) {
      return ErrorState(
        message: 'Error loading announcements.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredAnnouncements.isEmpty) {
      return EmptyState(
        title: 'No Announcements Found',
        message: 'No announcements correspond to your current filter criteria.',
        icon: Icons.announcement_outlined,
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
    final list = _paginatedAnnouncements;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - AppSizes.sidebarWidth - 80,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.background),
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Priority')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Start Date')),
                      DataColumn(label: Text('Expiry Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: list.map((ann) {
                      return DataRow(cells: [
                        DataCell(
                          Container(
                            width: 250,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ann.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text(
                                  ann.content,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(ann.priority).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ann.priority.name.toUpperCase(),
                              style: TextStyle(
                                color: _getPriorityColor(ann.priority),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(StatusBadge(label: ann.status, type: _getStatusType(ann.status))),
                        DataCell(Text(DateFormat('yyyy-MM-dd HH:mm').format(ann.startDate))),
                        DataCell(Text(ann.expiryDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(ann.expiryDate!) : 'Never')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (PermissionService.hasPermission(AppPermissions.announcementsEdit))
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                                  tooltip: 'Edit',
                                  onPressed: () => Navigator.pushNamed(context, '${AppRouter.announcementsEdit}/${ann.id}'),
                                ),
                              if (PermissionService.hasPermission(AppPermissions.announcementsDelete))
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                                  tooltip: 'Delete',
                                  onPressed: () => _showDeleteConfirmation(ann),
                                ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
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
    final list = _paginatedAnnouncements;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final ann = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(label: ann.status, type: _getStatusType(ann.status)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(ann.priority).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              ann.priority.name.toUpperCase(),
                              style: TextStyle(
                                color: _getPriorityColor(ann.priority),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(ann.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        ann.content,
                        style: const TextStyle(fontSize: 13, color: AppColors.textBody),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd').format(ann.startDate),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          if (ann.expiryDate != null) ...[
                            const Text(' - ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text(
                              DateFormat('MMM dd').format(ann.expiryDate!),
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                          const Spacer(),
                          if (PermissionService.hasPermission(AppPermissions.announcementsEdit))
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                              onPressed: () => Navigator.pushNamed(context, '${AppRouter.announcementsEdit}/${ann.id}'),
                            ),
                          if (PermissionService.hasPermission(AppPermissions.announcementsDelete))
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                              onPressed: () => _showDeleteConfirmation(ann),
                            ),
                        ],
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

  Widget _buildPaginationFooter() {
    return PaginationFooter(
      currentPage: _currentPage,
      totalPages: _totalPages,
      totalItems: _filteredAnnouncements.length,
      itemsPerPage: _rowsPerPage,
      onPrevious: () => setState(() => _currentPage--),
      onNext: () => setState(() => _currentPage++),
      itemLabel: 'announcements',
    );
  }
}
