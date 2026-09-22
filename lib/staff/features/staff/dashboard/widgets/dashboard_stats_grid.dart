import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/responsive_grid.dart';
import 'package:flutter/material.dart';

class StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? route;

  const StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.route,
  });
}

class DashboardStatsGrid extends StatelessWidget {
  final List<StatItem> stats;

  const DashboardStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGrid(
      desktopCrossAxisCount: 4,
      tabletCrossAxisCount: 2,
      mobileCrossAxisCount: 1,
      children: stats.map((stat) => _buildStatCard(context, stat)).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, StatItem stat) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: stat.route == null
            ? null
            : () => Navigator.pushNamed(context, stat.route!),
        mouseCursor: stat.route == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        hoverColor: stat.color.withOpacity(0.06),
        splashColor: stat.color.withOpacity(0.12),
        child: Padding(
          padding: EdgeInsets.all(
            context.responsive<double>(
              mobile: AppSizes.s12,
              tablet: AppSizes.s16,
              desktop: AppSizes.s24,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  context.responsive<double>(
                    mobile: AppSizes.s8,
                    tablet: AppSizes.s10,
                    desktop: AppSizes.s12,
                  ),
                ),
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: context.responsive<double>(
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
              ),
              SizedBox(
                width: context.responsive<double>(
                  mobile: AppSizes.s12,
                  tablet: AppSizes.s14,
                  desktop: AppSizes.s16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.title,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: context.responsive<double>(
                          mobile: 11,
                          tablet: 12,
                          desktop: 13,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        stat.value,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: context.responsive<double>(
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
