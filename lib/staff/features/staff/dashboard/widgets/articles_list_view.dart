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

class ArticleModel {
  final String id;
  final String title;
  final String category;
  final String author;
  String status; // 'Published', 'Draft', 'Pending Review', 'Unpublished'
  final String publishedDate;
  final String updatedDate;
  bool isFeatured;

  ArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.status,
    required this.publishedDate,
    required this.updatedDate,
    required this.isFeatured,
  });
}

class ArticlesListView extends StatefulWidget {
  const ArticlesListView({super.key});

  @override
  State<ArticlesListView> createState() => _ArticlesListViewState();
}

class _ArticlesListViewState extends State<ArticlesListView> {
  // State variables
  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedCategory = 'All';
  String _selectedFeatured = 'All';
  String _sortBy = 'Newest';

  int _currentPage = 1;
  final int _rowsPerPage = 5;

  late List<ArticleModel> _articles;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    _articles = [
      ArticleModel(
        id: 'ART-001',
        title: 'Introduction to Vedic Studies and Philosophy',
        category: 'Vedic Studies',
        author: 'Acharya Sharma',
        status: 'Published',
        publishedDate: '2024-01-10',
        updatedDate: '2024-02-15',
        isFeatured: true,
      ),
      ArticleModel(
        id: 'ART-002',
        title: 'The Art of Mindful Breathing and Meditation',
        category: 'Meditation',
        author: 'Dr. K. Rao',
        status: 'Published',
        publishedDate: '2024-03-05',
        updatedDate: '2024-03-05',
        isFeatured: false,
      ),
      ArticleModel(
        id: 'ART-003',
        title: 'Community Outreach Report 2024 First Quarter',
        category: 'Community',
        author: 'Admin User',
        status: 'Draft',
        publishedDate: '—',
        updatedDate: '2024-04-01',
        isFeatured: false,
      ),
      ArticleModel(
        id: 'ART-004',
        title: 'Preserving Ancient Sanskrit Manuscripts for Posterity',
        category: 'History',
        author: 'Manning D.',
        status: 'Pending Review',
        publishedDate: '—',
        updatedDate: '2024-05-12',
        isFeatured: true,
      ),
      ArticleModel(
        id: 'ART-005',
        title: 'Yoga Systems and Contemporary Mental Health Practices',
        category: 'Meditation',
        author: 'Dr. K. Rao',
        status: 'Published',
        publishedDate: '2024-05-20',
        updatedDate: '2024-06-01',
        isFeatured: false,
      ),
      ArticleModel(
        id: 'ART-006',
        title: 'Sanskrit Grammar Basics: A Guide for Beginners',
        category: 'Vedic Studies',
        author: 'Acharya Sharma',
        status: 'Unpublished',
        publishedDate: '2024-06-15',
        updatedDate: '2024-06-18',
        isFeatured: false,
      ),
      ArticleModel(
        id: 'ART-007',
        title: 'Annual Foundation Seva & Volunteer Insights',
        category: 'Community',
        author: 'Admin User',
        status: 'Draft',
        publishedDate: '—',
        updatedDate: '2024-07-22',
        isFeatured: false,
      ),
      ArticleModel(
        id: 'ART-008',
        title: 'Historical Timeline of Sacred Himalayan Ashrams',
        category: 'History',
        author: 'Manning D.',
        status: 'Published',
        publishedDate: '2024-08-02',
        updatedDate: '2024-08-10',
        isFeatured: true,
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

  List<String> get _categories => ['All', 'Vedic Studies', 'Meditation', 'Community', 'History'];
  List<String> get _statuses => ['All', 'Draft', 'Pending Review', 'Published', 'Unpublished'];
  List<String> get _featuredOptions => ['All', 'Featured Only', 'Non-Featured'];
  List<String> get _sortOptions => ['Newest', 'Title (A-Z)', 'Status', 'Category'];

  List<ArticleModel> get _filteredArticles {
    if (_isEmptyStateSimulated) return [];

    final filtered = _articles.where((article) {
      final matchesSearch = article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatus == 'All' || article.status == _selectedStatus;
      final matchesCategory = _selectedCategory == 'All' || article.category == _selectedCategory;
      final matchesFeatured = _selectedFeatured == 'All' ||
          (_selectedFeatured == 'Featured Only' && article.isFeatured) ||
          (_selectedFeatured == 'Non-Featured' && !article.isFeatured);

      return matchesSearch && matchesStatus && matchesCategory && matchesFeatured;
    }).toList();

    if (_sortBy == 'Title (A-Z)') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Status') {
      filtered.sort((a, b) => a.status.compareTo(b.status));
    } else if (_sortBy == 'Category') {
      filtered.sort((a, b) => a.category.compareTo(b.category));
    } else {
      filtered.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));
    }

    return filtered;
  }

  List<ArticleModel> get _paginatedArticles {
    final filtered = _filteredArticles;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    if (startIndex >= filtered.length) return [];

    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }

  int get _totalPages {
    final count = _filteredArticles.length;
    if (count == 0) return 1;
    return (count / _rowsPerPage).ceil();
  }

  StatusType _getStatusType(String status) {
    switch (status) {
      case 'Published':
        return StatusType.success;
      case 'Draft':
        return StatusType.warning;
      case 'Pending Review':
      case 'Review':
        return StatusType.info;
      case 'Unpublished':
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

  void _onCategoryFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedCategory = newValue;
        _currentPage = 1;
      });
    }
  }

  void _togglePublish(ArticleModel article) {
    setState(() {
      if (article.status == 'Published') {
        article.status = 'Unpublished';
        UIUtils.showSuccessMessage(context, '"${article.title}" has been unpublished.');
      } else {
        article.status = 'Published';
        UIUtils.showSuccessMessage(context, '"${article.title}" is now published.');
      }
    });
  }

  void _toggleFeatured(ArticleModel article) {
    setState(() {
      article.isFeatured = !article.isFeatured;
      UIUtils.showSuccessMessage(
        context,
        article.isFeatured
            ? 'Marked "${article.title}" as Featured.'
            : 'Removed Featured status from "${article.title}".',
      );
    });
  }

  void _showViewDetailsDialog(ArticleModel article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(
                article.title,
                style: TextStyle(fontSize: context.responsive<double>(mobile: 16, tablet: 18, desktop: 20), fontWeight: FontWeight.bold),
              ),
            ),
            if (article.isFeatured)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Tooltip(
                  message: 'Featured Article',
                  child: Icon(Icons.star, color: Colors.amber, size: context.responsive<double>(mobile: 20, tablet: 22, desktop: 24)),
                ),
              ),
          ],
        ),
        content: SizedBox(
          width: context.responsive<double>(mobile: double.maxFinite, tablet: 500, desktop: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailRow('Article ID', article.id),
              _buildDetailRow('Category', article.category),
              _buildDetailRow('Author', article.author),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 120, child: Text('Status:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                  StatusBadge(label: article.status, type: _getStatusType(article.status)),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Published Date', article.publishedDate),
              _buildDetailRow('Last Updated', article.updatedDate),
              const SizedBox(height: 16),
              const Text(
                'Article Preview:',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Vedic philosophy represents one of humanity\'s oldest systematic explorations of consciousness, cosmic order, and ethical living. This manuscript explores foundational citations and traditional interpretations.',
                  style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textBody),
                ),
              ),
            ],
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
              Navigator.pushNamed(context, '${AppRouter.articlesEdit}/${article.id}');
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Article'),
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
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ArticleModel article) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirm Deletion',
        icon: Icons.warning_amber_rounded,
        confirmColor: AppColors.error,
        confirmLabel: 'Delete Article',
        onConfirm: () {
          setState(() {
            _articles.removeWhere((item) => item.id == article.id);
            if (_filteredArticles.isEmpty && _currentPage > 1) {
              _currentPage--;
            }
          });
          Navigator.pop(context);
          UIUtils.showSuccessMessage(context, 'Article "${article.title}" has been permanently deleted.');
        },
        content: Text.rich(
          TextSpan(
            text: 'Are you sure you want to delete ',
            style: const TextStyle(color: AppColors.textBody),
            children: [
              TextSpan(
                text: '"${article.title}"',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const TextSpan(text: '? This action cannot be undone.'),
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
      _selectedCategory = 'All';
      _selectedFeatured = 'All';
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
          _buildTopSimulationRow(),
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

  Widget _buildTopSimulationRow() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'State Simulators:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isEmptyStateSimulated = !_isEmptyStateSimulated;
                _hasError = false;
              });
            },
            icon: Icon(_isEmptyStateSimulated ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Simulate Empty', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _hasError = !_hasError;
                _isEmptyStateSimulated = false;
              });
            },
            icon: Icon(_hasError ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Simulate Error', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _simulateLoading,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text('Simulate Loading', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _resetMockData();
                _clearFilters();
              });
            },
            icon: const Icon(Icons.restore, size: 14),
            label: const Text('Reset Dataset', style: TextStyle(fontSize: 11)),
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Articles & Content Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage publishing lifecycle, editorial reviews, categories, and featured articles.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.articlesCreate)) ...[
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.articlesCreate),
            icon: Icons.add,
            label: 'Create Article',
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
            hintText: 'Search by title, author, or ID...',
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
                label: 'Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: _onCategoryFilterChanged,
                itemLabel: (val) => val,
              ),
              FilterDropdown<String>(
                label: 'Featured',
                value: _selectedFeatured,
                items: _featuredOptions,
                onChanged: (val) => setState(() => _selectedFeatured = val!),
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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: 'Search by article title, author, or ID...',
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
                label: 'Category',
                value: _selectedCategory,
                items: _categories,
                onChanged: _onCategoryFilterChanged,
                itemLabel: (val) => val,
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              flex: 2,
              child: FilterDropdown<String>(
                label: 'Featured',
                value: _selectedFeatured,
                items: _featuredOptions,
                onChanged: (val) => setState(() => _selectedFeatured = val!),
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
            if (_searchQuery.isNotEmpty || _selectedStatus != 'All' || _selectedCategory != 'All' || _selectedFeatured != 'All' || _sortBy != 'Newest') ...[
              const SizedBox(width: AppSizes.s12),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off, size: 16),
                label: const Text('Reset'),
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildMainContentState() {
    if (_isLoading) {
      return const LoadingState(message: 'Retrieving Articles...');
    }
    if (_hasError) {
      return ErrorState(
        message: 'Failed to load foundation articles. Please try again.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredArticles.isEmpty) {
      return EmptyState(
        title: 'No Articles Found',
        message: 'No articles correspond to your current search query or filter criteria.',
        icon: Icons.article_outlined,
        onAction: _clearFilters,
        actionLabel: 'Reset Filters',
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileListLayout(),
      desktop: _buildDesktopTableLayout(),
    );
  }

  Widget _buildDesktopTableLayout() {
    final list = _paginatedArticles;

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
                      minWidth: context.screenWidth - AppSizes.sidebarWidth - 48,
                    ),
                    child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.background),
                    horizontalMargin: 24,
                    columnSpacing: 24,
                    columns: const [
                      DataColumn(label: Text('Article Title', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Author', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Published Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Updated Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Featured', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: list.map((article) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 240,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                article.title,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          DataCell(Text(article.category)),
                          DataCell(Text(article.author)),
                          DataCell(StatusBadge(label: article.status, type: _getStatusType(article.status))),
                          DataCell(Text(article.publishedDate)),
                          DataCell(Text(article.updatedDate)),
                          DataCell(
                            PermissionService.hasPermission(AppPermissions.articlesEdit)
                                ? IconButton(
                                    icon: Icon(
                                      article.isFeatured ? Icons.star : Icons.star_border,
                                      color: article.isFeatured ? Colors.amber : AppColors.textDisabled,
                                    ),
                                    tooltip: article.isFeatured ? 'Featured' : 'Mark Featured',
                                    onPressed: () => _toggleFeatured(article),
                                  )
                                : Icon(
                                    article.isFeatured ? Icons.star : Icons.star_border,
                                    color: article.isFeatured ? Colors.amber : AppColors.textDisabled,
                                    size: 20,
                                  ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.info),
                                  tooltip: 'View Details',
                                  onPressed: () => _showViewDetailsDialog(article),
                                ),
                                if (PermissionService.hasPermission(AppPermissions.articlesEdit))
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                    tooltip: 'Edit Article',
                                    onPressed: () => Navigator.pushNamed(context, '${AppRouter.articlesEdit}/${article.id}'),
                                  ),
                                if (PermissionService.hasPermission(AppPermissions.articlesPublish))
                                  IconButton(
                                    icon: Icon(
                                      article.status == 'Published' ? Icons.cloud_off_outlined : Icons.cloud_upload_outlined,
                                      size: 18,
                                      color: article.status == 'Published' ? AppColors.warning : AppColors.success,
                                    ),
                                    tooltip: article.status == 'Published' ? 'Unpublish' : 'Publish',
                                    onPressed: () => _togglePublish(article),
                                  ),
                                if (PermissionService.hasPermission(AppPermissions.articlesDelete))
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                    tooltip: 'Delete Article',
                                    onPressed: () => _showDeleteConfirmation(article),
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

  Widget _buildMobileListLayout() {
    final list = _paginatedArticles;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.only(bottom: 8),
            itemBuilder: (context, index) {
              final article = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              article.title,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              article.isFeatured ? Icons.star : Icons.star_border,
                              color: article.isFeatured ? Colors.amber : AppColors.textDisabled,
                              size: 20,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => _toggleFeatured(article),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('By ${article.author}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(article.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Published: ${article.publishedDate}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const SizedBox(height: 2),
                              Text('Updated: ${article.updatedDate}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                          StatusBadge(label: article.status, type: _getStatusType(article.status)),
                        ],
                      ),
                      const Divider(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showViewDetailsDialog(article),
                              icon: const Icon(Icons.visibility_outlined, size: 14),
                              label: const Text('View', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: Size.zero),
                            ),
                            if (PermissionService.hasPermission(AppPermissions.articlesEdit))
                              TextButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '${AppRouter.articlesEdit}/${article.id}'),
                                icon: const Icon(Icons.edit_outlined, size: 14),
                                label: const Text('Edit', style: TextStyle(fontSize: 12)),
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: Size.zero),
                              ),
                            if (PermissionService.hasPermission(AppPermissions.articlesPublish))
                              TextButton.icon(
                                onPressed: () => _togglePublish(article),
                                icon: Icon(article.status == 'Published' ? Icons.cloud_off_outlined : Icons.cloud_upload_outlined, size: 14),
                                label: Text(article.status == 'Published' ? 'Unpub' : 'Pub', style: const TextStyle(fontSize: 12)),
                                style: TextButton.styleFrom(
                                  foregroundColor: article.status == 'Published' ? AppColors.warning : AppColors.success,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  minimumSize: Size.zero,
                                ),
                              ),
                            if (PermissionService.hasPermission(AppPermissions.articlesDelete))
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                constraints: const BoxConstraints(),
                                onPressed: () => _showDeleteConfirmation(article),
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
      totalItems: _filteredArticles.length,
      itemsPerPage: _rowsPerPage,
      onPrevious: () => setState(() => _currentPage--),
      onNext: () => setState(() => _currentPage++),
      itemLabel: 'articles',
    );
  }
}
