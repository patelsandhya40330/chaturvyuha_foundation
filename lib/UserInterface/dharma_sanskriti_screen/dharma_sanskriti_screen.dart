import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import '../../Widgats/app_card_container.dart';
import '../../dataProvider/foundation_provider.dart';

class DharmaSanskritiScreen extends StatefulWidget {
  const DharmaSanskritiScreen({super.key});

  @override
  State<DharmaSanskritiScreen> createState() => _DharmaSanskritiScreenState();
}

class _DharmaSanskritiScreenState extends State<DharmaSanskritiScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All Topics";

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

  // Info Dialog Helper
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
    final provider = context.watch<FoundationProvider>();

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
                _buildFoundationalPrinciples(isDesktop, constraints.maxWidth),

                const SizedBox(height: 120),

                // 3. INDIGENOUS VALUES & ECOLOGY
                _buildIndigenousValues(isDesktop),

                const SizedBox(height: 120),

                // 4. SHODASHA SAMSKARAS
                _buildSamskarasSection(isDesktop, constraints.maxWidth),

                const SizedBox(height: 120),

                // 5. VEDIC PANCHANGA
                _buildPanchangaSection(
                  isDesktop,
                  constraints.maxWidth,
                  provider,
                ),

                const SizedBox(height: 100),

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
                Expanded(flex: 4, child: _buildHeroImage()),
              ],
            )
          else
            Column(
              children: [
                _buildHeroContent(),
                const SizedBox(height: 48),
                _buildHeroImage(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: "ANCIENT WISDOM & HERITAGE"),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: 54,
              height: 1.1,
            ),
            children: [
              const TextSpan(text: "Preserving Eternal "),
              TextSpan(
                text: "Dharma",
                style: AppTextStyles.heroSubheading.copyWith(fontSize: 54),
              ),
              const TextSpan(text: "\n& Living Sanskriti"),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "An exploration of the core ethical frameworks, linguistic structures, and cultural rituals that define the Vedic way of life. Our mission is to bridge primordial wisdom with modern living for a balanced human experience.",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onSubmitted: (query) {
                  if (query.trim().isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Searching archives for "${query.trim()}"...',
                        ),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText:
                      "Search Dharma topics, keywords, lineage references...",
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
              ),
            ),
            const SizedBox(width: 16),
            AppButton(
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
            ),
          ],
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
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColor.border),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return AppCardContainer(
      height: 450,
      borderRadius: 24,
      onTap: () => _showImagePreview(
        "assets/image_2.png",
        "Classical Sanskrit Manuscripts",
      ),
      image: const DecorationImage(
        image: AssetImage("assets/image_2.png"),
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

  // --- 2. FOUNDATIONAL PRINCIPLES ---
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
              style: AppTextStyles.heading2.copyWith(fontSize: 36),
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
                  : (maxWidth - 40 - 24) / 2;
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

  // --- 3. INDIGENOUS VALUES & ECOLOGY ---
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

  Widget _buildIndigenousImage() {
    return AppCardContainer(
      height: 500,
      borderRadius: 24,
      onTap: () => _showImagePreview(
        "assets/image_3.png",
        "Indigenous Ecology & Living Traditions",
      ),
      image: const DecorationImage(
        image: AssetImage("assets/image_3.png"),
        fit: BoxFit.cover,
      ),
      child: const SizedBox.shrink(),
    );
  }

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

  // --- 4. SHODASHA SAMSKARAS ---
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
                  : maxWidth - 40;
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

  // --- 5. VEDIC PANCHANGA ---
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
                  : (maxWidth - 40 - 24) / 2;
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

  // --- 6. SHLOKA INVOCATION ---
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
