import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:cfoundation/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCategory {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ReportCategory({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final List<ReportCategory> _categories = [
    ReportCategory(
      title: 'User Engagement',
      description: 'Analytics on page views, session duration, and user retention.',
      icon: Icons.analytics_outlined,
      color: AppColors.primary,
    ),
    ReportCategory(
      title: 'Event Attendance',
      description: 'Detailed breakdown of registrations vs actual attendance.',
      icon: Icons.event_available_outlined,
      color: AppColors.secondary,
    ),
    ReportCategory(
      title: 'Content Performance',
      description: 'Metric reports on most read articles and shared content.',
      icon: Icons.article_outlined,
      color: AppColors.info,
    ),
    ReportCategory(
      title: 'Foundation Growth',
      description: 'Reports on new member signups and community outreach reach.',
      icon: Icons.trending_up_outlined,
      color: AppColors.success,
    ),
  ];

  final List<Map<String, dynamic>> _recentReports = [
    {
      'name': 'Monthly_Analytics_Sept_2024.pdf',
      'type': 'PDF',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'size': '2.4 MB',
      'status': 'Generated',
    },
    {
      'name': 'Event_Registration_Summary.xlsx',
      'type': 'Excel',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'size': '1.1 MB',
      'status': 'Generated',
    },
    {
      'name': 'Annual_Outreach_Impact.pdf',
      'type': 'PDF',
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'size': '5.8 MB',
      'status': 'Archived',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.s32),
          _buildCategoriesGrid(),
          const SizedBox(height: AppSizes.s32),
          _buildRecentReportsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operational Reports',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Generate, schedule and export data insights for the foundation activities.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: context.responsive(mobile: 13, desktop: 14)),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive<int>(mobile: 1, tablet: 2, desktop: 4),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: context.responsive(mobile: 2.5, tablet: 2, desktop: 1.2),
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final cat = _categories[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            side: const BorderSide(color: AppColors.border),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(cat.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    cat.description,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Generated Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('View All History')),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            side: const BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: context.isMobile ? _buildMobileReportsList() : _buildDesktopReportsTable(),
        ),
      ],
    );
  }

  Widget _buildDesktopReportsTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(AppColors.background),
      columns: const [
        DataColumn(label: Text('Report Name', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Generated Date', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Size', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: _recentReports.map((report) {
        return DataRow(cells: [
          DataCell(Text(report['name'], style: const TextStyle(fontWeight: FontWeight.w600))),
          DataCell(Text(report['type'])),
          DataCell(Text(DateFormat('MMM dd, yyyy').format(report['date']))),
          DataCell(Text(report['size'])),
          DataCell(StatusBadge(
            label: report['status'],
            type: report['status'] == 'Generated' ? StatusType.success : StatusType.info,
          )),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.download_outlined, size: 20), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share_outlined, size: 20), onPressed: () {}),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildMobileReportsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentReports.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final report = _recentReports[index];
        return ListTile(
          title: Text(report['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text('${report['type']} • ${report['size']} • ${DateFormat('MMM dd').format(report['date'])}'),
          trailing: IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
        );
      },
    );
  }
}
