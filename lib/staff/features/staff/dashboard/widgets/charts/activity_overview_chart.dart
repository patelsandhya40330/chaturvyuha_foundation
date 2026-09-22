import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/features/staff/dashboard/models/analytics_data_model.dart';
import 'package:cfoundation/features/staff/dashboard/widgets/dashboard_section.dart';
import 'package:flutter/material.dart';

class ActivityOverviewChart extends StatefulWidget {
  const ActivityOverviewChart({super.key});

  @override
  State<ActivityOverviewChart> createState() => _ActivityOverviewChartState();
}

class _ActivityOverviewChartState extends State<ActivityOverviewChart> {
  String _selectedTimeFilter = 'Last 6 Months';
  String _selectedMetricFilter = 'All Metrics';
  int? _hoveredIndex;

  final List<String> _timeFilters = ['Last 7 Days', 'Last 30 Days', 'Last 6 Months', 'This Year'];
  final List<String> _metricFilters = [
    'All Metrics',
    'Articles Published',
    'Events',
    'Programs',
    'Announcements',
  ];

  static const Map<String, Color> _metricColors = {
    'Articles Published': AppColors.primary,
    'Events': AppColors.secondary,
    'Programs': AppColors.info,
    'Announcements': AppColors.accent,
  };

  @override
  Widget build(BuildContext context) {
    final dataPoints = AnalyticsRepository.getActivityOverviewData(_selectedTimeFilter);
    final bool isMobile = context.isMobile;

    return DashboardSection(
      title: 'Activity Overview',
      actions: [
        if (!isMobile) _buildControlsRow(),
      ],
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(mobile: AppSizes.s12, tablet: AppSizes.s16, desktop: AppSizes.s24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              _buildControlsRow(),
              const SizedBox(height: AppSizes.s16),
            ],

            // Canvas Chart Container
            SizedBox(
              height: context.responsive<double>(mobile: 180, tablet: 200, desktop: 220),
              width: double.infinity,
              child: MouseRegion(
                onHover: (event) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPos = box.globalToLocal(event.position);
                  final chartWidth = box.size.width - 60; // Padding for Y-axis
                  if (dataPoints.isNotEmpty && chartWidth > 0) {
                    final double step = chartWidth / (dataPoints.length - 1);
                    final int idx = ((localPos.dx - 40) / step).round().clamp(0, dataPoints.length - 1);
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
                  painter: _LineChartPainter(
                    dataPoints: dataPoints,
                    selectedMetric: _selectedMetricFilter,
                    hoveredIndex: _hoveredIndex,
                    metricColors: _metricColors,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.s16),

            // Legend Row
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              value: _selectedMetricFilter,
              isDense: true,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              items: _metricFilters
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedMetricFilter = val!),
            ),
          ),
        ),
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              value: _selectedTimeFilter,
              isDense: true,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              items: _timeFilters
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedTimeFilter = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    final displayMetrics = _selectedMetricFilter == 'All Metrics'
        ? _metricColors.keys.toList()
        : [_selectedMetricFilter];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: displayMetrics.map((metric) {
        final color = _metricColors[metric] ?? AppColors.primary;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              metric,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ActivityDataPoint> dataPoints;
  final String selectedMetric;
  final int? hoveredIndex;
  final Map<String, Color> metricColors;

  _LineChartPainter({
    required this.dataPoints,
    required this.selectedMetric,
    required this.hoveredIndex,
    required this.metricColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    const double paddingLeft = 40.0;
    const double paddingRight = 16.0;
    const double paddingTop = 20.0;
    const double paddingBottom = 30.0;

    final double chartWidth = size.width - paddingLeft - paddingRight;
    final double chartHeight = size.height - paddingTop - paddingBottom;

    // Find max value
    int maxValue = 10;
    for (var dp in dataPoints) {
      if (selectedMetric == 'All Metrics') {
        maxValue = [maxValue, dp.articles, dp.events, dp.programs, dp.announcements].reduce((a, b) => a > b ? a : b);
      } else {
        maxValue = maxValue > dp.getValueForMetric(selectedMetric) ? maxValue : dp.getValueForMetric(selectedMetric);
      }
    }
    maxValue = ((maxValue / 10).ceil() * 10).clamp(10, 500);

    // Draw grid lines & Y-axis labels
    final Paint gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const int gridRows = 4;
    for (int i = 0; i <= gridRows; i++) {
      final double y = paddingTop + chartHeight - (i * (chartHeight / gridRows));
      final int labelValue = ((maxValue / gridRows) * i).round();

      // Horizontal grid line
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width - paddingRight, y), gridPaint);

      // Y-axis label
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: '$labelValue',
          style: const TextStyle(color: AppColors.textDisabled, fontSize: 10, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(paddingLeft - tp.width - 6, y - tp.height / 2));
    }

    // Draw X-axis labels
    final double stepX = dataPoints.length > 1 ? chartWidth / (dataPoints.length - 1) : chartWidth;
    for (int i = 0; i < dataPoints.length; i++) {
      final double x = paddingLeft + (i * stepX);

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: dataPoints[i].label,
          style: TextStyle(
            color: hoveredIndex == i ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: hoveredIndex == i ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - paddingBottom + 8));
    }

    // Determine metrics to draw
    final metricsToDraw = selectedMetric == 'All Metrics'
        ? metricColors.keys.toList()
        : [selectedMetric];

    // Draw lines & data dots for each metric
    for (var metric in metricsToDraw) {
      final color = metricColors[metric] ?? AppColors.primary;

      final Paint linePaint = Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final Path path = Path();
      final List<Offset> points = [];

      for (int i = 0; i < dataPoints.length; i++) {
        final double x = paddingLeft + (i * stepX);
        final int val = dataPoints[i].getValueForMetric(metric);
        final double y = paddingTop + chartHeight - ((val / maxValue) * chartHeight);
        final Offset pt = Offset(x, y);

        points.add(pt);
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }

      canvas.drawPath(path, linePaint);

      // Draw dots
      final Paint dotPaint = Paint()..color = color;
      final Paint whiteDotPaint = Paint()..color = Colors.white;

      for (int i = 0; i < points.length; i++) {
        final pt = points[i];
        final bool isHovered = hoveredIndex == i;

        canvas.drawCircle(pt, isHovered ? 6.0 : 4.0, dotPaint);
        canvas.drawCircle(pt, isHovered ? 3.0 : 2.0, whiteDotPaint);
      }
    }

    // Draw Tooltip Box on hover
    if (hoveredIndex != null && hoveredIndex! < dataPoints.length) {
      final int i = hoveredIndex!;
      final double hoverX = paddingLeft + (i * stepX);
      final dp = dataPoints[i];

      // Vertical indicator line
      final Paint verticalLinePaint = Paint()
        ..color = AppColors.primary.withOpacity(0.3)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(hoverX, paddingTop), Offset(hoverX, paddingTop + chartHeight), verticalLinePaint);

      // Format Tooltip Text
      String tooltipText = '${dp.label}\n';
      if (selectedMetric == 'All Metrics') {
        tooltipText += 'Articles: ${dp.articles}\nEvents: ${dp.events}\nPrograms: ${dp.programs}\nAnnouncements: ${dp.announcements}';
      } else {
        tooltipText += '$selectedMetric: ${dp.getValueForMetric(selectedMetric)}';
      }

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: tooltipText,
          style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.3, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const double tooltipPadding = 8.0;
      final double rectW = tp.width + (tooltipPadding * 2);
      final double rectH = tp.height + (tooltipPadding * 2);

      double rectX = hoverX - (rectW / 2);
      if (rectX < paddingLeft) rectX = paddingLeft;
      if (rectX + rectW > size.width - paddingRight) rectX = size.width - paddingRight - rectW;

      const double rectY = paddingTop;

      final RRect tooltipRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(rectX, rectY, rectW, rectH),
        const Radius.circular(6),
      );

      final Paint tooltipBgPaint = Paint()..color = AppColors.sidebarBackground;
      canvas.drawRRect(tooltipRRect, tooltipBgPaint);

      tp.paint(canvas, Offset(rectX + tooltipPadding, rectY + tooltipPadding));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints ||
        oldDelegate.selectedMetric != selectedMetric ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
