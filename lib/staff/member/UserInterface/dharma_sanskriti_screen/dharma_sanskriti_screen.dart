import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_text_styles.dart';
import '../../dataProvider/foundation_provider.dart';

class DharmaSanskritiScreen extends StatefulWidget {
  const DharmaSanskritiScreen({super.key});

  @override
  State<DharmaSanskritiScreen> createState() => _DharmaSanskritiScreenState();
}

class _DharmaSanskritiScreenState extends State<DharmaSanskritiScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Philosophy',
    'Language',
    'Culture',
    'Values',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoundationProvider>();
    final filteredContents = _selectedCategory == 'All'
        ? provider.dharmaContents
        : provider.dharmaContents
              .where((item) => item['category'] == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 56 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title / Header label
                        Text(
                          'DHARMA & SANSKRITI',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Preserving Heritage & Indigenous Values',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Explore traditional understandings of righteous living, linguistic structures, and cultural timelines curated to anchor communal values.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        // Working Category Filter Chips
                        Text('FILTER TOPICS', style: AppTextStyles.bulletLabel),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _categories.map((category) {
                            final bool isSelected =
                                _selectedCategory == category;
                            return ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val)
                                  setState(() => _selectedCategory = category);
                              },
                              selectedColor: AppColor.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),

                        // Dynamic Contents Grid/List
                        Text(
                          'EDUCATIONAL KNOWLEDGE',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, boxConstraints) {
                            final cardWidth = isDesktop
                                ? (boxConstraints.maxWidth - 24) / 2
                                : boxConstraints.maxWidth;
                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: filteredContents.map((item) {
                                return Container(
                                  width: cardWidth,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColor.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColor.primary.withAlpha(30),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF0DC),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          item['category']!.toUpperCase(),
                                          style: AppTextStyles.bulletLabel
                                              .copyWith(fontSize: 10),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        item['title']!,
                                        style: AppTextStyles.title,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        item['content']!,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 48),

                        // Festivals and Cultural Calendar section
                        Text(
                          'FESTIVALS & CULTURAL CALENDAR',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sacred Celebrations',
                          style: AppTextStyles.title.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: provider.culturalCalendar.map((cal) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              color: AppColor.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: AppColor.primary.withAlpha(20),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  cal['event']!,
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    cal['significance']!,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0DC),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    cal['date']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 48),

                        // Sanskar / Traditional Practices Explanatory card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0DC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor.primary.withAlpha(40),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel(
                                'SANSKAR / LIFECYCLE PRACTICES',
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'The 16 Traditional Transitions (Sanskars)',
                                style: AppTextStyles.title,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Sacred milestone transitions are structured to elevate personal consciousness at crucial physical stages of development, from childhood education stages through to legacy building frameworks.',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: AppTextStyles.sectionLabel);
  }
}
