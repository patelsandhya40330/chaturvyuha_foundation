import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';

import '../../Widgats/app_card_container.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;
  const HomeScreen({super.key, this.onTabSelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  Timer? _timer;

  // List of images for the hero slideshow
  final List<String> _heroImages = [
    "assets/image_1.png",
    "assets/image_2.png",
    "assets/image_3.png",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 60 : 20,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      // 1. HERO SECTION (Existing)
                      _buildHeroSection(isDesktop),

                      const SizedBox(height: 100),

                      // 2. FOUR SACRED GATEWAYS - Grid of 4 portals
                      _buildGatewaysSection(isDesktop),

                      const SizedBox(height: 100),

                      // 3. FEATURED PRACTICE & DAILY REGIMEN - Practice details + Audio player mockup
                      _buildPracticesSection(isDesktop),

                      const SizedBox(height: 100),

                      // 4. SANSKRIT INTENSIVE BANNER - Call to action for enrollment
                      _buildSanskritBanner(isDesktop),

                      const SizedBox(height: 100),

                      // 5. LIVING MOMENTS OF SADHANA - Visual gallery with overlays
                      _buildSadhanaGallery(isDesktop),

                      const SizedBox(height: 100),

                      // 6. WEEKLY CONTEMPLATIVE DARSHAN - Newsletter subscription section
                      _buildNewsletterSection(isDesktop),
                    ],
                  ),
                ),
                // 7. COMPREHENSIVE FOOTER - Links and copyright
                _buildFooter(isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- 1. HERO SECTION (Already implemented) ---
  Widget _buildHeroSection(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 6, child: _buildHeroLeftContent()),
          const SizedBox(width: 60),
          Expanded(flex: 4, child: _buildHeroRightCard()),
        ],
      );
    }
    return Column(
      children: [
        _buildHeroLeftContent(),
        const SizedBox(height: 40),
        _buildHeroRightCard(),
      ],
    );
  }

  Widget _buildHeroLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabelWithDot("WISDOM • WELLNESS • COMMUNITY"),
        const SizedBox(height: 24),
        const Text("Ancient Wisdom.", style: AppTextStyles.heroHeading),
        const Text("A Meaningful Life.", style: AppTextStyles.heroSubheading),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: const Text(
            "Discover classical Vedic learning, mindful yoga sciences, and indigenous cultural traditions crafted to inspire balanced human potential and unite a conscious seeker collective.",
            style: AppTextStyles.bodyLarge,
          ),
        ),
        const SizedBox(height: 48),
        AppButton(
          text: "Become a Member",
          onPressed: () => widget.onTabSelected?.call(9),
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildHeroRightCard() {
    return AppCardContainer(
      width: double.infinity,
      height: 450,
      backgroundColor: const Color(0xFFF9F6F1),
      borderRadius: 32,
      borderColor: null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _heroImages.length,
          itemBuilder: (context, index) {
            return Image.asset(
              _heroImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFE5DED4),
                child: const Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: AppColor.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 2. FOUR SACRED GATEWAYS SECTION ---
  Widget _buildGatewaysSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabelWithDot("FOUR SACRED GATEWAYS"),
        const SizedBox(height: 16),
        const Text(
          "Pathways of Timeless Wisdom",
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 12),
        const Text(
          "Each portal is a dedicated path for foundational study, practical application, scholarly preservation, and archival heritage.",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 48),
        // Flexible grid: Adjusts columns and height to prevent content overflow.
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final int crossAxisCount = isDesktop ? 4 : (width > 700 ? 2 : 1);

            // Calculate a dynamic height based on content or use Wrap to avoid rigid GridView aspect ratios.
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                _gatewayItem(
                  "Dharma & Sanskriti",
                  "Philosophy and Language",
                  Icons.menu_book,
                  4,
                  width,
                  crossAxisCount,
                ),
                _gatewayItem(
                  "Yoga & Meditation",
                  "Mindfulness and Practice",
                  Icons.self_improvement,
                  2,
                  width,
                  crossAxisCount,
                ),
                _gatewayItem(
                  "Vedic Education",
                  "Structured Learning",
                  Icons.school,
                  3,
                  width,
                  crossAxisCount,
                ),
                _gatewayItem(
                  "Media & Archives",
                  "Preserving Heritage",
                  Icons.collections,
                  7,
                  width,
                  crossAxisCount,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Individual gateway item with calculated width to fit the row.
  Widget _gatewayItem(
    String title,
    String desc,
    IconData icon,
    int pageIndex,
    double totalWidth,
    int count,
  ) {
    final double itemWidth = (totalWidth - (count - 1) * 24) / count;
    return SizedBox(
      width: itemWidth,
      height:
          320, // Provides a bounded height so Spacer() in _gatewayCard can work.
      child: _gatewayCard(title, desc, icon, pageIndex),
    );
  }

  Widget _gatewayCard(String title, String desc, IconData icon, int pageIndex) {
    return AppCardContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 24,
      onTap: () => widget.onTabSelected?.call(pageIndex),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box matching the design
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.lightPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.primary, size: 24),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.title.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          Text(desc, style: AppTextStyles.bodySmall),
          const Spacer(),
          const Text("Enter Portal →", style: AppTextStyles.link),
        ],
      ),
    );
  }

  Widget _buildPracticesSection(bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Stack sections vertically if the available width is too narrow for side-by-side display.
        if (constraints.maxWidth < 1000) {
          return Column(
            children: [
              _buildFeaturedPractice(),
              const SizedBox(height: 48),
              _buildDailyRegimen(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: _buildFeaturedPractice()),
            const SizedBox(width: 48),
            Expanded(flex: 4, child: _buildDailyRegimen()),
          ],
        );
      },
    );
  }

  // Large practice card with audio mockup
  Widget _buildFeaturedPractice() {
    return AppCardContainer(
      padding: const EdgeInsets.all(40),
      borderRadius: 32,
      backgroundColor: AppColor.cardBg,
      borderColor: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabelWithDot("FEATURED DAILY PRACTICE"),
          const SizedBox(height: 24),
          const Text(
            "Pratah Sandhya Dhyana:\nGayatri Prana Awakening",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          const Text(
            "An awakening dawn sequence incorporating breathing rituals and phonetic resonance rituals to build focused spiritual energy.",
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 40),
          // Audio mockup container
          AppCardContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 20,
            borderColor: null,
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColor.primary,
                  radius: 24,
                  child: Icon(Icons.play_arrow, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Guided Audio Tutorial",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // Progress bar mockup
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColor.primary.withAlpha(50),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text("12:45", style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Vertical list of regimen items
  Widget _buildDailyRegimen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabelWithDot("AYURVEDIC DAILY REGIMEN"),
        const SizedBox(height: 16),
        const Text(
          "Daily Regimen for Inner Stillness",
          style: AppTextStyles.subheading,
        ),
        const SizedBox(height: 24),
        _regimenItem(
          "Loha and Saurya Deepa Vidhi",
          "Traditional morning lamp lighting ritual.",
        ),
        _regimenItem(
          "Pranayama Awakening Practice",
          "Breathwork for energy activation.",
        ),
        _regimenItem(
          "Nadi Shodhana Pranayama",
          "Nerve cleansing breathing technique.",
        ),
      ],
    );
  }

  Widget _regimenItem(String title, String desc) {
    return AppCardContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColor.primary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(desc, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. SANSKRIT INTENSIVE BANNER ---
  Widget _buildSanskritBanner(bool isDesktop) {
    return AppCardContainer(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 60 : 32),
      borderRadius: 32,
      backgroundColor: const Color(0xFF2C1B10), // Deep brand brown
      borderColor: null,
      child: Column(
        children: [
          _buildSectionLabelWithDot(
            "ADMISSIONS OPEN • AUTUMN COHORT 2024",
            color: Colors.white70,
          ),
          const SizedBox(height: 24),
          Text(
            "Paninian Sanskrit Grammar & Vedic Chanting Intensive",
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 36 : 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "A structured 12-week immersive certificate program focused on foundational phonetics, grammar rules, and traditional chanting resonance.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: isDesktop ? 18 : 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AppButton(
            text: "Apply For Fellowship",
            onPressed: () {},
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSadhanaGallery(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 600;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: isNarrow
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabelWithDot("VISUAL SANCTUARY"),
                      const SizedBox(height: 16),
                      const Text(
                        "Living Moments of Sadhana",
                        style: AppTextStyles.heading2,
                      ),
                    ],
                  ),
                ),
                if (isDesktop && !isNarrow)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View Complete Gallery →",
                      style: AppTextStyles.link,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            // Stack gallery items if there is not enough room for side-by-side layout.
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _galleryCard(
                    "Brahma Muhurta Aarti at Triveni Ghat",
                    "assets/image_1.png",
                  ),
                  const SizedBox(height: 24),
                  _galleryCard(
                    "Grantha Codices & Japa Sadhana",
                    "assets/image_2.png",
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _galleryCard(
                    "Brahma Muhurta Aarti at Triveni Ghat",
                    "assets/image_1.png",
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _galleryCard(
                    "Grantha Codices & Japa Sadhana",
                    "assets/image_2.png",
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _galleryCard(String title, String imagePath) {
    return AppCardContainer(
      height: 400,
      borderRadius: 24,
      borderColor: null,
      image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withAlpha(200), Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. NEWSLETTER SUBSCRIPTION ---
  Widget _buildNewsletterSection(bool isDesktop) {
    return AppCardContainer(
      padding: EdgeInsets.all(isDesktop ? 60 : 32),
      borderRadius: 32,
      child: Column(
        children: [
          _buildSectionLabelWithDot("JOIN THE SEEKER SANGHA"),
          const SizedBox(height: 24),
          const Text(
            "Weekly Contemplative Darshan",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          const Text(
            "Receive Sunday Upanishad reflections, auspicious astronomical calendars, and sacred lifestyle guidance directly into your sanctuary inbox every week.",
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Stack vertically on narrow screens to prevent horizontal overflow.
                if (constraints.maxWidth < 450) {
                  return Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Your Email",
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: "Subscribe",
                          onPressed: () {},
                          isPrimary: true,
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter Your Email",
                          filled: true,
                          fillColor: AppColor.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
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
                      text: "Subscribe",
                      onPressed: () {},
                      isPrimary: true,
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

  // --- 7. COMPREHENSIVE FOOTER ---
  Widget _buildFooter(bool isDesktop) {
    return AppFooter(isDesktop: isDesktop);
  }

  // Section label with a small dot prefix
  Widget _buildSectionLabelWithDot(String text, {Color? color}) {
    return SectionLabel(text: text, color: color);
  }

  void _showWelcomePopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: AppCardContainer(
              backgroundColor: const Color(0xFFFCF8F2),
              borderRadius: 32,
              borderColor: null,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          const SizedBox(height: 16),

                          // Top Label
                          const SizedBox(height: 8),
                          const Text(
                            "Begin Your Contemplative Journey into the Vedas",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              fontFamily: 'Georgia',
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Preserving 3,000+ years of primordial oral transmission, sacred phonetics, and Vedic wisdom translated for daily mindful living.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withAlpha(160),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _buildPopupItem(
                            icon: Icons.waves,
                            title: "Daily Prātah Sādhana",
                            subtitle:
                                "Listen to 432Hz consecrated dawn chants & Vedic phonetics.",
                          ),
                          const SizedBox(height: 12),
                          _buildPopupItem(
                            icon: Icons.auto_stories,
                            title: "The Four Vedas Guide",
                            subtitle:
                                "An introductory handbook to the Samhitas, Brahmanas & Upanishads.",
                          ),
                          const SizedBox(height: 12),
                          _buildPopupItem(
                            icon: Icons.mail_outline,
                            title: "Join the Seeker Circle",
                            subtitle:
                                "Receive fortnightly Sandhya Patrika & lunar transit contemplations.",
                          ),
                          const SizedBox(height: 32),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Stack vertically on narrow viewports or large text scales.
                              if (constraints.maxWidth < 400) {
                                return Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter your email address",
                                        hintStyle: TextStyle(
                                          color: Colors.black.withAlpha(80),
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black.withAlpha(20),
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        text: "Book My Spot",
                                        onPressed: () => Navigator.pop(context),
                                        borderRadius: 30,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Enter your email address",
                                        hintStyle: TextStyle(
                                          color: Colors.black.withAlpha(80),
                                          fontSize: 14,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black.withAlpha(20),
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  AppButton(
                                    text: "Book My Spot",
                                    onPressed: () => Navigator.pop(context),
                                    borderRadius: 30,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.black54),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withAlpha(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return AppCardContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      backgroundColor: const Color(0xFFF7F2EB).withAlpha(150),
      borderColor: Colors.black.withAlpha(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E6D9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF8B5E3C)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withAlpha(140),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
