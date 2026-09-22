import 'package:cfoundation/core/auth/permission_service.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/routing/app_router.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class ContentEntry {
  final String id;
  final String title;
  final String type;
  final String status;
  final String updated;
  final String updatedBy;
  final IconData icon;
  final Color iconColor;

  const ContentEntry({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.updated,
    required this.updatedBy,
    required this.icon,
    required this.iconColor,
  });
}

class ContentInventoryView extends StatefulWidget {
  const ContentInventoryView({super.key});

  @override
  State<ContentInventoryView> createState() => _ContentInventoryViewState();
}

class _ContentInventoryViewState extends State<ContentInventoryView> {
  final _searchController = TextEditingController();
  String _selectedType = 'Any';
  String _selectedStatus = 'All statuses';
  String _query = '';
  int _currentPage = 1;
  final int _pageSize = 8;

  final List<ContentEntry> _entries = const [
    ContentEntry(id: 'CNT-001', title: 'Building a National Heritage Content Strategy', type: 'Article', status: 'Published', updated: '2m ago', updatedBy: 'Aisha R.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-002', title: 'Designing Trustworthy Community Stories for Digital Audiences', type: 'Article', status: 'Published', updated: '9m ago', updatedBy: 'Liam N.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-003', title: 'The Future of Civic Media: Editorial Planning for 2026', type: 'Article', status: 'Published', updated: '31m ago', updatedBy: 'Meera S.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-004', title: 'Leadership Interview: Building Public Confidence Through Video', type: 'Video', status: 'Published', updated: '1h ago', updatedBy: 'Jayan P.', icon: Icons.videocam_outlined, iconColor: Color(0xFF4F46E5)),
    ContentEntry(id: 'CNT-005', title: 'Volunteer Impact Report: Stories from the Ground', type: 'Article', status: 'Published', updated: '2h ago', updatedBy: 'Aisha R.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-006', title: 'Foundation Gallery: Celebrating Culture Through Visual Narratives', type: 'Gallery', status: 'Published', updated: '3h ago', updatedBy: 'Nina K.', icon: Icons.photo_library_outlined, iconColor: Color(0xFFF59E0B)),
    ContentEntry(id: 'CNT-007', title: 'Program Launch: Access and Inclusion Spotlight', type: 'Product', status: 'Published', updated: '4h ago', updatedBy: 'Marcus T.', icon: Icons.rocket_launch_outlined, iconColor: Color(0xFFEC4899)),
    ContentEntry(id: 'CNT-008', title: 'Operational Notes: Best Practices for Community Updates', type: 'Article', status: 'Published', updated: '5h ago', updatedBy: 'Leah M.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-009', title: 'Town Hall Event Recap: A Conversation on Regional Growth', type: 'Event', status: 'Published', updated: '6h ago', updatedBy: 'Jayan P.', icon: Icons.event_outlined, iconColor: Color(0xFFEF4444)),
    ContentEntry(id: 'CNT-010', title: 'Annual Report Overview: Impact, Reach, and Accountability', type: 'Article', status: 'Draft', updated: '7h ago', updatedBy: 'Rohit D.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-011', title: 'Thought Leadership: Public Trust in Institutions', type: 'Article', status: 'Draft', updated: 'Yesterday', updatedBy: 'Aisha R.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-012', title: 'Multimedia Campaign Brief: Better Health Through Awareness', type: 'Article', status: 'Published', updated: 'Yesterday', updatedBy: 'Meera S.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
    ContentEntry(id: 'CNT-013', title: 'Watch: Impact Stories from the Field', type: 'Video', status: 'Published', updated: '2d ago', updatedBy: 'Liam N.', icon: Icons.videocam_outlined, iconColor: Color(0xFF4F46E5)),
    ContentEntry(id: 'CNT-014', title: 'Photo Essay: Everyday Leadership in Action', type: 'Gallery', status: 'Published', updated: '2d ago', updatedBy: 'Nina K.', icon: Icons.photo_library_outlined, iconColor: Color(0xFFF59E0B)),
    ContentEntry(id: 'CNT-015', title: 'Member Spotlight: Empowering Local Innovators', type: 'Product', status: 'Published', updated: '3d ago', updatedBy: 'Marcus T.', icon: Icons.rocket_launch_outlined, iconColor: Color(0xFFEC4899)),
    ContentEntry(id: 'CNT-016', title: 'Knowledge Base: Community Education Essentials', type: 'Article', status: 'Published', updated: '4d ago', updatedBy: 'Leah M.', icon: Icons.article_outlined, iconColor: Color(0xFF2E7D32)),
  ];

  List<String> get _types => ['Any', 'Article', 'Video', 'Gallery', 'Product', 'Event'];
  List<String> get _statuses => ['All statuses', 'Published', 'Draft'];

  List<ContentEntry> get _filteredEntries {
    final query = _query.toLowerCase().trim();
    return _entries.where((entry) {
      final matchesQuery = query.isEmpty || entry.title.toLowerCase().contains(query) || entry.updatedBy.toLowerCase().contains(query);
      final matchesType = _selectedType == 'Any' || entry.type == _selectedType;
      final matchesStatus = _selectedStatus == 'All statuses' || entry.status == _selectedStatus;
      return matchesQuery && matchesType && matchesStatus;
    }).toList();
  }

  List<ContentEntry> get _visibleEntries {
    final start = (_currentPage - 1) * _pageSize;
    final entries = _filteredEntries;
    if (start >= entries.length) return const [];
    final end = (start + _pageSize).clamp(0, entries.length);
    return entries.sublist(start, end);
  }

  int get _totalPages => (_filteredEntries.length / _pageSize).ceil().clamp(1, 999);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openEntry(ContentEntry entry) {
    if (entry.type == 'Article' && PermissionService.hasPermission(AppPermissions.articlesEdit)) {
      Navigator.pushNamed(context, '${AppRouter.articlesEdit}/${entry.id}');
      return;
    }
    UIUtils.showSuccessMessage(context, 'Opening ${entry.type.toLowerCase()} details for "${entry.title}".');
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 24),
            _buildSummaryRow(),
            const SizedBox(height: 20),
            _buildFilterBar(isMobile),
            const SizedBox(height: 18),
            SizedBox(
              height: isMobile ? 440 : 520,
              child: isMobile ? _buildMobileList() : _buildDesktopTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final addButton = FilledButton.icon(
      onPressed: PermissionService.hasPermission(AppPermissions.articlesCreate) ? () => Navigator.pushNamed(context, AppRouter.articlesCreate) : null,
      icon: const Icon(Icons.add, size: 18),
      label: const Text('Add content'),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Content library',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: isMobile ? 22 : 30,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${_filteredEntries.length} items managed across editorial, media, and community campaigns.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
        ),
      ],
    );

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMobile) ...[
          _buildViewButton(),
          const SizedBox(width: 10),
        ],
        addButton,
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleColumn,
          const SizedBox(height: 16),
          actions,
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: titleColumn),
          const SizedBox(width: 12),
          actions,
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    final stats = [
      _SummaryCard(title: 'Published', value: '${_entries.where((e) => e.status == 'Published').length}', accent: const Color(0xFF16A34A)),
      _SummaryCard(title: 'Drafts', value: '${_entries.where((e) => e.status == 'Draft').length}', accent: const Color(0xFFEA580C)),
      _SummaryCard(title: 'Media', value: '${_entries.where((e) => e.type == 'Video' || e.type == 'Gallery').length}', accent: const Color(0xFF7C3AED)),
      _SummaryCard(title: 'This week', value: '24', accent: const Color(0xFF0EA5E9)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 1000.0;
        final cardsPerRow = width < 700 ? 2 : 4;
        final gap = 12.0;
        final cardWidth = (width - gap * (cardsPerRow - 1)) / cardsPerRow;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: stats
              .map(
                (card) => SizedBox(
                  width: cardWidth.clamp(140.0, 220.0),
                  child: card,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildViewButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 90, maxWidth: 120),
      child: OutlinedButton.icon(
        onPressed: () => UIUtils.showSuccessMessage(context, 'Table view is active.'),
        icon: const Icon(Icons.bookmark_border, size: 18),
        label: const Text('View'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.inputBorder),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterBar(bool isMobile) {
    final search = TextField(
      controller: _searchController,
      onChanged: (value) => setState(() { _query = value; _currentPage = 1; }),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search, size: 20),
        hintText: 'Type to search for entries',
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );

    final filters = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: _buildDropdown('Content type', _selectedType, _types, (value) => setState(() { _selectedType = value; _currentPage = 1; })),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: _buildDropdown('Status', _selectedStatus, _statuses, (value) => setState(() { _selectedStatus = value; _currentPage = 1; })),
        ),
        if (_query.isNotEmpty || _selectedType != 'Any' || _selectedStatus != 'All statuses')
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _query = '';
                _selectedType = 'Any';
                _selectedStatus = 'All statuses';
                _currentPage = 1;
              });
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Reset'),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isMobile || constraints.maxWidth < 500) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  search,
                  const SizedBox(height: 12),
                  filters,
                ],
              ),
            );
          }

          return Row(
            children: [
              Expanded(child: search),
              const SizedBox(width: 12),
              Flexible(child: filters),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> values, ValueChanged<String> onChanged) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.inputBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          alignment: AlignmentDirectional.centerStart,
          items: values
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                SizedBox(width: 38, child: _HeaderText('')),
                Expanded(flex: 4, child: _HeaderText('Name')),
                Expanded(flex: 2, child: _HeaderText('Status')),
                Expanded(flex: 2, child: _HeaderText('Type')),
                Expanded(flex: 2, child: _HeaderText('Updated')),
                Expanded(flex: 2, child: _HeaderText('Updated by')),
                SizedBox(width: 38),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              itemCount: _visibleEntries.length,
              separatorBuilder: (_, index) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final entry = _visibleEntries[index];
                return InkWell(
                  onTap: () => _openEntry(entry),
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 38, child: _SelectionBox()),
                        Expanded(flex: 4, child: Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: StatusBadge(label: entry.status, type: entry.status == 'Published' ? StatusType.success : StatusType.warning))),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Icon(entry.icon, size: 17, color: entry.iconColor),
                              const SizedBox(width: 6),
                              Flexible(child: Text(entry.type, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Text(entry.updated)),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: entry.updatedBy == 'Marcus T.' || entry.updatedBy == 'Aisha R.' ? const Color(0xFF8B5CF6) : const Color(0xFFD7DFDE),
                                child: Text(
                                  entry.updatedBy.substring(0, 1),
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(child: Text(entry.updatedBy, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 38,
                          child: PopupMenuButton<String>(
                            tooltip: 'More actions',
                            onSelected: (action) {
                              if (action == 'open') {
                                _openEntry(entry);
                              } else {
                                UIUtils.showSuccessMessage(context, '$action selected for "${entry.title}".');
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'open', child: Text('Open')),
                              PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                              PopupMenuItem(value: 'archive', child: Text('Archive')),
                            ],
                            child: const Icon(Icons.more_horiz, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: [
        Flexible(
          child: ListView.separated(
            itemCount: _visibleEntries.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final entry = _visibleEntries[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9), side: const BorderSide(color: AppColors.border)),
                child: InkWell(
                  onTap: () => _openEntry(entry),
                  borderRadius: BorderRadius.circular(9),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (_) => _openEntry(entry),
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'open', child: Text('Open')),
                                PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            StatusBadge(label: entry.status, type: entry.status == 'Published' ? StatusType.success : StatusType.warning),
                            const SizedBox(width: 12),
                            Icon(entry.icon, size: 16, color: entry.iconColor),
                            const SizedBox(width: 5),
                            Text(entry.type, style: const TextStyle(color: AppColors.textSecondary)),
                            const Spacer(),
                            Text(entry.updated, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('Updated by ${entry.updatedBy}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildPagination() {
    final start = _filteredEntries.isEmpty ? 0 : ((_currentPage - 1) * _pageSize) + 1;
    final end = ((_currentPage - 1) * _pageSize) + _visibleEntries.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$start-$end of ${_filteredEntries.length}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Row(
            children: [
              IconButton(
                tooltip: 'Previous page',
                onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('$_currentPage / $_totalPages', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              IconButton(
                tooltip: 'Next page',
                onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
      );
}

class _SelectionBox extends StatelessWidget {
  const _SelectionBox();

  @override
  Widget build(BuildContext context) => Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.inputBorder, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
      );
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 44,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}