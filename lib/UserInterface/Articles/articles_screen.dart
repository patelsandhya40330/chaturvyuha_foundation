import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/article_provider.dart';
import '../../models/article_item.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _digestEmailController = TextEditingController();
  final _digestFormKey = GlobalKey<FormState>();

  String _searchQuery = '';
  String _selectedCategory = 'All Library';
  ArticleItem? _activeArticle;
  bool _isDigestSubmitting = false;

  final List<String> _categories = [
    'All Library',
    'Philosophy',
    'Language',
    'Ayurveda',
    'Phonetics',
    'Practice',
    'Wellness',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _digestEmailController.dispose();
    super.dispose();
  }

  // Digest Subscription Handler
  Future<void> _subscribeDigest() async {
    if (_digestFormKey.currentState!.validate()) {
      setState(() => _isDigestSubmitting = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isDigestSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subscribed! Bi-weekly Vedic dissertations will be sent to ${_digestEmailController.text.trim()}.',
          ),
          backgroundColor: AppColor.primary,
        ),
      );
      _digestEmailController.clear();
    }
  }

  // Image Preview Modal
  void _showImagePreview(String imagePath, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black.withAlpha(220),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 64,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(ctx),
                  tooltip: 'Close Preview',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticleProvider>();

    if (_activeArticle != null) {
      return _buildArticleDetail(_activeArticle!);
    }

    final filteredArticles = provider.articles.where((art) {
      final matchesSearch =
          art.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          art.excerpt.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All Library' ||
          art.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. HERO SECTION
                _buildHeroSection(isDesktop),

                const SizedBox(height: 60),

                // 2. SEARCH & FILTERS
                _buildSearchSection(isDesktop),

                const SizedBox(height: 100),

                // 3. FEATURED STUDY
                if (provider.articles.isNotEmpty)
                  _buildFeaturedArticle(isDesktop, provider.articles.first),

                const SizedBox(height: 120),

                // 4. CANONICAL DISSERTATIONS GRID
                _buildDissertationsSection(isDesktop, filteredArticles),

                const SizedBox(height: 120),

                // 5. RELATED CANONICAL DISCOURSES
                _buildRelatedDiscourses(isDesktop, provider),

                const SizedBox(height: 120),

                // 6. NEWSLETTER
                _buildNewsletterSection(isDesktop),

                const SizedBox(height: 100),

                // 7. VEDIC FOOTER TEXTS
                _buildVedicFooterText(),

                const SizedBox(height: 60),

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
          _buildBreadcrumbs(),
          const SizedBox(height: 48),
          const SectionLabel(text: "CANONICAL WISDOM & RESEARCH"),
          const SizedBox(height: 24),
          Text(
            'Eternal Revelations, Explicated for the\nModern Seeker.',
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: isDesktop ? 54 : 36,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'Explore curated dissertations, archival translations, and modern research essays at the intersection of Vedic tradition and contemporary inquiry. The library is purely non-profit and publicly accessible for researchers and students.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          _buildHeroStats(isDesktop),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        Text(
          "Home",
          style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
        ),
        const Icon(Icons.chevron_right, size: 14, color: AppColor.grey),
        Text(
          "Knowledge & Articles",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroStats(bool isDesktop) {
    final stats = [
      {"icon": Icons.menu_book, "value": "720+", "label": "Scholarly Works"},
      {
        "icon": Icons.history_edu,
        "value": "12+",
        "label": "Translation Projects",
      },
      {"icon": Icons.science, "value": "45+", "label": "Research Papers"},
      {"icon": Icons.public, "value": "Open", "label": "Access Library"},
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: stats.map((s) {
        return Container(
          width: isDesktop ? 220 : (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F6F1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(s["icon"] as IconData, color: AppColor.primary, size: 24),
              const SizedBox(height: 16),
              Text(
                s["value"]! as String,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s["label"]! as String,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 2. SEARCH SECTION ---
  Widget _buildSearchSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // Stack search bar components on mobile to prevent horizontal overflow.
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: _searchDecoration(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: _searchButton()),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: _searchDecoration(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _searchButton(),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final bool isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: AppColor.border),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Common decoration for search text field to maintain consistency.
  InputDecoration _searchDecoration() {
    return InputDecoration(
      hintText:
          'Search articles by title, manuscript keywords, lineage authors...',
      prefixIcon: const Icon(Icons.search, color: AppColor.primary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.border),
      ),
    );
  }

  // Unified search button widget to handle responsive behavior.
  Widget _searchButton() {
    return AppButton(
      text: "Search Library",
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _searchQuery.isEmpty
                  ? 'Showing all library articles'
                  : 'Filtered articles by "$_searchQuery"',
            ),
          ),
        );
      },
      isPrimary: true,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    );
  }

  Widget _buildFeaturedArticle(bool isDesktop, ArticleItem art) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "FEATURED READ OF THE MONTH"),
          const SizedBox(height: 32),
          AppCardContainer(
            padding: EdgeInsets.zero,
            borderRadius: 32,
            clipBehavior: Clip.antiAlias,
            onTap: () => setState(() => _activeArticle = art),
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () => _showImagePreview(
                              "assets/image_3.png",
                              art.title,
                            ),
                            child: Image.asset(
                              "assets/image_3.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(flex: 6, child: _buildFeaturedContent(art)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: InkWell(
                          onTap: () => _showImagePreview(
                            "assets/image_3.png",
                            art.title,
                          ),
                          child: Image.asset(
                            "assets/image_3.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      _buildFeaturedContent(art),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent(ArticleItem art) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E6D9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  art.category.toUpperCase(),
                  style: AppTextStyles.bulletLabel.copyWith(
                    fontSize: 11,
                    color: AppColor.primary,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.access_time, size: 16, color: Colors.black45),
              const SizedBox(width: 6),
              const Text(
                "12 Min Read",
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.calendar_today, size: 14, color: Colors.black45),
              const SizedBox(width: 6),
              const Text(
                "Published: Jan 2024",
                style: TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            art.title,
            style: AppTextStyles.heading2.copyWith(
              fontFamily: 'Georgia',
              fontSize: 36,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            art.excerpt,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 16,
              height: 1.6,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFF1E6D9),
                child: Icon(Icons.person, size: 24, color: AppColor.primary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Authored by ${art.author}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Text(
                    "Canonical Research Scholar | PhD",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          AppButton(
            text: "Read Full Dissertation",
            onPressed: () => setState(() => _activeArticle = art),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // --- 4. DISSERTATIONS GRID ---
  Widget _buildDissertationsSection(
    bool isDesktop,
    List<ArticleItem> articles,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SHASTRA & ACADEMIC DIALOGUE"),
          const SizedBox(height: 24),
          const Text(
            "Canonical Dissertations & Research Commentaries",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop
                  ? 3
                  : (constraints.maxWidth > 750 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: articles.map((art) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    backgroundColor: Colors.white,
                    onTap: () => setState(() => _activeArticle = art),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          art.category.toUpperCase(),
                          style: AppTextStyles.bulletLabel.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          art.title,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 19,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          art.excerpt,
                          style: AppTextStyles.bodySmall.copyWith(
                            height: 1.6,
                            color: Colors.black54,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 14,
                              backgroundColor: Color(0xFFF1E6D9),
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: AppColor.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                art.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: AppColor.primary,
                              ),
                              onPressed: () =>
                                  setState(() => _activeArticle = art),
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

  // --- 5. RELATED DISCOURSES ---
  Widget _buildRelatedDiscourses(bool isDesktop, ArticleProvider provider) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: "ESSENTIAL DHARMA STUDY"),
              const SizedBox(height: 24),
              const Text(
                "Related Canonical Discourses & Lineage Commentaries",
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 48),
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
                    children: provider.articles.skip(1).take(3).map((art) {
                      return AppCardContainer(
                        width: itemWidth,
                        padding: const EdgeInsets.all(32),
                        borderRadius: 24,
                        backgroundColor: Colors.white,
                        onTap: () => setState(() => _activeArticle = art),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              art.category.toUpperCase(),
                              style: AppTextStyles.bulletLabel.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              art.title,
                              style: AppTextStyles.title.copyWith(
                                fontSize: 17,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              art.excerpt,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "Explore Discourse →",
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
        ),
      ),
    );
  }

  // --- 6. NEWSLETTER SECTION ---
  Widget _buildNewsletterSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: AppCardContainer(
        width: double.infinity,
        padding: EdgeInsets.all(isDesktop ? 80 : 32),
        backgroundColor: const Color(0xFF2C1B10),
        borderRadius: 40,
        child: Column(
          children: [
            const SectionLabel(text: "SADHANĀ DIGEST", color: Colors.white70),
            const SizedBox(height: 24),
            const Text(
              "Receive Bi-Weekly Vedic Dissertations\nDirectly in Your Inbox.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Structured analytical summaries of the Upanishads, phonetics guides, and monthly research papers curated by our lineage keepers.",
              style: TextStyle(color: Colors.white70, fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _digestFormKey,
                child: LayoutBuilder(
                  builder: (context, box) {
                    bool isWide = box.maxWidth > 500;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _digestEmailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Enter your email address",
                                    hintStyle: const TextStyle(
                                      color: Colors.white38,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withAlpha(20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 20,
                                    ),
                                  ),
                                  validator: (v) =>
                                      (v == null || !v.contains('@'))
                                      ? 'Please enter a valid email'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              AppButton(
                                text: _isDigestSubmitting
                                    ? "Subscribing..."
                                    : "Subscribe Now",
                                onPressed: _isDigestSubmitting
                                    ? () {}
                                    : _subscribeDigest,
                                isPrimary: true,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextFormField(
                                controller: _digestEmailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Enter your email address",
                                  hintStyle: const TextStyle(
                                    color: Colors.white38,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withAlpha(20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                    ? 'Please enter a valid email'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: AppButton(
                                  text: _isDigestSubmitting
                                      ? "Subscribing..."
                                      : "Subscribe Now",
                                  onPressed: _isDigestSubmitting
                                      ? () {}
                                      : _subscribeDigest,
                                  isPrimary: true,
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 7. VEDIC FOOTER TEXTS ---
  Widget _buildVedicFooterText() {
    return Column(
      children: [
        const Text(
          "॥ सह नाववतु । सह नौ भुनक्तु । सह वीर्यं करवावहै । तेजस्वि नावधीतमस्तु मा विद्विषावहै ॥",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "॥ ॐ शान्तिः शान्तिः शान्तिः ॥",
          style: TextStyle(fontSize: 18, color: AppColor.primary),
        ),
        const SizedBox(height: 32),
        const Text(
          "॥ असतो मा सद्गमय । तमसो मा ज्योतिर्गमय । मृत्योर्मा अमृतं गमय ॥",
          style: TextStyle(fontSize: 20, color: AppColor.secondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildArticleDetail(ArticleItem art) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => _activeArticle = null),
        ),
        title: const Text(
          'Canonical Research Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    art.category.toUpperCase(),
                    style: AppTextStyles.sectionLabel,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    art.title,
                    style: AppTextStyles.heading2.copyWith(
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFF1E6D9),
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            art.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Published: ${art.publishedDate.day}/${art.publishedDate.month}/${art.publishedDate.year}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Text(
                    art.content,
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
                  ),
                  const SizedBox(height: 48),

                  Text('RESEARCH TAGS:', style: AppTextStyles.bulletLabel),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: art.tags
                        .map(
                          (t) => Chip(
                            backgroundColor: const Color(0xFFF1E6D9),
                            label: Text(
                              t,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 60),

                  const Divider(),
                  const SizedBox(height: 40),
                  const SectionLabel(text: "SEO METADATA (DEMO ONLY)"),
                  const SizedBox(height: 16),
                  Text(
                    "Title Tag: ${art.seoTitle}",
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    "Meta Description: ${art.seoDescription}",
                    style: AppTextStyles.bodySmall,
                  ),
                  Text(
                    "Keywords: ${art.seoKeywords}",
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
