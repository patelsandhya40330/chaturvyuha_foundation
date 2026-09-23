import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/models/analytics_data_model.dart';
import 'package:chaturvyuha_foundation/staff/features/staff/dashboard/widgets/dashboard_section.dart';
import 'package:flutter/material.dart';

class ContentStatusBarChart extends StatefulWidget {
  const ContentStatusBarChart({super.key});

  @override
  State<ContentStatusBarChart> createState() => _ContentStatusBarChartState();
}

class _ContentStatusBarChartState extends State<ContentStatusBarChart> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final statusItems = AnalyticsRepository.getContentStatusData();

    return DashboardSection(
      title: 'Content Status',
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(mobile: AppSizes.s12, tablet: AppSizes.s16, desktop: AppSizes.s24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.responsive<double>(mobile: 180, tablet: 200, desktop: 220),
              width: double.infinity,
              child: MouseRegion(
                onHover: (event) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPos = box.globalToLocal(event.position);
                  final chartWidth = box.size.width;
                  if (statusItems.isNotEmpty && chartWidth > 0) {
                    final double itemWidth = chartWidth / statusItems.length;
                    final int idx = (localPos.dx / itemWidth).floor().clamp(0, statusItems.length - 1);
                    if (_hoveredIndex != idx) {
                      setState(() => _hoveredIndex = idx);
                    }
                  }
                },
                onExit: (_) {
                  if (_hoveredIndex != null) {
                    setState(() => _hoveredIndex = null);
                  }
                },
                child: CustomPaint(
                  painter: _BarChartPainter(
                    items: statusItems,
                    hoveredIndex: _hoveredIndex,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.s12),
            _buildSummaryLegend(statusItems),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryLegend(List<ContentStatusItem> items) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              '${item.category}: ',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            Text(
              '${item.count}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<ContentStatusItem> items;
  final int? hoveredIndex;

  _BarChartPainter({
    required this.items,
    required this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    const double paddingTop = 24.0;
    const double paddingBottom = 32.0;
    const double paddingLeft = 16.0;
    const double paddingRight = 16.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    int maxCount = 100;
    for (var item in items) {
      if (item.count > maxCount) maxCount = item.count;
    }

    final Paint gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw background reference grid lines
    const int rows = 3;
    for (int i = 0; i <= rows; i++) {
      final double y = paddingTop + chartHeight - (i * (chartHeight / rows));
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width - paddingRight, y), gridPaint);
    }

    final double groupWidth = chartWidth / items.length;
    final double barWidth = (groupWidth * 0.45).clamp(16.0, 36.0);

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final bool isHovered = hoveredIndex == i;

      final double centerX = paddingLeft + (i * groupWidth) + (groupWidth / 2);
      final double barHeight = (item.count / maxCount) * chartHeight;
      final double barTop = paddingTop + chartHeight - barHeight;

      final Rect barRect = Rect.fromLTWH(
        centerX - (barWidth / 2),
        barTop,
        barWidth,
        barHeight,
      );

      final RRect roundedBar = RRect.fromRectAndRadius(
        barRect,
        const Radius.circular(4),
      );

      final Paint barPaint = Paint()
        ..color = isHovered ? item.color : item.color.withOpacity(0.85)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(roundedBar, barPaint);

      // Value label on top of bar
      final TextPainter valTp = TextPainter(
        text: TextSpan(
          text: '${item.count}',
          style: TextStyle(
            color: isHovered ? item.color : AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      valTp.paint(canvas, Offset(centerX - (valTp.width / 2), barTop - valTp.height - 4));

      // Category label below bar
      final String shortLabel = item.category == 'Pending Review' ? 'Review' : item.category;
      final TextPainter catTp = TextPainter(
        text: TextSpan(
          text: shortLabel,
          style: TextStyle(
            color: isHovered ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 10,
            fontWeight: isHovered ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      catTp.paint(canvas, Offset(centerX - (catTp.width / 2), size.height - paddingBottom + 8));
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.hoveredIndex != hoveredIndex;
  }
}
