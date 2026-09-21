import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;
  const HomeScreen({super.key, this.onTabSelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
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
    // Auto-scroll the slideshow every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentImageIndex < _heroImages.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentImageIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
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
          final bool isDesktop = constraints.maxWidth >= 1000;
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
        Row(
          children: [
            _actionButton(
              text: "Become a Member",
              onPressed: () => widget.onTabSelected?.call(9),
              isPrimary: true,
            ),
            const SizedBox(width: 20),
            _actionButton(
              text: "Explore Pathways",
              onPressed: () {},
              isPrimary: false,
            ),
          ],
        ),
        const SizedBox(height: 48),
        _buildSocialProofBar(),
      ],
    );
  }

  Widget _buildHeroRightCard() {
    return Container(
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _heroImages.length,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
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
        // Flexible grid: 4 columns on desktop, responsive on mobile
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = isDesktop
                ? 4
                : (constraints.maxWidth > 600 ? 2 : 1);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: isDesktop ? 0.75 : 1.2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              children: [
                _gatewayCard(
                  "Dharma & Sanskriti",
                  "Philosophy and Language",
                  Icons.menu_book,
                  2,
                ),
                _gatewayCard(
                  "Yoga & Meditation",
                  "Mindfulness and Practice",
                  Icons.self_improvement,
                  3,
                ),
                _gatewayCard(
                  "Vedic Education",
                  "Structured Learning",
                  Icons.school,
                  4,
                ),
                _gatewayCard(
                  "Media & Archives",
                  "Preserving Heritage",
                  Icons.collections,
                  7,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _gatewayCard(String title, String desc, IconData icon, int pageIndex) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.border),
      ),
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
          TextButton(
            onPressed: () => widget.onTabSelected?.call(pageIndex),
            child: const Text("Enter Portal →", style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }

  // --- 3. PRACTICES SECTION (FEATURED + REGIMEN) ---
  Widget _buildPracticesSection(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 6, child: _buildFeaturedPractice()),
          const SizedBox(width: 48),
          Expanded(flex: 4, child: _buildDailyRegimen()),
        ],
      );
    }
    return Column(
      children: [
        _buildFeaturedPractice(),
        const SizedBox(height: 48),
        _buildDailyRegimen(),
      ],
    );
  }

  // Large practice card with audio mockup
  Widget _buildFeaturedPractice() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(32),
      ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 60 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1B10), // Deep brand brown
        borderRadius: BorderRadius.circular(32),
      ),
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
          _actionButton(
            text: "Apply For Fellowship",
            onPressed: () {},
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // --- 5. VISUAL SANCTUARY (GALLERY) ---
  Widget _buildSadhanaGallery(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
            if (isDesktop)
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View Complete Gallery →",
                  style: AppTextStyles.link,
                ),
              ),
          ],
        ),
        const SizedBox(height: 48),
        if (isDesktop)
          Row(
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
          )
        else
          Column(
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
          ),
      ],
    );
  }

  Widget _galleryCard(String title, String imagePath) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
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
    return Container(
      padding: EdgeInsets.all(isDesktop ? 60 : 32),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColor.border),
      ),
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
            child: Row(
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
                _actionButton(
                  text: "Subscribe",
                  onPressed: () {},
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 7. COMPREHENSIVE FOOTER ---
  Widget _buildFooter(bool isDesktop) {
    return Container(
      color: const Color(0xFFF9F6F1), // Slight tint footer background
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chaturveda Foundations",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Preserving ancient Vedic knowledge and cultural heritage for a harmonious and balanced society.",
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    _footerColumn("WISDOM WINGS", [
                      "The Upanishads",
                      "Daily Rituals",
                      "Vedic Research",
                      "Archival Library",
                    ]),
                    _footerColumn("SANCTUARY & SEVA", [
                      "Cultural Calendar",
                      "Goshala Seva",
                      "Community Meals",
                      "Sanctuary Maintenance",
                    ]),
                    _footerColumn("PANINI PATHSHALA", [
                      "Foundation Learning",
                      "Advanced Grammar",
                      "Chanting Academy",
                      "Youth Programs",
                    ]),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Chaturveda Foundations",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Preserving ancient Vedic knowledge and cultural heritage.",
                    ),
                    const SizedBox(height: 48),
                    _footerColumn("WISDOM WINGS", [
                      "The Upanishads",
                      "Daily Rituals",
                    ]),
                    _footerColumn("SANCTUARY & SEVA", [
                      "Cultural Calendar",
                      "Goshala Seva",
                    ]),
                  ],
                ),
              const SizedBox(height: 80),
              const Divider(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "© 2024 Chaturveda Foundation. All Rights Reserved.",
                      style: AppTextStyles.caption,
                    ),
                  ),
                  if (isDesktop)
                    Row(
                      children: [
                        const Text(
                          "Privacy Policy",
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(width: 24),
                        const Text(
                          "Terms of Service",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          ...links.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(link, style: AppTextStyles.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE UI HELPERS ---

  // Section label with a small dot prefix
  Widget _buildSectionLabelWithDot(String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color ?? const Color(0xFFC19A6B),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: color ?? const Color(0xFFC19A6B),
          ),
        ),
      ],
    );
  }

  // Overlapping avatar bar for social proof
  Widget _buildSocialProofBar() {
    return Row(
      children: [
        for (int i = 0; i < 3; i++)
          Align(
            widthFactor: 0.7,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFF2EEE7),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppColor.primary.withAlpha(128),
              ),
            ),
          ),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColor.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              "+12k",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            "Rooted in tradition, guided by wisdom. Over 12,000+ seekers worldwide.",
            style: TextStyle(color: AppColor.bodyText, fontSize: 13),
          ),
        ),
      ],
    );
  }

  // Primary and secondary action buttons
  Widget _actionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppColor.primary : const Color(0xFFF2EEE7),
        foregroundColor: isPrimary ? Colors.white : AppColor.heading,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Icon(
            isPrimary ? Icons.arrow_forward : Icons.explore_outlined,
            size: 18,
          ),
        ],
      ),
    );
  }
}
