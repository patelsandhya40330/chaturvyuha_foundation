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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 20,
                vertical: 40,
              ),
              child: Column(
                children: [
                  // HERO SECTION
                  _buildHeroSection(isDesktop),

                  const SizedBox(height: 80),

                  // TODO: Add other sections (Purpose, Yoga, Education) matched to design
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Content
          Expanded(flex: 6, child: _buildHeroLeftContent()),
          const SizedBox(width: 60),
          // Right Card
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
        // Tagline: WISDOM • WELLNESS • COMMUNITY
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFC19A6B),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "WISDOM • WELLNESS • COMMUNITY",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFFC19A6B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Main Heading
        const Text("Ancient Wisdom.", style: AppTextStyles.heroHeading),
        const Text("A Meaningful Life.", style: AppTextStyles.heroSubheading),

        const SizedBox(height: 32),

        // Description
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: const Text(
            "Discover classical Vedic learning, mindful yoga sciences, and indigenous cultural traditions crafted to inspire balanced human potential and unite a conscious seeker collective.",
            style: AppTextStyles.bodyLarge,
          ),
        ),

        const SizedBox(height: 48),

        // Buttons
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
      ],
    );
  }

  Widget _buildHeroRightCard() {
    return Container(
      width: double.infinity,
      height: 450, // Fixed height for the hero image container
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _heroImages.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
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
          if (isPrimary) ...[
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward, size: 18),
          ],
          if (!isPrimary) ...[
            const SizedBox(width: 12),
            const Icon(Icons.explore_outlined, size: 18),
          ],
        ],
      ),
    );
  }
}
