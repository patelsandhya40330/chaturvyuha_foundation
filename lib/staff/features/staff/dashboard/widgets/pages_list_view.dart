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

class PageModel {
  final String id;
  final String title;
  final String slug;
  String status; // 'Published', 'Draft', 'Review'
  final String lastUpdated;
  final String author;
  bool isFeatured;

  PageModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.status,
    required this.lastUpdated,
    required this.author,
    this.isFeatured = false,
  });
}

class PagesListView extends StatefulWidget {
  const PagesListView({super.key});

  @override
  State<PagesListView> createState() => _PagesListViewState();
}

class _PagesListViewState extends State<PagesListView> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _sortBy = 'Newest';

  int _currentPage = 1;
  final int _rowsPerPage = 5;

  late List<PageModel> _pages;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    _pages = [
      PageModel(
        id: 'PAG-001',
        title: 'Home Portal Interface',
        slug: 'home-portal',
        status: 'Published',
        lastUpdated: '2024-09-01 10:24',
        author: 'Acharya Sharma',
        isFeatured: true,
      ),
      PageModel(
        id: 'PAG-002',
        title: 'About the Foundation Repository',
        slug: 'about-us',
        status: 'Published',
        lastUpdated: '2024-09-05 14:15',
        author: 'Admin User',
        isFeatured: true,
      ),
      PageModel(
        id: 'PAG-003',
        title: 'Vedic Research Center Guidelines',
        slug: 'vedic-research',
        status: 'Review',
        lastUpdated: '2024-09-12 11:02',
        author: 'Manning D.',
        isFeatured: false,
      ),
      PageModel(
        id: 'PAG-004',
        title: 'Volunteer Registration & Seva Information',
        slug: 'volunteer-seva',
        status: 'Draft',
        lastUpdated: '2024-09-20 09:45',
        author: 'Admin User',
        isFeatured: false,
      ),
      PageModel(
        id: 'PAG-005',
        title: 'Contact and Center Locations Directory',
        slug: 'contact-us',
        status: 'Published',
        lastUpdated: '2024-09-21 16:30',
        author: 'Acharya Sharma',
        isFeatured: false,
      ),
      PageModel(
        id: 'PAG-006',
        title: 'Terms of Use & Scriptural Citation Policy',
        slug: 'terms-policy',
        status: 'Published',
        lastUpdated: '2024-09-25 18:20',
        author: 'Manning D.',
        isFeatured: false,
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

  List<String> get _statuses => ['All', 'Published', 'Draft', 'Review'];
  List<String> get _sortOptions => ['Newest', 'Title (A-Z)', 'Status'];

  List<PageModel> get _filteredPages {
    if (_isEmptyStateSimulated) return [];

    final filtered = _pages.where((page) {
      final matchesSearch = page.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          page.slug.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          page.author.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatus == 'All' || page.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    if (_sortBy == 'Title (A-Z)') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Status') {
      filtered.sort((a, b) => a.status.compareTo(b.status));
    } else {
      filtered.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    }

    return filtered;
  }

  List<PageModel> get _paginatedPages {
    final filtered = _filteredPages;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];

    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  int get _totalPages {
    final count = _filteredPages.length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'Published':
        return StatusType.success;
      case 'Draft':
        return StatusType.warning;
      case 'Review':
        return StatusType.info;
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

  void _togglePublish(PageModel page) {
    setState(() {
      if (page.status == 'Published') {
        page.status = 'Draft';
        UIUtils.showSuccessMessage(context, 'Page "${page.title}" has been unpublished.');
      } else {
        page.status = 'Published';
        UIUtils.showSuccessMessage(context, 'Page "${page.title}" is now published.');
      }
    });
  }

  void _toggleFeatured(PageModel page) {
    setState(() {
      page.isFeatured = !page.isFeatured;
      UIUtils.showSuccessMessage(
        context,
        page.isFeatured ? 'Page "${page.title}" set as featured.' : 'Page "${page.title}" removed from featured.',
      );
    });
  }

  void _showPreviewDialog(PageModel page) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.laptop_chromebook, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Live Preview: ${page.title}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 650,
          height: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.sidebarBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.green, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'https://cfoundation.org/${page.slug}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(label: page.status, type: _getStatusType(page.status)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Page Sections Preview:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Hero
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                page.title,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Last updated by ${page.author} • ${page.lastUpdated}',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Section 2: Text Section
                        const Text('1. Hero Section', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accent)),
                        const SizedBox(height: 4),
                        const Text('Welcome to our institutional portal workspace. This section outlines key cultural assets and metadata indexing.', style: TextStyle(fontSize: 13, color: AppColors.textBody)),
                        const Divider(height: 24),

                        // Section 3: Content
                        const Text('2. Content Block', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accent)),
                        const SizedBox(height: 4),
                        const Text('Content layouts are rendered on a responsive flex layout engine supporting full breakpoints on Web, Android, and desktop architectures.', style: TextStyle(fontSize: 13, color: AppColors.textBody)),
                        const Divider(height: 24),

                        // Section 4: CTA
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text('Join our volunteer network and contribute to heritage digitization.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                                child: const Text('Get Started', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close Preview'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '${AppRouter.pagesEdit}/${page.id}');
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Page'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PageModel page) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirm Page Deletion',
        icon: Icons.warning_amber_rounded,
        confirmColor: AppColors.error,
        confirmLabel: 'Delete Page',
        onConfirm: () {
          setState(() {
            _pages.removeWhere((item) => item.id == page.id);
            if (_filteredPages.isEmpty && _currentPage > 1) {
              _currentPage--;
            }
          });
          Navigator.pop(context);
          UIUtils.showSuccessMessage(context, 'Page "${page.title}" has been permanently purged.');
        },
        content: Text.rich(
          TextSpan(
            text: 'Are you sure you want to permanently delete the page ',
            style: const TextStyle(color: AppColors.textBody),
            children: [
              TextSpan(
                text: '"${page.title}"',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              TextSpan(text: ' (/${page.slug})? This action cannot be undone.'),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'All';
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
          _buildPageHeader(),
          const SizedBox(height: AppSizes.s24),
          _buildFilterBar(),
          const SizedBox(height: AppSizes.s24),
          Expanded(child: _buildMainContentState()),
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
            'Pages Simulators:',
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

  Widget _buildPageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pages Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Create, publish, and structure customized static content layouts.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14),
              ),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.pagesCreate)) ...[
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.pagesCreate),
            icon: Icons.add,
            label: ResponsiveLayout.isMobile(context) ? 'New' : 'Add New Page',
          ),
        ],
      ],
    );
  }

  Widget _buildFilterBar() {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    if (isMobile) {
      return Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search pages, slugs...',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilterDropdown<String>(
                  label: 'Status',
                  value: _selectedStatus,
                  items: _statuses,
                  onChanged: _onStatusFilterChanged,
                  itemLabel: (val) => val,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterDropdown<String>(
                  label: 'Sort',
                  value: _sortBy,
                  items: _sortOptions,
                  onChanged: (val) => setState(() => _sortBy = val!),
                  itemLabel: (val) => val,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search by page title, slug url, or author...',
          ),
        ),
        const SizedBox(width: AppSizes.s16),
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
        const SizedBox(width: AppSizes.s16),
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
        if (_searchQuery.isNotEmpty || _selectedStatus != 'All' || _sortBy != 'Newest') ...[
          const SizedBox(width: AppSizes.s16),
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Reset'),
          ),
        ],
      ],
    );
  }

  Widget _buildMainContentState() {
    if (_isLoading) {
      return const LoadingState(message: 'Retrieving Pages...');
    }
    if (_hasError) {
      return ErrorState(
        message: 'Failed to load foundation pages. Please try again.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredPages.isEmpty) {
      return EmptyState(
        title: 'No Pages Found',
        message: 'No pages correspond to your current search query or filter criteria.',
        icon: Icons.pages_outlined,
        onAction: _clearFilters,
        actionLabel: 'Reset Filters',
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileCards(),
      desktop: _buildDesktopTable(),
    );
  }

  Widget _buildDesktopTable() {
    final list = _paginatedPages;
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
                      DataColumn(label: Text('Page Title')),
                      DataColumn(label: Text('Slug URL')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Featured')),
                      DataColumn(label: Text('Last Updated')),
                      DataColumn(label: Text('Author')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: list.map((page) {
                      return DataRow(cells: [
                        DataCell(
                          Row(
                            children: [
                              Text(page.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (page.isFeatured) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                              ],
                            ],
                          ),
                        ),
                        DataCell(Text('/${page.slug}', style: const TextStyle(fontFamily: 'monospace', color: AppColors.primary))),
                        DataCell(StatusBadge(label: page.status, type: _getStatusType(page.status))),
                        DataCell(
                          IconButton(
                            icon: Icon(
                              page.isFeatured ? Icons.star : Icons.star_border,
                              color: page.isFeatured ? Colors.amber : AppColors.textDisabled,
                              size: 18,
                            ),
                            tooltip: page.isFeatured ? 'Featured Page' : 'Mark as Featured',
                            onPressed: () => _toggleFeatured(page),
                          ),
                        ),
                        DataCell(Text(page.lastUpdated)),
                        DataCell(Text(page.author)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, color: AppColors.info, size: 18),
                                tooltip: 'Live Preview',
                                onPressed: () => _showPreviewDialog(page),
                              ),
                              if (PermissionService.hasPermission(AppPermissions.pagesEdit))
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                                  tooltip: 'Edit Page',
                                  onPressed: () => Navigator.pushNamed(context, '${AppRouter.pagesEdit}/${page.id}'),
                                ),
                              if (PermissionService.hasPermission(AppPermissions.pagesEdit))
                                IconButton(
                                  icon: Icon(page.status == 'Published' ? Icons.cloud_off : Icons.cloud_done, color: Colors.orange, size: 18),
                                  tooltip: page.status == 'Published' ? 'Unpublish' : 'Publish',
                                  onPressed: () => _togglePublish(page),
                                ),
                              if (PermissionService.hasPermission(AppPermissions.pagesDelete))
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                                  tooltip: 'Delete Page',
                                  onPressed: () => _showDeleteConfirmation(page),
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

  Widget _buildMobileCards() {
    final list = _paginatedPages;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final page = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(page.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          if (page.isFeatured) const Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('/${page.slug}', style: const TextStyle(color: AppColors.primary, fontFamily: 'monospace', fontSize: 13)),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Author: ${page.author}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          StatusBadge(label: page.status, type: _getStatusType(page.status)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Updated: ${page.lastUpdated}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(page.isFeatured ? Icons.star : Icons.star_border, color: page.isFeatured ? Colors.amber : AppColors.textDisabled, size: 18),
                            onPressed: () => _toggleFeatured(page),
                          ),
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, color: AppColors.info, size: 18),
                            onPressed: () => _showPreviewDialog(page),
                          ),
                          if (PermissionService.hasPermission(AppPermissions.pagesEdit))
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                              onPressed: () => Navigator.pushNamed(context, '${AppRouter.pagesEdit}/${page.id}'),
                            ),
                          if (PermissionService.hasPermission(AppPermissions.pagesEdit))
                            IconButton(
                              icon: Icon(page.status == 'Published' ? Icons.cloud_off : Icons.cloud_done, color: Colors.orange, size: 18),
                              onPressed: () => _togglePublish(page),
                            ),
                          if (PermissionService.hasPermission(AppPermissions.pagesDelete))
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
                              onPressed: () => _showDeleteConfirmation(page),
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
      totalItems: _filteredPages.length,
      itemsPerPage: _rowsPerPage,
      onPrevious: () => setState(() => _currentPage--),
      onNext: () => setState(() => _currentPage++),
      itemLabel: 'pages',
    );
  }
}
