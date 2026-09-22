import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class PaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String itemLabel;

  const PaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPrevious,
    required this.onNext,
    this.itemLabel = 'items',
  });

  @override
  Widget build(BuildContext context) {
    final startIndex = totalItems == 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
    final endIndex = (currentPage * itemsPerPage) > totalItems ? totalItems : (currentPage * itemsPerPage);
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.all(context.responsive<double>(mobile: 12, tablet: 16, desktop: 20)),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  'Showing $startIndex to $endIndex of $totalItems $itemLabel',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 20),
                      onPressed: currentPage > 1 ? onPrevious : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 20),
                      onPressed: currentPage < totalPages ? onNext : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing $startIndex to $endIndex of $totalItems $itemLabel',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 1 ? onPrevious : null,
                    ),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages ? onNext : null,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class Breadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const Breadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final idx = entry.key;
        final item = entry.value;
        final isLast = idx == items.length - 1;

        return Row(
          children: [
            if (idx > 0)
              const Icon(Icons.chevron_right, size: 16, color: AppColors.textDisabled),
            InkWell(
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isLast ? AppColors.textPrimary : AppColors.primary,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  BreadcrumbItem({required this.label, this.onTap});
}
