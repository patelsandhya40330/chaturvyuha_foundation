import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Asynchronous contact dialogue form submission
  Future<void> _submitContactForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      // Asynchronous network simulation delay
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inquiry received from ${_nameController.text.trim()}. Our registrar will respond via email shortly.',
          ),
          backgroundColor: AppColor.primary,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  // Interactive Information Dialog for Mission, Vision, and Identity
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
                      tooltip: 'Close Information',
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

                // 7. SACRED EMBLEM
                _buildLogoSection(isDesktop),

                const SizedBox(height: 80),

                // 8. SERVICE & ORGANIZATION
                _buildOrgSection(isDesktop),

                const SizedBox(height: 80),

                // 9. CONNECT & INVOCATION
                _buildConnectSection(isDesktop),

                const SizedBox(height: 80),

                // 10. FOOTER
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "About Us",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
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
        const SectionLabel(text: "ŚRĪ CHATURVEDA PRATIṢṬHĀNAM"),
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
          onTap: () => _showImagePreview(
            "assets/image_3.png",
            "Rigveda Śākala Saṁhitā Codices",
          ),
          image: const DecorationImage(
            image: AssetImage("assets/image_3.png"),
            fit: BoxFit.cover,
          ),
          child: const SizedBox.shrink(),
        ),
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
          const SectionLabel(text: "PURPOSE & PATHWAY"),
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
                    "To cultivate an enlightened world community where timeless spiritual understanding acts as a guide for sustainable living, unity, and shared social welfare. We aim to preserve over 20,000 digitized manuscripts, sustain traditional residential gurukulas, and provide open-access knowledge to seekers across the globe without financial barriers.",
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _visionMissionCard(
                    "Our Mission",
                    "To make spiritual learning, authentic Vedic education, and classical yoga accessible to all across the globe.",
                    "OUR VOW →",
                    "To make spiritual learning, authentic Vedic education, classical yoga, and traditional languages fully accessible to individuals across all classes, castes, and backgrounds. Our vow is to protect the oral chanting lineages, maintain the accuracy of manuscript transcriptions, and offer daily sadhana practices for global harmony.",
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
                  "To cultivate an enlightened world community where timeless spiritual understanding acts as a guide for sustainable living, unity, and shared social welfare. We aim to preserve over 20,000 digitized manuscripts, sustain traditional residential gurukulas, and provide open-access knowledge to seekers across the globe without financial barriers.",
                ),
                const SizedBox(height: 24),
                _visionMissionCard(
                  "Our Mission",
                  "To make spiritual learning, authentic Vedic education, and classical yoga accessible to all across the globe.",
                  "OUR VOW →",
                  "To make spiritual learning, authentic Vedic education, classical yoga, and traditional languages fully accessible to individuals across all classes, castes, and backgrounds. Our vow is to protect the oral chanting lineages, maintain the accuracy of manuscript transcriptions, and offer daily sadhana practices for global harmony.",
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _visionMissionCard(
    String title,
    String desc,
    String linkText,
    String fullDetails,
  ) {
    return AppCardContainer(
      padding: const EdgeInsets.all(40),
      backgroundColor: const Color(0xFFFDFBF7),
      borderRadius: 24,
      onTap: () => _showInfoDialog(title, fullDetails),
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
          const SectionLabel(text: "THE FOUNDATION PIVOTS"),
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
    return const SizedBox.shrink();
  }

  // --- 6. MASTERS & SCHOLARS ---
  Widget _buildTeamSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          const SectionLabel(text: "LINEAGE KEEPERS"),
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
              ],
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
          onTap: () => _showImagePreview(img, name),
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
                const SectionLabel(text: "THE SYMBOLISM"),
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
                  onPressed: () => _showInfoDialog(
                    "Identity Guidelines - The Sacred Seal",
                    "The official seal of the Chaturveda Foundation encapsulates the infinite cycle of wisdom. The central motif represents the union of the four Vedas, while the surrounding geometry signifies the protective embrace of the community and the continuity of the sacred lineage. Usage of this emblem is restricted to official non-profit publications and consecrated study materials.",
                  ),
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
          const SectionLabel(text: "BHAKTI & SEVA"),
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
          const SectionLabel(text: "INVOCATION"),
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Full Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Email Address",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              validator: (value) => (value == null || !value.contains('@'))
                  ? 'Please enter a valid email'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Your Message",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter your message'
                  : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: _isSubmitting ? "Sending..." : "Initiate Dialogue",
                onPressed: _isSubmitting ? () {} : _submitContactForm,
                isPrimary: true,
                showIcon: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
