import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/buttons.dart';
import 'package:chaturvyuha_foundation/staff/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class SEOView extends StatefulWidget {
  const SEOView({super.key});

  @override
  State<SEOView> createState() => _SEOViewState();
}

class _SEOViewState extends State<SEOView> {
  final _siteTitleController = TextEditingController(text: 'Chaturvyuha Foundation');
  final _siteDescController = TextEditingController(text: 'Promoting Vedic wisdom, cultural heritage, and spiritual education through ancient Sanskriti.');
  final _keywordsController = TextEditingController(text: 'vedic, yoga, sanskrit, heritage, spirituality, foundation');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.s32),
          _buildGlobalSettings(),
          const SizedBox(height: AppSizes.s32),
          _buildContentSEOTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SEO & Meta Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        SizedBox(height: 4),
        Text('Optimize website visibility, manage metadata, and search indexing settings.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
      ],
    );
  }

  Widget _buildGlobalSettings() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Global Meta Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildField('Site Title Tag', _siteTitleController),
            const SizedBox(height: 16),
            _buildField('Meta Description', _siteDescController, maxLines: 3),
            const SizedBox(height: 16),
            _buildField('Global Keywords (comma separated)', _keywordsController),
            const SizedBox(height: 24),
            Row(
              children: [
                PrimaryButton(onPressed: () {}, label: 'Save SEO Settings'),
                const SizedBox(width: 16),
                SecondaryButton(onPressed: () {}, label: 'Generate Sitemap', foregroundColor: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSEOTable() {
    final List<Map<String, dynamic>> items = [
      {'page': 'Home Page', 'score': 95, 'status': 'Excellent'},
      {'page': 'Vedic Studies 101', 'score': 82, 'status': 'Good'},
      {'page': 'Yoga Workshop', 'score': 45, 'status': 'Needs Improvement'},
      {'page': 'About Foundation', 'score': 78, 'status': 'Good'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Content SEO Health', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            side: const BorderSide(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(AppColors.background),
            columns: const [
              DataColumn(label: Text('Page/Article Name', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('SEO Score', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Last Audited', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: items.map((item) => DataRow(cells: [
              DataCell(Text(item['page'], style: const TextStyle(fontWeight: FontWeight.w600))),
              DataCell(Text('${item['score']}/100')),
              DataCell(StatusBadge(
                label: item['status'],
                type: item['score'] > 90 ? StatusType.success : (item['score'] > 70 ? StatusType.info : StatusType.warning),
              )),
              DataCell(const Text('2 days ago')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Optimize'))),
            ])).toList(),
          ),
        ),
      ],
    );
  }
}
