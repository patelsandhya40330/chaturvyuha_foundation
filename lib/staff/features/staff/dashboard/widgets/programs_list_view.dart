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

class ProgramModel {
  final String id;
  final String title;
  final String type;
  final String description;
  final String schedule;
  final String instructor;
  final String location;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final int capacity;
  final int enrolledCount;
  final int resourceCount;
  final String resources;
  bool isRegistrationOpen;
  String status; // 'Draft', 'Active', 'Inactive', 'Completed'
  final String createdDate;
  final String updatedDate;

  ProgramModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.schedule,
    required this.instructor,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.enrolledCount,
    required this.resourceCount,
    required this.resources,
    required this.isRegistrationOpen,
    required this.status,
    required this.createdDate,
    required this.updatedDate,
  });
}

class ProgramsListView extends StatefulWidget {
  const ProgramsListView({super.key});

  @override
  State<ProgramsListView> createState() => _ProgramsListViewState();
}

class _ProgramsListViewState extends State<ProgramsListView> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedType = 'All';
  String _sortBy = 'Newest';

  int _currentPage = 1;
  final int _rowsPerPage = 5;

  late List<ProgramModel> _programs;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    _programs = [
      ProgramModel(
        id: 'PRG-001',
        title: 'Vedic Philosophy 101 Foundations',
        type: 'Vedic Literature',
        description: 'An introductory course exploring the foundational principles of Vedic thought and scriptural hermeneutics.',
        schedule: 'Mon, Wed • 10:00 AM - 11:30 AM',
        instructor: 'Acharya Sharma',
        location: 'Main Ashram Hall',
        startDate: '2024-02-01',
        endDate: '2024-05-30',
        startTime: '10:00 AM',
        endTime: '11:30 AM',
        capacity: 50,
        enrolledCount: 42,
        resourceCount: 12,
        resources: 'Vedic Grammar Guide, Audio Chants, Manuscript Notes',
        isRegistrationOpen: true,
        status: 'Active',
        createdDate: '2024-01-15',
        updatedDate: '2024-02-01',
      ),
      ProgramModel(
        id: 'PRG-002',
        title: 'Advanced Meditation & Mindfulness Workshop',
        type: 'Meditation & Yoga',
        description: 'Deep dive into specialized pranayama and meditation techniques for spiritual focus and mental health.',
        schedule: 'Sat • 08:00 AM - 12:00 PM',
        instructor: 'Dr. K. Rao',
        location: 'Conference Auditorium',
        startDate: '2024-03-01',
        endDate: '2024-04-15',
        startTime: '08:00 AM',
        endTime: '12:00 PM',
        capacity: 30,
        enrolledCount: 30,
        resourceCount: 5,
        resources: 'Breathing Manual, Audio Tracks',
        isRegistrationOpen: false,
        status: 'Active',
        createdDate: '2024-02-10',
        updatedDate: '2024-03-01',
      ),
      ProgramModel(
        id: 'PRG-003',
        title: 'Sanskrit Grammar Basics & Scriptural Decoding',
        type: 'Sanskrit Language',
        description: 'Learning the basics of Sanskrit grammar, verb roots, and authentic text translation techniques.',
        schedule: 'Tue, Thu • 02:00 PM - 03:30 PM',
        instructor: 'Manning D.',
        location: 'Virtual Workspace',
        startDate: '2024-04-01',
        endDate: '2024-07-30',
        startTime: '02:00 PM',
        endTime: '03:30 PM',
        capacity: 60,
        enrolledCount: 35,
        resourceCount: 20,
        resources: 'Panini Grammar Cards, Exercise Worksheets, Dictionary Access',
        isRegistrationOpen: true,
        status: 'Active',
        createdDate: '2024-03-05',
        updatedDate: '2024-04-01',
      ),
      ProgramModel(
        id: 'PRG-004',
        title: 'Youth Heritage & Cultural Leadership Seva',
        type: 'Youth Heritage',
        description: 'Empowering young scholars to participate in heritage preservation, manuscript logging, and community education.',
        schedule: 'Fri • 04:00 PM - 06:00 PM',
        instructor: 'Admin User',
        location: 'Center Hall B',
        startDate: '2024-05-10',
        endDate: '2024-08-20',
        startTime: '04:00 PM',
        endTime: '06:00 PM',
        capacity: 40,
        enrolledCount: 15,
        resourceCount: 8,
        resources: 'Volunteer Handbook, Ethics Code',
        isRegistrationOpen: true,
        status: 'Draft',
        createdDate: '2024-04-12',
        updatedDate: '2024-05-10',
      ),
      ProgramModel(
        id: 'PRG-005',
        title: 'Holistic Yoga Systems & Wellness Seminar',
        type: 'Meditation & Yoga',
        description: 'Integrating traditional physical postures with breathing exercises and ancient wellness principles.',
        schedule: 'Daily • 06:00 AM - 07:30 AM',
        instructor: 'Dr. K. Rao',
        location: 'Ashram Courtyard',
        startDate: '2024-01-01',
        endDate: '2024-03-31',
        startTime: '06:00 AM',
        endTime: '07:30 AM',
        capacity: 25,
        enrolledCount: 25,
        resourceCount: 15,
        resources: 'Asana Charts, Nutrition Guide',
        isRegistrationOpen: false,
        status: 'Completed',
        createdDate: '2023-12-01',
        updatedDate: '2024-03-31',
      ),
      ProgramModel(
        id: 'PRG-006',
        title: 'Community Manuscript Archiving Seva',
        type: 'Community Seva',
        description: 'Practical training on digital scanning, metadata tagging, and palm-leaf manuscript preservation.',
        schedule: 'Sat • 10:00 AM - 01:00 PM',
        instructor: 'Acharya Sharma',
        location: 'Digital Preservation Lab',
        startDate: '2024-06-01',
        endDate: '2024-09-30',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        capacity: 20,
        enrolledCount: 0,
        resourceCount: 3,
        resources: 'Scanning Guidelines, Tagging Standards',
        isRegistrationOpen: false,
        status: 'Inactive',
        createdDate: '2024-05-01',
        updatedDate: '2024-06-01',
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

  List<String> get _statuses => ['All', 'Draft', 'Active', 'Inactive', 'Completed'];
  List<String> get _types => ['All', 'Vedic Literature', 'Meditation & Yoga', 'Sanskrit Language', 'Youth Heritage', 'Community Seva'];
  List<String> get _sortOptions => ['Newest', 'Title (A-Z)', 'Status', 'Capacity'];

  List<ProgramModel> get _filteredPrograms {
    if (_isEmptyStateSimulated) return [];

    final filtered = _programs.where((program) {
      final matchesSearch = program.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          program.instructor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          program.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatus == 'All' || program.status == _selectedStatus;
      final matchesType = _selectedType == 'All' || program.type == _selectedType;

      return matchesSearch && matchesStatus && matchesType;
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

  List<ProgramModel> get _paginatedPrograms {
    final filtered = _filteredPrograms;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];

    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  int get _totalPages {
    final count = _filteredPrograms.length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'Active':
        return StatusType.success;
      case 'Draft':
        return StatusType.warning;
      case 'Completed':
        return StatusType.info;
      case 'Inactive':
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

  void _onTypeFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedType = newValue;
        _currentPage = 1;
      });
    }
  }

  void _toggleRegistration(ProgramModel program) {
    setState(() {
      program.isRegistrationOpen = !program.isRegistrationOpen;
      UIUtils.showSuccessMessage(
        context,
        program.isRegistrationOpen
            ? 'Registration opened for "${program.title}"'
            : 'Registration closed for "${program.title}"',
      );
    });
  }

  void _showViewDetailsDialog(ProgramModel program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(program.title, style: TextStyle(fontSize: context.responsive<double>(mobile: 16, tablet: 18, desktop: 20), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            StatusBadge(label: program.status, type: _getStatusType(program.status)),
          ],
        ),
        content: SizedBox(
          width: context.responsive<double>(mobile: double.maxFinite, tablet: 500, desktop: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailRow('Program ID', program.id),
                _buildDetailRow('Program Type', program.type),
                _buildDetailRow('Instructor', program.instructor),
                _buildDetailRow('Schedule', program.schedule),
                _buildDetailRow('Location', program.location),
                _buildDetailRow('Duration', '${program.startDate} to ${program.endDate}'),
                _buildDetailRow('Time', '${program.startTime} - ${program.endTime}'),
                _buildDetailRow('Capacity', '${program.enrolledCount} / ${program.capacity} participants enrolled'),
                _buildDetailRow('Registration', program.isRegistrationOpen ? 'Open (Accepting Registrations)' : 'Closed'),
                _buildDetailRow('Resources (${program.resourceCount})', program.resources),
                _buildDetailRow('Created Date', program.createdDate),
                _buildDetailRow('Last Updated', program.updatedDate),
                const SizedBox(height: 16),
                const Text('Program Description:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                    program.description,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textBody),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '${AppRouter.programsEdit}/${program.id}');
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Program'),
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
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ProgramModel program) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Educational Program',
        confirmLabel: 'Delete Program',
        confirmColor: AppColors.error,
        onConfirm: () {
          setState(() {
            _programs.removeWhere((p) => p.id == program.id);
            if (_filteredPrograms.isEmpty && _currentPage > 1) {
              _currentPage--;
            }
          });
          Navigator.pop(context);
          UIUtils.showSuccessMessage(context, 'Program "${program.title}" has been deleted.');
        },
        content: Text('Are you sure you want to permanently delete "${program.title}"? This action cannot be undone.'),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'All';
      _selectedType = 'All';
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
          const Icon(Icons.analytics_outlined, color: AppColors.secondary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Program Simulators:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => setState(() {
              _isEmptyStateSimulated = !_isEmptyStateSimulated;
              _hasError = false;
            }),
            icon: Icon(_isEmptyStateSimulated ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Empty State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () => setState(() {
              _hasError = !_hasError;
              _isEmptyStateSimulated = false;
            }),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Programs Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('Manage courses, heritage workshops, seminars, and participant registrations.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.programsCreate)) ...[
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.programsCreate),
            icon: Icons.add,
            label: 'Add Program',
          ),
        ],
      ],
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
            hintText: 'Search by title, instructor, or ID...',
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
                label: 'Type',
                value: _selectedType,
                items: _types,
                onChanged: _onTypeFilterChanged,
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
            hintText: 'Search by program title, instructor, or ID...',
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
            label: 'Program Type',
            value: _selectedType,
            items: _types,
            onChanged: _onTypeFilterChanged,
            itemLabel: (val) => val,
          ),
        ),
        const SizedBox(width: AppSizes.s12),
        Expanded(
          flex: 2,
          child: FilterDropdown<String>(
            label: 'Sort By',
            value: _sortBy,
            items: _sortOptions,
            onChanged: (val) => setState(() => _sortBy = val!),
            itemLabel: (val) => val,
          ),
        ),
        if (_searchQuery.isNotEmpty || _selectedStatus != 'All' || _selectedType != 'All' || _sortBy != 'Newest') ...[
          const SizedBox(width: AppSizes.s12),
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.filter_alt_off, size: 16),
            label: const Text('Reset'),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) return const LoadingState(message: 'Retrieving educational programs...');
    if (_hasError) {
      return ErrorState(
        message: 'Failed to load foundation programs. Please try again.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredPrograms.isEmpty) {
      return EmptyState(
        title: 'No Programs Found',
        message: 'No programs correspond to your current search query or filter criteria.',
        icon: Icons.school_outlined,
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
    final list = _paginatedPrograms;
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
                    constraints: BoxConstraints(minWidth: context.screenWidth - AppSizes.sidebarWidth - 48),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.background),
                    horizontalMargin: 24,
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('Program Name', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Instructor', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Registration', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Last Updated', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: list.map((program) {
                      return DataRow(cells: [
                        DataCell(
                          Container(
                            width: 220,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(program.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(Text(program.type)),
                        DataCell(Text(program.instructor)),
                        DataCell(Text(program.schedule)),
                        DataCell(StatusBadge(label: program.status, type: _getStatusType(program.status))),
                        DataCell(
                          Row(
                            children: [
                              Switch(
                                value: program.isRegistrationOpen,
                                onChanged: PermissionService.hasPermission(AppPermissions.programsEdit)
                                    ? (_) => _toggleRegistration(program)
                                    : null,
                                activeThumbColor: AppColors.primary,
                              ),
                              Text(
                                program.isRegistrationOpen ? 'Open' : 'Closed',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: program.isRegistrationOpen ? AppColors.success : AppColors.textDisabled,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(Text(program.updatedDate)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.info),
                                tooltip: 'View Program Details',
                                onPressed: () => _showViewDetailsDialog(program),
                              ),
                              if (PermissionService.hasPermission(AppPermissions.programsEdit))
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                  tooltip: 'Edit Program',
                                  onPressed: () => Navigator.pushNamed(context, '${AppRouter.programsEdit}/${program.id}'),
                                ),
                              if (PermissionService.hasPermission(AppPermissions.programsDelete))
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                  tooltip: 'Delete Program',
                                  onPressed: () => _showDeleteConfirmation(program),
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
        ),
          _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    final list = _paginatedPrograms;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.only(bottom: 8),
            itemBuilder: (context, index) {
              final p = list[index];
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
                          Expanded(
                            child: Text(p.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          ),
                          StatusBadge(label: p.status, type: _getStatusType(p.status)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${p.type} • Instructor: ${p.instructor}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('Schedule: ${p.schedule}', style: const TextStyle(fontSize: 12, color: AppColors.textBody)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Enrolled: ${p.enrolledCount}/${p.capacity}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              const Text('Registration: ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              Switch(
                                value: p.isRegistrationOpen,
                                onChanged: PermissionService.hasPermission(AppPermissions.programsEdit) ? (_) => _toggleRegistration(p) : null,
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
                              onPressed: () => _showViewDetailsDialog(p),
                              icon: const Icon(Icons.visibility_outlined, size: 14),
                              label: const Text('Details', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: Size.zero),
                            ),
                            if (PermissionService.hasPermission(AppPermissions.programsEdit))
                              TextButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '${AppRouter.programsEdit}/${p.id}'),
                                icon: const Icon(Icons.edit_outlined, size: 14),
                                label: const Text('Edit', style: TextStyle(fontSize: 12)),
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: Size.zero),
                              ),
                            if (PermissionService.hasPermission(AppPermissions.programsDelete))
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                constraints: const BoxConstraints(),
                                onPressed: () => _showDeleteConfirmation(p),
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

  Widget _buildPaginationFooter() {
    return PaginationFooter(
      currentPage: _currentPage,
      totalPages: _totalPages,
      totalItems: _filteredPrograms.length,
      itemsPerPage: _rowsPerPage,
      onPrevious: () => setState(() => _currentPage--),
      onNext: () => setState(() => _currentPage++),
      itemLabel: 'programs',
    );
  }
}
