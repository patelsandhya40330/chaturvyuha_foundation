import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import '../../Widgats/app_card_container.dart';
import '../../dataProvider/foundation_provider.dart';

/// A screen displaying the foundational principles of Dharma and living Sanskriti.
///
/// Features search and topic filters, Sanatana Dharma principles, indigenous ecological values,
/// Shodasha Samskaras (16 life sacraments), Vedic Panchanga calendar, and shloka invocations.
class DharmaSanskritiScreen extends StatefulWidget {
  const DharmaSanskritiScreen({super.key});

  @override
  State<DharmaSanskritiScreen> createState() => _DharmaSanskritiScreenState();
}

/// State implementation for [DharmaSanskritiScreen], managing scroll control,
/// archive keyword searches, active category topic filter, modal information dialogs,
/// and image preview overlays.
class _DharmaSanskritiScreenState extends State<DharmaSanskritiScreen> {
  /// Controller for main page vertical scrolling.
  final ScrollController _scrollController = ScrollController();

  /// Controller for the search text input field.
  final TextEditingController _searchController = TextEditingController();

  /// Currently selected category filter topic (defaults to 'All Topics').
  String _selectedCategory = "All Topics";

  /// Available category filter topics.
  final List<String> _categories = [
    "All Topics",
    "Philosophy",
    "Linguistic Arts",
    "Ritual Sciences",
    "Indigenous Ethics",
    "Panchanga Study",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Displays an information dialog modal containing detailed essay content.
  ///
  /// [title] The header title of the modal.
  /// [content] The descriptive body text of the essay or sacrament.
  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.title.copyWith(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const Divider(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: AppTextStyles.body.copyWith(height: 1.6),
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

  /// Displays a fullscreen interactive image preview modal.
  ///
  /// [imagePath] Path to the asset image.
  /// [title] Display title for the overlay header.
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
                    errorBuilder: (c, e, s) {
                      debugPrint('Dharma image preview error: $e');
                      return const SizedBox.shrink();
                    },
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
    final provider = context.watch<FoundationProvider>();

    final bool showAll = _selectedCategory == "All Topics";
    final bool showPhilosophy = showAll || _selectedCategory == "Philosophy";
    final bool showIndigenous =
        showAll ||
        _selectedCategory == "Linguistic Arts" ||
        _selectedCategory == "Indigenous Ethics";
    final bool showSamskaras =
        showAll || _selectedCategory == "Ritual Sciences";
    final bool showPanchanga =
        showAll || _selectedCategory == "Panchanga Study";

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

                const SizedBox(height: 100),

                // 2. FOUNDATIONAL PRINCIPLES
                if (showPhilosophy) ...[
                  _buildFoundationalPrinciples(isDesktop, constraints.maxWidth),
                  const SizedBox(height: 120),
                ],

                // 3. INDIGENOUS VALUES & ECOLOGY
                if (showIndigenous) ...[
                  _buildIndigenousValues(isDesktop),
                  const SizedBox(height: 120),
                ],

                // 4. SHODASHA SAMSKARAS
                if (showSamskaras) ...[
                  _buildSamskarasSection(isDesktop, constraints.maxWidth),
                  const SizedBox(height: 120),
                ],

                // 5. VEDIC PANCHANGA
                if (showPanchanga) ...[
                  _buildPanchangaSection(
                    isDesktop,
                    constraints.maxWidth,
                    provider,
                  ),
                  const SizedBox(height: 100),
                ],

                // 6. SHLOKA INVOCATION
                _buildShlokaInvocation(),

                const SizedBox(height: 60),

                // 7. FOOTER
                AppFooter(isDesktop: isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the hero banner section containing breadcrumb navigation,
  /// main headings, search input, responsive filter chips, and featured manuscript image.
  Widget _buildHeroSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Home",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: AppColor.grey,
                  ),
                  Text(
                    "Dharma & Sanskriti",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (isDesktop)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7E9D7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "• ETERNAL VALUES • SACRED HERITAGE • LIVING TRADITIONS",
                    style: AppTextStyles.bulletLabel.copyWith(fontSize: 10),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 60),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _buildHeroContent()),
                const SizedBox(width: 60),
                Expanded(flex: 4, child: _buildHeroImage(isDesktop)),
              ],
            )
          else
            Column(
              children: [
                _buildHeroContent(),
                const SizedBox(height: 24),
                _buildHeroImage(isDesktop),
              ],
            ),
        ],
      ),
    );
  }

  /// Builds the text and controls column inside the hero section, including search bar and responsive category chips.
  Widget _buildHeroContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final double heroFontSize = screenWidth >= 1100
            ? 54
            : (screenWidth < 400 ? 28 : 36);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel(text: "ANCIENT WISDOM & HERITAGE"),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: AppTextStyles.heroHeading.copyWith(
                  fontSize: heroFontSize,
                  height: 1.1,
                ),
                children: [
                  const TextSpan(text: "Preserving Eternal "),
                  TextSpan(
                    text: "Dharma ",
                    style: AppTextStyles.heroSubheading.copyWith(
                      fontSize: heroFontSize,
                    ),
                  ),
                  const TextSpan(text: "& Living Sanskriti"),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "An exploration of the core ethical frameworks, linguistic structures, and cultural rituals that define the Vedic way of life. Our mission is to bridge primordial wisdom with modern living for a balanced human experience.",
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, searchConstraints) {
                // Adaptive search bar layout for narrow mobile screens.
                if (searchConstraints.maxWidth < 600) {
                  return Column(
                    children: [
                      _searchField(),
                      const SizedBox(height: 16),
                      SizedBox(width: double.infinity, child: _searchButton()),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: _searchField()),
                    const SizedBox(width: 16),
                    _searchButton(),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, boxConstraints) {
                final categoryChips = _categories.map((cat) {
                  final bool isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColor.primary : AppColor.border,
                      ),
                    ),
                  );
                }).toList();

                if (boxConstraints.maxWidth >= 768) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: categoryChips,
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categoryChips
                          .map(
                            (chip) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: chip,
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Returns the text field widget for searching Dharma & Sanskriti topics.
  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() {}),
      onSubmitted: (query) {
        if (query.trim().isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Searching archives for "${query.trim()}"...'),
            ),
          );
        }
      },
      decoration: InputDecoration(
        hintText: "Search Dharma topics, keywords, lineage references...",
        prefixIcon: const Icon(Icons.search, color: AppColor.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  /// Returns the primary search action button widget.
  Widget _searchButton() {
    return AppButton(
      text: "Explore",
      onPressed: () {
        final query = _searchController.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              query.isEmpty
                  ? 'Showing all Dharma & Sanskriti topics'
                  : 'Filtered topics by "$query"',
            ),
          ),
        );
      },
      isPrimary: true,
    );
  }

  /// Builds the manuscript image preview card in the hero section.
  Widget _buildHeroImage([bool isDesktop = true]) {
    return AppCardContainer(
      height: isDesktop ? 450 : 280,
      borderRadius: 24,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      onTap: () => _showImagePreview(
        "assets/image_2.png",
        "Classical Sanskrit Manuscripts",
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/image_2.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFE5DED4),
              child: const Icon(
                Icons.image_outlined,
                size: 64,
                color: AppColor.primary,
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(140),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manuscript Archives",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Classical Sanskrit Heritage & Library",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "Dharma Tattvas" section showcasing foundational philosophical principles in a responsive card grid.
  Widget _buildFoundationalPrinciples(bool isDesktop, double maxWidth) {
    final principles = [
      {
        "label": "COSMIC ORDER",
        "title": "Sanatana Dharma: The Cosmic Blueprint",
        "desc":
            "Understanding the eternal moral laws and duty that govern the universe and individual existence.",
        "full":
            "Sanātana Dharma translates to the 'Eternal Law or Duty'. Unlike dogma, it represents the harmonic blueprint underlying all natural cycles, ethics, and cosmic balance. By living in alignment with Ṛta (cosmic order), individuals fulfill their personal duties (Svadharma) while maintaining planetary harmony.",
      },
      {
        "label": "LIFE'S AIMS",
        "title": "Purushartha: Four Sacred Aims",
        "desc":
            "Dharma (Ethics), Artha (Prosperity), Kama (Pleasure), and Moksha (Liberation) as the foundation of a balanced life.",
        "full":
            "Puruṣārtha delineates the four canonical aims of human existence:\n\n1. Dharma: Righteousness and moral duty\n2. Artha: Material prosperity and security\n3. Kāma: Sensorial and aesthetic enjoyment\n4. Mokṣa: Ultimate spiritual liberation\n\nWhen Artha and Kama are guided by Dharma, they naturally ripen into Moksha.",
      },
      {
        "label": "SELF-KNOWLEDGE",
        "title": "Svadharma: Individual Nature",
        "desc":
            "Discovering one's unique path and duties aligned with personal temperament and cosmic responsibility.",
        "full":
            "Svadharma is one's personal duty dictated by inherent qualities (Guṇas) and stage of life (Āśrama). Following another's path brings internal disharmony, whereas embracing one's Svadharma fosters authentic spiritual evolution and psychological peace.",
      },
      {
        "label": "EVOLUTION",
        "title": "Vidhi-Nishedha: Precepts",
        "desc":
            "Analyzing the traditional guidelines for actions that foster growth and avoid stagnation in consciousness.",
        "full":
            "Vidhi represents constructive, life-affirming duties (what ought to be practiced), while Niṣedha represents prohibited, harmful actions (what ought to be avoided). Together, they act as an ethical compass guiding human conduct.",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "DHARMA TATTVAS"),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: AppTextStyles.heading2.copyWith(
                fontSize: isDesktop
                    ? 36
                    : (MediaQuery.of(context).size.width < 400 ? 24 : 28),
              ),
              children: [
                const TextSpan(text: "Foundational Principles of "),
                TextSpan(
                  text: "Dharma",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: principles.map((p) {
              double width = isDesktop
                  ? (maxWidth - 120 - 72) / 4
                  : (maxWidth > 600 ? (maxWidth - 40 - 24) / 2 : maxWidth - 40);
              return AppCardContainer(
                width: width,
                padding: const EdgeInsets.all(28),
                borderRadius: 24,
                onTap: () => _showInfoDialog(p["title"]!, p["full"]!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.lightPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_stories_outlined,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      p["label"]!,
                      style: AppTextStyles.bulletLabel.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p["title"]!,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(p["desc"]!, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 24),
                    const Text("Read Essay →", style: AppTextStyles.link),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Builds the "Indigenous Values & Ecology" section with features and image presentation.
  Widget _buildIndigenousValues(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 5, child: _buildIndigenousImage()),
                const SizedBox(width: 80),
                Expanded(flex: 5, child: _buildIndigenousContent()),
              ],
            )
          : Column(
              children: [
                _buildIndigenousImage(),
                const SizedBox(height: 48),
                _buildIndigenousContent(),
              ],
            ),
    );
  }

  /// Builds the image card for the indigenous ecology section.
  Widget _buildIndigenousImage() {
    return AppCardContainer(
      height: 500,
      borderRadius: 24,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      onTap: () => _showImagePreview(
        "assets/image_3.png",
        "Indigenous Ecology & Living Traditions",
      ),
      child: Image.asset(
        "assets/image_3.png",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFE5DED4),
          child: const Icon(
            Icons.image_outlined,
            size: 64,
            color: AppColor.primary,
          ),
        ),
      ),
    );
  }

  /// Builds the textual feature highlights column for indigenous values and oral traditions.
  Widget _buildIndigenousContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: "VALUES & ECOLOGY"),
        const SizedBox(height: 24),
        const Text(
          "Indigenous Values, Ecology & Living Oral Traditions",
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 24),
        const Text(
          "Vedic culture is intrinsically linked with the natural world. Our teachings emphasize a symbiotic relationship with the environment, recognizing sacredness in all life forms and cosmic rhythms.",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 40),
        _indigenousFeature(
          Icons.eco_outlined,
          "Prakriti: Mother Nature as Gurukul",
          "Learning from the cycles of seasons and the wisdom of local ecosystems.",
        ),
        const SizedBox(height: 24),
        _indigenousFeature(
          Icons.record_voice_over_outlined,
          "Orality: Preservation via Sound",
          "How the precise vibrations of chanting protect scriptural integrity.",
        ),
        const SizedBox(height: 24),
        _indigenousFeature(
          Icons.history_edu_outlined,
          "Lineage: The Unbroken Chain",
          "Connecting modern practitioners with the ancient Guru-Shishya parampara.",
        ),
      ],
    );
  }

  /// Helper builder for individual feature rows (Icon + Title + Description).
  Widget _indigenousFeature(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.primary, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: 18,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 8),
              Text(desc, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the "Shodasha Samskaras" section outlining the 16 lifecycle sacraments.
  Widget _buildSamskarasSection(bool isDesktop, double maxWidth) {
    final samskaras = [
      {
        "title": "Garbhadhana to Simanta",
        "desc":
            "Prenatal sacraments focused on welcoming the soul with sacred intention and mental clarity.",
        "full":
            "Prenatal sacraments (Garbhādhāna, Puṁsavana, Sīmantonnayana) align the parents' consciousness, invoked mantras, and environmental purity to prepare a sacred vessel for the incoming soul.",
      },
      {
        "title": "Jatakarma & Namakarana",
        "desc":
            "Sacraments of birth and naming, establishing the individual's identity and cosmic connection.",
        "full":
            "Birth and naming sacraments invoke cosmic alignment, astrological resonance, and family heritage, giving the newborn an auspicious name charged with phonetic energy.",
      },
      {
        "title": "Upanayana & Vidyarambha",
        "desc":
            "Educational transitions marking the start of scriptural study and inner discipline.",
        "full":
            "Upanayana signifies 'bringing near' to the Guru and the Veda. The sacred thread (Yajñopavīta) and Gayatri initiation mark the spiritual rebirth into disciplined study.",
      },
      {
        "title": "Vivaha & Vanaprastha",
        "desc":
            "Mature transitions of householder life and the subsequent inward turn towards wisdom.",
        "full":
            "Vivāha elevates householder partnership into a shared spiritual Yajna. Vānaprastha marks the gradual transition from worldly obligations to contemplative solitude.",
      },
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          const SectionLabel(text: "LIFECYCLE TRANSITIONS"),
          const SizedBox(height: 24),
          const Text(
            "Shodasha Samskaras: The 16 Sacraments of Human Life",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            "Sacred milestones structured to elevate consciousness at every physical and mental stage of development.",
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: samskaras.map((s) {
              double width = isDesktop
                  ? (maxWidth - 120 - 72) / 4
                  : (maxWidth > 600 ? (maxWidth - 40 - 24) / 2 : maxWidth - 40);
              return AppCardContainer(
                width: width,
                padding: const EdgeInsets.all(32),
                borderRadius: 24,
                backgroundColor: Colors.white,
                onTap: () => _showInfoDialog(s["title"]!, s["full"]!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s["title"]!,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(s["desc"]!, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 24),
                    const Text("Learn More →", style: AppTextStyles.link),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
          AppCardContainer(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            borderRadius: 16,
            backgroundColor: const Color(0xFFF1E6D9),
            borderColor: null,
            child: LayoutBuilder(
              builder: (context, box) {
                bool isWide = box.maxWidth > 650;
                return isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 16),
                              Text(
                                "The Comprehensive Shodasha Samskara Manual",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          AppButton(
                            text: "Download Guide PDF",
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Downloading Shodasha Samskara Guide PDF...',
                                  ),
                                ),
                              );
                            },
                            isPrimary: true,
                            width: 220,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "The Comprehensive Shodasha Samskara Manual",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: "Download Guide PDF",
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Downloading Shodasha Samskara Guide PDF...',
                                    ),
                                  ),
                                );
                              },
                              isPrimary: true,
                            ),
                          ),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the "Vedic Panchanga" section displaying upcoming sacred calendar alignments.
  Widget _buildPanchangaSection(
    bool isDesktop,
    double maxWidth,
    FoundationProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "TIME & FESTIVALS"),
          const SizedBox(height: 24),
          const Text(
            "Vedic Panchanga & Sacred Festival Alignments",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: provider.culturalCalendar.map((cal) {
              int index = provider.culturalCalendar.indexOf(cal);
              final List<Color> headerColors = [
                const Color(0xFF2C1B10), // Dark Brown
                const Color(0xFFF18406), // Saffron
                const Color(0xFF8B5E3C), // Medium Brown
                const Color(0xFFD4AF37), // Gold/Mustard
              ];
              Color headerColor = headerColors[index % headerColors.length];
              double width = isDesktop
                  ? (maxWidth - 120 - 72) / 4
                  : (maxWidth > 600 ? (maxWidth - 40 - 24) / 2 : maxWidth - 40);
              return AppCardContainer(
                width: width,
                padding: EdgeInsets.zero,
                borderRadius: 20,
                clipBehavior: Clip.antiAlias,
                onTap: () => _showInfoDialog(
                  cal['event']!,
                  "Date: ${cal['date']}\n\nSignificance:\n${cal['significance']}\n\nObservance Guidelines:\nFast during tithi alignment, perform dawn prātah saṁdhyā, and participate in collective chanting at the sanctuary hall.",
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      color: headerColor,
                      child: Text(
                        cal['date']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cal['event']!,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 18,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            cal['significance']!,
                            style: AppTextStyles.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Full Details →",
                            style: AppTextStyles.link,
                          ),
                        ],
                      ),
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

  /// Builds the Sanskrit Shloka invocation footer section.
  Widget _buildShlokaInvocation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFFF9F6F1),
      child: Column(
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
          const SizedBox(height: 40),
          const Text(
            "\"Om. May He protect us both together. May He nourish us both together.\nMay we work conjointly with great energy.\nMay our study be vigorous and effective. May we not mutually dispute.\nOm. Peace! Peace! Peace!\"",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColor.bodyText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
