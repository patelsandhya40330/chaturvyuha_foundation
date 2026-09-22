import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
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
                // 1. HERO SECTION & TOP BAR
                _buildHeroSection(isDesktop),

                const SizedBox(height: 60),

                // 2. STATS BAR
                _buildStatsBar(isDesktop, constraints.maxWidth),

                const SizedBox(height: 80),

                // 3. VISION & MISSION
                _buildVisionMission(isDesktop),

                const SizedBox(height: 80),

                // 4. CORE PILLARS
                _buildCorePillars(isDesktop, constraints.maxWidth),

                const SizedBox(height: 80),

                // 5. TIMELINE
                _buildTimeline(isDesktop),

                const SizedBox(height: 80),

                // 6. MASTERS & SCHOLARS
                _buildTeamSection(isDesktop),

                const SizedBox(height: 80),

                // 7. SACRED EMBLEM (LOGO)
                _buildLogoSection(isDesktop),

                const SizedBox(height: 80),

                // 8. SERVICE & ORGANIZATION
                _buildOrgSection(isDesktop),

                const SizedBox(height: 80),

                // 9. CONNECT & INVOCATION
                _buildConnectSection(isDesktop),

                const SizedBox(height: 80),

                // 10. COMPREHENSIVE FOOTER
                _buildFooter(isDesktop),
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
          // Top Navigation / Breadcrumbs & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "About Us",
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
                    "• LIVING CANON • SACRED HERITAGE • 3000+ YEARS UNBROKEN LINEAGE",
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
                Expanded(flex: 6, child: _buildHeroLeft()),
                const SizedBox(width: 60),
                Expanded(flex: 4, child: _buildHeroRight(true)),
              ],
            )
          else
            Column(
              children: [
                _buildHeroLeft(),
                const SizedBox(height: 48),
                _buildHeroRight(false),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabelWithDot("ŚRĪ CHATURVEDA PRATIṢṬHĀNAM"),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: 48,
              height: 1.2,
            ),
            children: [
              const TextSpan(text: "Guarding Eternal Wisdom in\na "),
              TextSpan(
                text: "Rapidly Moving Age.",
                style: AppTextStyles.heroSubheading.copyWith(fontSize: 48),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "Chaturveda Foundation Sanctuary is an indigenous cultural, educational, and spiritual trust dedicated to the digital preservation of classical Sanskrit manuscripts, oral chant lineages, and universal Vedic sciences for researchers, practitioners, and seekers worldwide.",
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildHeroRight(bool isDesktop) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AppCardContainer(
          height: 400,
          width: double.infinity,
          borderRadius: 24,
          borderColor: null,
          image: const DecorationImage(
            image: AssetImage("assets/image_3.png"),
            fit: BoxFit.cover,
          ),
          child: const SizedBox.shrink(),
        ),
        // Archival Code Overlay
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(160),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ARCHIVAL CODE • TAL-0842",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Rigveda Śākala Saṁhitā Codices",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tala-patra Conservation Badge
        Positioned(
          bottom: -20,
          right: isDesktop ? -20 : 20,
          child: AppCardContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            backgroundColor: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tāla-patra Conservation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Archival grade vacuum seal",
                      style: TextStyle(color: AppColor.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. STATS BAR ---
  Widget _buildStatsBar(bool isDesktop, double maxWidth) {
    final stats = [
      {
        "label": "PRESERVATION SCALE",
        "value": "20,000+",
        "desc": "Manuscripts Digitized",
      },
      {
        "label": "LIVING LINEAGE",
        "value": "14",
        "desc": "Residential Gurukulas Sustained",
      },
      {
        "label": "SCHOLARLY EDITIONS",
        "value": "108",
        "desc": "Canonical Upanishad Commentaries",
      },
      {
        "label": "UNIVERSAL DHARMA",
        "value": "100%",
        "desc": "Non-Profit Open Access Commons",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: stats.map((s) {
          double width = isDesktop
              ? (maxWidth - 120 - 72) / 4
              : (maxWidth - 40 - 24) / 2;
          return AppCardContainer(
            width: width,
            padding: const EdgeInsets.all(24),
            backgroundColor: const Color(0xFFF9F6F1),
            borderRadius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s["label"]!,
                  style: AppTextStyles.bulletLabel.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 12),
                Text(
                  s["value"]!,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColor.primary,
                    fontSize: 32,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 4),
                Text(s["desc"]!, style: AppTextStyles.bodySmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- 3. VISION & MISSION ---
  Widget _buildVisionMission(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColor.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          _buildSectionLabelWithDot("PURPOSE & PATHWAY"),
          const SizedBox(height: 24),
          const Text(
            "Illuminating Consciousness Across Epochs.",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  child: _visionMissionCard(
                    "Our Vision",
                    "To cultivate an enlightened world community where timeless spiritual understanding acts as a guide for sustainable living.",
                    "VIEW VISION →",
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _visionMissionCard(
                    "Our Mission",
                    "To make spiritual learning, authentic Vedic education, and classical yoga accessible to all across the globe.",
                    "OUR VOW →",
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _visionMissionCard(
                  "Our Vision",
                  "To cultivate an enlightened world community where timeless spiritual understanding acts as a guide for sustainable living.",
                  "VIEW VISION →",
                ),
                const SizedBox(height: 24),
                _visionMissionCard(
                  "Our Mission",
                  "To make spiritual learning, authentic Vedic education, and classical yoga accessible to all across the globe.",
                  "OUR VOW →",
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _visionMissionCard(String title, String desc, String linkText) {
    return AppCardContainer(
      padding: const EdgeInsets.all(40),
      backgroundColor: const Color(0xFFFDFBF7),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColor.primary,
              size: 20,
            ),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: 16),
          Text(desc, style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          Text(linkText, style: AppTextStyles.link.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  // --- 4. CORE PILLARS ---
  Widget _buildCorePillars(bool isDesktop, double maxWidth) {
    final pillars = [
      {
        "title": "Scriptural Preservation",
        "desc":
            "Digitizing palm-leaf manuscripts and rare texts to protect the living lineage of knowledge.",
      },
      {
        "title": "Vedic Pedagogy",
        "desc":
            "Structured instruction in Sanskrit grammar, phonetics, and traditional hermeneutics.",
      },
      {
        "title": "Spiritual Sanctuary",
        "desc":
            "Providing a space for collective meditation, ritual arts, and inner contemplative silence.",
      },
      {
        "title": "Universal Dharma",
        "desc":
            "Translating ancient ethics into modern frameworks for ecological and social harmony.",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          _buildSectionLabelWithDot("THE FOUNDATION PIVOTS"),
          const SizedBox(height: 24),
          const Text(
            "The Four Pillars of Preservation & Empowerment",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: pillars.map((p) {
              double width = isDesktop
                  ? (maxWidth - 120 - 24) / 2
                  : maxWidth - 40;
              return AppCardContainer(
                width: width,
                padding: const EdgeInsets.all(32),
                backgroundColor: AppColor.white,
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PILLAR • 0${pillars.indexOf(p) + 1}",
                      style: AppTextStyles.bulletLabel.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 16),
                    Text(p["title"]!, style: AppTextStyles.title),
                    const SizedBox(height: 12),
                    Text(p["desc"]!, style: AppTextStyles.bodySmall),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- 5. TIMELINE ---
  Widget _buildTimeline(bool isDesktop) {
    final List<Map<String, dynamic>> timelineData = [
      {
        "year": "Anno 2012",
        "title": "The Inception at Kashi",
        "description":
            "A gathering of 18 revered Vedic scholars and manuscript conservators on Assi Ghat, Varanasi, recognizing the critical urgency of digitizing decaying Grantha and Devanagari codices.",
        "isLeft": true,
        "secondaryText": "Conclave of Assi Ghat • First archival pledge signed",
        "secondaryIcon": Icons.account_balance_outlined,
      },
      {
        "year": "Anno 2016",
        "title": "Formal Trust & First 1,000 Manuscripts",
        "description":
            "Registration of Chaturveda Foundation as a public charitable trust. Completion of the Rigveda Shakala Samhita audio master recording at 432Hz in pristine acoustic chambers.",
        "isLeft": false,
        "secondaryText": "Section 12A & 80G Indian Trust Registry",
        "secondaryIcon": Icons.verified_user_outlined,
      },
      {
        "year": "Anno 2019",
        "title": "Expansion to Himalayan Hermitage",
        "description":
            "Inauguration of the Rishikesh Ganga Hermitage for contemplative residential retreats, Brahmavihara sadhana, and classical Vedic phonetics workshops for global seekers.",
        "isLeft": true,
        "secondaryText": "Tapovan Sanctum established on holy riverbank",
        "secondaryIcon": Icons.landscape_outlined,
      },
      {
        "year": "Anno 2022",
        "title": "Global Digital Portal & AI Phonetic Analysis",
        "description":
            "Deployment of the open-access Vedic Wisdom digital portal, enabling global learners to study classical Udātta, Anudātta, and Svarita tonal recitation with real-time waveform guides.",
        "isLeft": false,
        "secondaryText": "Svara Waveform Acoustic Visualizer Launch",
        "secondaryIcon": Icons.graphic_eq,
      },
      {
        "year": "Anno 2026 • Present Goal",
        "title": "The Living Canon Initiative",
        "description":
            "Digitization surpasses 20,000 manuscripts; perpetual endowment funding secured for 14 rural residential gurukulas with zero commercial barrier for disciples.",
        "isLeft": true,
        "secondaryText": "100% Free Open Access Universal Commons achieved",
        "secondaryIcon": Icons.check_circle_outline,
      },
    ];

    return Container(
      width: double.infinity,
      color: AppColor.backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 100,
      ),
      child: Column(
        children: [
          // Elegant Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                color: AppColor.primary.withAlpha(100),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                "OUR JOURNEY & CHRONICLE",
                style: AppTextStyles.bulletLabel.copyWith(
                  letterSpacing: 3,
                  fontSize: 10,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 1,
                color: AppColor.primary.withAlpha(100),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "From Ancient Palm Leaves to the\nDigital Sanctuary",
            style: AppTextStyles.heading2.copyWith(
              fontFamily: 'Georgia',
              fontSize: isDesktop ? 48 : 32,
              height: 1.1,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),

          if (isDesktop)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Central Vertical Line
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: AppColor.primary.withAlpha(80),
                    ),
                  ),
                  // Timeline Items
                  Column(
                    children: timelineData
                        .map((data) => _buildEnhancedTimelineItem(data))
                        .toList(),
                  ),
                ],
              ),
            )
          else
            Column(
              children: timelineData
                  .map((data) => _buildMobileTimelineItem(data))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimelineItem(Map<String, dynamic> data) {
    final bool isLeft = data['isLeft'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side
          Expanded(
            child: isLeft
                ? _buildMainContent(
                    data,
                    CrossAxisAlignment.end,
                    TextAlign.right,
                  )
                : _buildSecondaryContent(data, MainAxisAlignment.end),
          ),

          // Center Marker
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
              color: AppColor.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppCardContainer(
                width: 12,
                height: 12,
                shape: BoxShape.circle,
                backgroundColor: AppColor.primary,
                borderColor: AppColor.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primary.withAlpha(80),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                child: const SizedBox.shrink(),
              ),
            ),
          ),

          // Right Side
          Expanded(
            child: !isLeft
                ? _buildMainContent(
                    data,
                    CrossAxisAlignment.start,
                    TextAlign.left,
                  )
                : _buildSecondaryContent(data, MainAxisAlignment.start),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    Map<String, dynamic> data,
    CrossAxisAlignment crossAlign,
    TextAlign textAlign,
  ) {
    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E6D9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            data['year'],
            style: AppTextStyles.bulletLabel.copyWith(
              fontSize: 10,
              color: const Color(0xFF8B5E3C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          data['title'],
          style: AppTextStyles.title.copyWith(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColor.heading,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 12),
        Text(
          data['description'],
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 14,
            height: 1.6,
            color: AppColor.bodyText.withAlpha(200),
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }

  Widget _buildSecondaryContent(
    Map<String, dynamic> data,
    MainAxisAlignment mainAlign,
  ) {
    return Row(
      mainAxisAlignment: mainAlign,
      children: [
        AppCardContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          backgroundColor: const Color(0xFFF7F2EB),
          borderRadius: 12,
          borderColor: AppColor.border.withAlpha(120),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                data['secondaryIcon'],
                size: 20,
                color: AppColor.primary.withAlpha(150),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  data['secondaryText'],
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.bodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTimelineItem(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainContent(data, CrossAxisAlignment.start, TextAlign.left),
          const SizedBox(height: 24),
          _buildSecondaryContent(data, MainAxisAlignment.start),
          const SizedBox(height: 24),
          const Divider(),
        ],
      ),
    );
  }

  // --- 6. MASTERS & SCHOLARS ---
  Widget _buildTeamSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          _buildSectionLabelWithDot("LINEAGE KEEPERS"),
          const SizedBox(height: 24),
          const Text(
            "Guided By Masters, Stewarded by Scholars",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _teamMemberCard(
                  "Acharya Shridhar",
                  "Director",
                  "assets/image_1.png",
                ),
                const SizedBox(width: 40),
                _teamMemberCard(
                  "Dr. Ananya Mishra",
                  "Vedic Research",
                  "assets/image_2.png",
                ),
                const SizedBox(width: 40),
                _teamMemberCard(
                  "Swami Vedananda",
                  "Meditation",
                  "assets/image_3.png",
                ),
                const SizedBox(width: 40),
                _teamMemberCard(
                  "Prof. Gupta",
                  "Archives",
                  "assets/image_1.png",
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          AppCardContainer(
            padding: const EdgeInsets.all(40),
            backgroundColor: const Color(0xFFF9F6F1),
            borderRadius: 24,
            child: const Text(
              "Our team comprises traditional Sanskrit scholars, professional archivists, and spiritual guides working in harmony to bridge ancient wisdom with modern technology.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamMemberCard(String name, String role, String img) {
    return Column(
      children: [
        AppCardContainer(
          width: 140,
          height: 140,
          shape: BoxShape.circle,
          image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover),
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        Text(name, style: AppTextStyles.title.copyWith(fontSize: 16)),
        Text(role, style: AppTextStyles.bulletLabel),
      ],
    );
  }

  // --- 7. SACRED EMBLEM ---
  Widget _buildLogoSection(bool isDesktop) {
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Row(
        children: [
          if (isDesktop) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(60),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDFBF7),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "assets/chaturvedal-logo.png",
                  color: AppColor.primary,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(width: 80),
          ],
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabelWithDot("THE SYMBOLISM"),
                const SizedBox(height: 24),
                const Text(
                  "The Sacred Emblem: A Root Seal",
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 24),
                const Text(
                  "The official seal of the Chaturveda Foundation encapsulates the infinite cycle of wisdom. The central motif represents the union of the four Vedas, while the surrounding geometry signifies the protective embrace of the community and the continuity of the sacred lineage.",
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: "Identity Guidelines",
                  onPressed: () {},
                  isPrimary: false,
                  showIcon: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 8. SERVICE & ORGANIZATION ---
  Widget _buildOrgSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          _buildSectionLabelWithDot("BHAKTI & SEVA"),
          const SizedBox(height: 24),
          const Text(
            "Vedic Art Based in Service of the Sacred",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _orgInfoCard(
                "Cultural Integrity",
                "Strict adherence to traditional methods of preservation and oral transmission.",
              ),
              _orgInfoCard(
                "Digital Inclusivity",
                "Ensuring global access to sacred texts for scholarly and personal growth.",
              ),
              _orgInfoCard(
                "Spiritual Service",
                "A non-profit trust dedicated to the welfare of the collective consciousness.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orgInfoCard(String title, String desc) {
    return AppCardContainer(
      width: 350,
      padding: const EdgeInsets.all(32),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: AppColor.primary, size: 8),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.title),
          const SizedBox(height: 12),
          Text(desc, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  // --- 9. CONNECT SECTION ---
  Widget _buildConnectSection(bool isDesktop) {
    return Container(
      color: AppColor.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 100,
      ),
      child: Column(
        children: [
          _buildSectionLabelWithDot("INVOCATION"),
          const SizedBox(height: 24),
          const Text(
            "Connect with the Sanctuary",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 60),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildContactInfo()),
                const SizedBox(width: 80),
                Expanded(child: _buildContactForm()),
              ],
            )
          else
            Column(
              children: [
                _buildContactInfo(),
                const SizedBox(height: 60),
                _buildContactForm(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Seeking deeper engagement or have a specific inquiry about our archives?",
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 40),
        _contactItem(
          Icons.email_outlined,
          "Email the Registrar",
          "archives@chaturvyuha.org",
        ),
        const SizedBox(height: 24),
        _contactItem(
          Icons.phone_outlined,
          "General Inquiry",
          "+91 98765 43210",
        ),
        const SizedBox(height: 24),
        _contactItem(
          Icons.location_on_outlined,
          "The Main Sanctuary",
          "Rishikesh, Uttarakhand, India",
        ),
      ],
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColor.primary, size: 24),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bulletLabel),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: "Full Name",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: "Email Address",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Your Message",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: "Initiate Dialogue",
              onPressed: () {},
              isPrimary: true,
              showIcon: false,
            ),
          ),
        ],
      ),
    );
  }

  // --- 10. COMPREHENSIVE FOOTER ---
  Widget _buildFooter(bool isDesktop) {
    return Container(
      color: const Color(0xFFF9F6F1),
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
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 16,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "info@chaturvyuha.org",
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "+1 (555) 012-3456",
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              _socialIcon(Icons.facebook),
                              const SizedBox(width: 12),
                              _socialIcon(Icons.camera_alt_outlined),
                              const SizedBox(width: 12),
                              _socialIcon(Icons.smart_display_outlined),
                            ],
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
                  const Text(
                    "© 2024 Chaturveda Foundation. All Rights Reserved.",
                    style: AppTextStyles.caption,
                  ),
                  if (isDesktop)
                    const Row(
                      children: [
                        Text("Privacy Policy", style: AppTextStyles.caption),
                        SizedBox(width: 24),
                        Text("Terms of Service", style: AppTextStyles.caption),
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

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.primary.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColor.primary, size: 20),
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Column(
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
    );
  }

  // --- REUSABLE UI HELPERS ---
  Widget _buildSectionLabelWithDot(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Color(0xFFC19A6B),
          ),
        ),
      ],
    );
  }
}
