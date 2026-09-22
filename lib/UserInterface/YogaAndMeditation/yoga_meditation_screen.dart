import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/yoga_provider.dart';
import '../../dataProvider/foundation_provider.dart';
import '../../dataProvider/article_provider.dart';
import '../../models/yoga_program.dart';

class YogaMeditationScreen extends StatefulWidget {
  const YogaMeditationScreen({super.key});

  @override
  State<YogaMeditationScreen> createState() => _YogaMeditationScreenState();
}

class _YogaMeditationScreenState extends State<YogaMeditationScreen> {
  String _activeFilter = 'All Session';
  final List<String> _filters = [
    'All Session',
    'In-person at Sanctuary',
    'Virtual Classes',
    'Private Sadhana',
    'Youth Programs',
  ];

  @override
  Widget build(BuildContext context) {
    final yogaProvider = context.watch<YogaProvider>();
    final foundationProvider = context.watch<FoundationProvider>();
    final articleProvider = context.watch<ArticleProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. HERO SECTION
                _buildHeroSection(isDesktop),

                const SizedBox(height: 100),

                // 2. SADHANA CURRICULA GRID
                _buildCurriculaSection(isDesktop, yogaProvider),

                const SizedBox(height: 100),

                // 3. DAILY TIMETABLE
                _buildTimetableSection(isDesktop, yogaProvider),

                const SizedBox(height: 100),

                // 4. LINEAGE ACHARYAS
                _buildAcharyasSection(isDesktop, foundationProvider),

                const SizedBox(height: 100),

                // 5. SHASTRA INSIGHTS & ESSAYS
                _buildEssaysSection(isDesktop, articleProvider),

                const SizedBox(height: 100),

                // FOOTER
                AppFooter(isDesktop: isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- 1. HERO SECTION ---
  Widget _buildHeroSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "AUTHENTIC VEDIC TRADITION"),
          const SizedBox(height: 24),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: _buildHeroLeft()),
                const SizedBox(width: 60),
                Expanded(flex: 4, child: _buildHeroRight()),
              ],
            )
          else
            Column(
              children: [
                _buildHeroLeft(),
                const SizedBox(height: 48),
                _buildHeroRight(),
              ],
            ),
          const SizedBox(height: 48),
          _buildHeroBanner(),
        ],
      ),
    );
  }

  Widget _buildHeroLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            style: AppTextStyles.heroHeading,
            children: [
              TextSpan(text: "Union with the Eternal,\nAuthentic Vedic "),
              TextSpan(
                text: "Yoga &\nContemplative Dhyana.",
                style: AppTextStyles.heroSubheading,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "Authentic meditation methods rooted in the Advaita Shastra tradition, providing professional guidance for inner inquiry. Join our live sangha for daily sessions dedicated to manuscript study and Vedic breath sciences with authorized lineage keepers.",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            AppButton(
              text: "Explore Our Vows",
              onPressed: () {},
              isPrimary: true,
            ),
            const SizedBox(width: 24),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: const Text("View Sadhana Schedule"),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
                textStyle: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroRight() {
    return AppCardContainer(
      height: 400,
      borderRadius: 24,
      borderColor: null,
      image: const DecorationImage(
        image: AssetImage("assets/image_3.png"),
        fit: BoxFit.cover,
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dharma of the Soul: Gurukul",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Classical Chant Repository & Library",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 24,
            right: 24,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.fullscreen, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: AppColor.primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Daily at 5:30 AM IST at Surya Mandapam & Live stream",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Access Stream →", style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }

  // --- 2. SADHANA CURRICULA SECTION ---
  Widget _buildCurriculaSection(bool isDesktop, YogaProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SHASTRA BASED SADHANA"),
          const SizedBox(height: 24),
          const Text(
            "Vedic Yoga Sadhana Curricula",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop
                  ? 4
                  : (constraints.maxWidth > 700 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.yogaPrograms.map((program) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.lightPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            program.type == ProgramType.yoga
                                ? Icons.spa_outlined
                                : Icons.psychology_outlined,
                            color: AppColor.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          program.type == ProgramType.yoga
                              ? "YOGA"
                              : "MEDITATION",
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          program.title,
                          style: AppTextStyles.title.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "• Systematic Progression",
                          style: AppTextStyles.bodySmall,
                        ),
                        const Text(
                          "• Lineage Based Training",
                          style: AppTextStyles.bodySmall,
                        ),
                        const Text(
                          "• Vedic Phonetic Cycles",
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 32),
                        const Text("Learn More →", style: AppTextStyles.link),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- 3. DAILY TIMETABLE SECTION ---
  Widget _buildTimetableSection(bool isDesktop, YogaProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sanctuary Daily Timetable",
                style: AppTextStyles.heading2,
              ),
              if (isDesktop) _buildFilters(),
            ],
          ),
          if (!isDesktop) ...[const SizedBox(height: 24), _buildFilters()],
          const SizedBox(height: 48),
          Column(
            children: provider.yogaTimetable.map((item) {
              return AppCardContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                borderRadius: 20,
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        item['time'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item['title'],
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1E6D9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['tag'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['location'],
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (isDesktop)
                      Expanded(
                        child: Text(
                          item['mode'],
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    const SizedBox(width: 40),
                    AppButton(
                      text: "Book",
                      onPressed: () {},
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final bool isActive = _activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ChoiceChip(
              label: Text(filter),
              selected: isActive,
              onSelected: (val) {
                if (val) setState(() => _activeFilter = filter);
              },
              selectedColor: AppColor.primary,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 4. ACHARYAS SECTION ---
  Widget _buildAcharyasSection(bool isDesktop, FoundationProvider provider) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: "SADHANĀ & GURU SHISHYA"),
              const SizedBox(height: 24),
              const Text(
                "Revered Lineage Acharyas",
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = isDesktop
                      ? 3
                      : (constraints.maxWidth > 700 ? 2 : 1);
                  double spacing = 40.0;
                  double itemWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: provider.teamMembers.map((member) {
                      return AppCardContainer(
                        width: itemWidth,
                        padding: EdgeInsets.zero,
                        borderRadius: 24,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.2,
                              child: Image.asset(
                                "assets/image_2.png", // Placeholder as per provider.teamMembers
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.role.toUpperCase(),
                                    style: AppTextStyles.bulletLabel,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    member.bio,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      height: 1.6,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 32),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Specialty: Vedic Wisdom",
                                        style: AppTextStyles.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "Full Biography →",
                                        style: AppTextStyles.link,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 5. ESSAYS SECTION ---
  Widget _buildEssaysSection(bool isDesktop, ArticleProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "DHYĀNA VIDYĀ"),
          const SizedBox(height: 24),
          const Text(
            "Shastra Insights & Essays",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop
                  ? 3
                  : (constraints.maxWidth > 700 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.articles.map((article) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.category.toUpperCase(),
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          article.title,
                          style: AppTextStyles.title.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          article.excerpt,
                          style: AppTextStyles.bodySmall.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "By ${article.author}",
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Read Essay →",
                              style: AppTextStyles.link,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
