import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/foundation_provider.dart';
import '../../models/article_item.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  String _activeFilter = 'All Curricula';
  final List<String> _filters = [
    'All Curricula',
    'Vedic Philosophy',
    'Sanskrit Grammar',
    'Phonetics & Chanting',
    'Research Methods',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoundationProvider>();

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

                // 2. THE SIX VEDANGAS
                _buildVedangasSection(isDesktop, provider),

                const SizedBox(height: 100),

                // 3. VEDIC CURRICULA GRID
                _buildCurriculaSection(isDesktop, provider),

                const SizedBox(height: 100),

                // 4. FEATURED STUDY: RIGVEDA SVARA PATHA
                _buildFeaturedStudySection(isDesktop),

                const SizedBox(height: 100),

                // 5. SHASTRA & RESEARCH TOOLS
                _buildResearchToolsSection(isDesktop),

                const SizedBox(height: 100),

                // 6. COHORT SCHEDULE
                _buildCohortScheduleSection(isDesktop, provider),

                const SizedBox(height: 100),

                // 7. PEDAGOGIC RESEARCH & ESSAYS
                _buildEssaysSection(isDesktop, provider),

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
          const SectionLabel(text: "AUTHENTIC VEDIC EPISTEMOLOGY"),
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
          _buildHeroStatsBar(isDesktop),
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
              TextSpan(text: "Sacred Epistemology &\n"),
              TextSpan(
                text: "Authentic Vedic Learning.",
                style: AppTextStyles.heroSubheading,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "Structured lineage academies providing classical models for Sanskrit grammar analysis, sacred philosophy structures, and traditional pedagogy. Our curriculum bridges the ancient oral transmission with modern academic rigor for profound intellectual and spiritual transformation.",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            AppButton(
              text: "Explore Academies",
              onPressed: () {},
              isPrimary: true,
            ),
            const SizedBox(width: 24),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text("Download Prospectus"),
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
        image: AssetImage("assets/image_2.png"),
        fit: BoxFit.cover,
      ),
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildHeroStatsBar(bool isDesktop) {
    final stats = [
      {"value": "12+", "label": "Years of Research"},
      {"value": "08", "label": "Vedic Academies"},
      {"value": "45+", "label": "Lineage Scholars"},
      {"value": "108+", "label": "Certified Courses"},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats
                  .map((s) => _statItem(s["value"]!, s["label"]!))
                  .toList(),
            )
          : Wrap(
              runSpacing: 24,
              spacing: 40,
              alignment: WrapAlignment.center,
              children: stats
                  .map((s) => _statItem(s["value"]!, s["label"]!))
                  .toList(),
            ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // --- 2. THE SIX VEDANGAS SECTION ---
  Widget _buildVedangasSection(bool isDesktop, FoundationProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          const SectionLabel(text: "FOUNDATIONAL LIMBS"),
          const SizedBox(height: 24),
          const Text(
            "The Six Vedangas of Vedic Masters",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "Mastering the auxiliary disciplines essential for the precise preservation and interpretation of the eternal Vedas.",
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
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
                children: provider.vedangas.map((v) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: AppColor.primary,
                        ),
                        const SizedBox(height: 20),
                        Text(v["title"]!, style: AppTextStyles.title),
                        const SizedBox(height: 12),
                        Text(v["desc"]!, style: AppTextStyles.bodySmall),
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

  // --- 3. VEDIC CURRICULA SECTION ---
  Widget _buildCurriculaSection(bool isDesktop, FoundationProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "PEDAGOGIC FRAMEWORKS"),
          const SizedBox(height: 24),
          const Text(
            "Vedic Curricula & Modern Courses",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          _buildFilters(),
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
                children: provider.courses.map((course) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 18,
                              color: AppColor.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              course.duration.toUpperCase(),
                              style: AppTextStyles.bulletLabel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          course.title,
                          style: AppTextStyles.title.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          course.description,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: course.topics
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.lightPrimary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "View Full Syllabus →",
                          style: AppTextStyles.link,
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final bool isActive = _activeFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
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

  // --- 4. FEATURED STUDY SECTION ---
  Widget _buildFeaturedStudySection(bool isDesktop) {
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
              const SectionLabel(text: "FEATURED PEDAGOGIC STUDY"),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildFeaturedContent()),
                    const SizedBox(width: 60),
                    Expanded(flex: 5, child: _buildFeaturedMedia()),
                  ],
                )
              else
                Column(
                  children: [
                    _buildFeaturedContent(),
                    const SizedBox(height: 48),
                    _buildFeaturedMedia(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rigveda Svara Patha: The Art of Phonetic Precision & Auditory Memory",
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 32),
        const Text(
          "Analyzing the unique tonal markers (Udātta, Anudātta, Svarita) that have preserved the Rigveda Samhita with zero variation for over three millennia. This study explores the intersection of traditional vocalization and modern cognitive neuroscience.",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 40),
        _bulletPoint("Systematic Phonetic Mapping"),
        _bulletPoint("Tonal Frequency Analysis"),
        _bulletPoint("Mnemonic Archiving Techniques"),
        const SizedBox(height: 48),
        AppButton(
          text: "Read Research Paper",
          onPressed: () {},
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_outline,
              size: 20,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMedia() {
    return AppCardContainer(
      height: 450,
      borderRadius: 24,
      borderColor: null,
      image: const DecorationImage(
        image: AssetImage("assets/image_3.png"),
        fit: BoxFit.cover,
      ),
      child: const SizedBox.shrink(),
    );
  }

  // --- 5. RESEARCH TOOLS SECTION ---
  Widget _buildResearchToolsSection(bool isDesktop) {
    final tools = [
      {
        "title": "Digital Scriptorium",
        "desc":
            "Access high-resolution scans of Grantha and Sharada manuscripts.",
      },
      {
        "title": "Svara Visualizer",
        "desc": "Real-time acoustic feedback for mastering Vedic accents.",
      },
      {
        "title": "Lexicon Archives",
        "desc": "Comprehensive etymological database of Vedic Sanskrit terms.",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          const SectionLabel(text: "SHASTRA & RESEARCH TOOLS"),
          const SizedBox(height: 24),
          const Text(
            "Digital Instruments for Ancient Inquiry",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop ? 3 : 1;
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: tools.map((t) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.auto_awesome_outlined,
                          color: AppColor.primary,
                          size: 24,
                        ),
                        const SizedBox(height: 20),
                        Text(t["title"]!, style: AppTextStyles.title),
                        const SizedBox(height: 12),
                        Text(t["desc"]!, style: AppTextStyles.bodySmall),
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

  // --- 6. COHORT SCHEDULE SECTION ---
  Widget _buildCohortScheduleSection(
    bool isDesktop,
    FoundationProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "ADMISSION CYCLES"),
          const SizedBox(height: 24),
          const Text(
            "Upcoming 2024 Cohort Schedule",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          Column(
            children: provider.cohortSchedule.map((item) {
              return AppCardContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                borderRadius: 20,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['course'],
                            style: AppTextStyles.title.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Starts: ${item['start']}",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        item['seats'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    if (isDesktop)
                      Expanded(
                        child: Text(
                          item['status'],
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    const SizedBox(width: 40),
                    AppButton(
                      text: "Apply Now",
                      onPressed: () {},
                      width: 120,
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

  // --- 7. ESSAYS SECTION ---
  Widget _buildEssaysSection(bool isDesktop, FoundationProvider provider) {
    final eduArticles = provider.articles
        .where((a) => a.category == "Language" || a.category == "Research")
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "ACADEMIC INSIGHTS"),
          const SizedBox(height: 24),
          const Text(
            "Pedagogic Research & Essays",
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
                children: eduArticles.map((article) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    onTap: () => _showArticleDialog(article),
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

  void _showArticleDialog(ArticleItem article) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 650),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: AppTextStyles.bulletLabel,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: AppTextStyles.heading2.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  "By ${article.author} • ${article.publishedDate.day}/${article.publishedDate.month}/${article.publishedDate.year}",
                  style: AppTextStyles.caption,
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      article.content,
                      style: AppTextStyles.body.copyWith(height: 1.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
