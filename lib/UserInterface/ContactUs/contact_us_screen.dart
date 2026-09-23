import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _inquiryTypeController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _inquiryTypeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Scroll smoothly to the contact form section
  void _scrollToForm() {
    _scrollController.animateTo(
      180,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  // Submit Inquiry Form
  Future<void> _submitInquiry() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Inquiry successfully dispatched! Thank you, ${_nameController.text.trim()}. Our registrar will reply shortly.",
          ),
          backgroundColor: AppColor.primary,
        ),
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _inquiryTypeController.clear();
      _messageController.clear();
    }
  }

  // Image Preview Dialog
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
                // 1. HERO & TOP BAR
                _buildHeroSection(isDesktop),

                const SizedBox(height: 60),

                // 2. INQUIRY FORM & SIDEBAR
                _buildInquiryAndSidebar(isDesktop, constraints.maxWidth),

                const SizedBox(height: 120),

                // 3. ASHRAM DEPARTMENT DIRECTORY
                _buildDepartmentDirectory(isDesktop, constraints.maxWidth),

                const SizedBox(height: 120),

                // 4. THREE SACRED SANCTUARIES
                _buildSacredSanctuaries(isDesktop, constraints.maxWidth),

                const SizedBox(height: 120),

                // 5. TRANSIT COORDINATION BANNER
                _buildTransitBanner(isDesktop),

                const SizedBox(height: 100),

                // 6. FOOTER
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
          const SizedBox(height: 32),
          Image.asset(
            "assets/chaturvedal-logo.png",
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          const SectionLabel(text: "GLOBAL REACH & SUPPORT"),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: AppTextStyles.heroHeading.copyWith(
                fontSize: isDesktop ? 54 : 36,
                height: 1.1,
              ),
              children: [
                const TextSpan(text: "Connect With the "),
                TextSpan(
                  text: "Sanctuary of Eternal\nLight",
                  style: AppTextStyles.heroSubheading.copyWith(
                    fontSize: isDesktop ? 54 : 36,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'Whether you seek spiritual guidance, access to archival codices, or wish to support our mission, our global ashram network is dedicated to providing timely and compassionate responses to every earnest inquiry.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
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
          "Contact & Support",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- 2. INQUIRY FORM & SIDEBAR ---
  Widget _buildInquiryAndSidebar(bool isDesktop, double maxWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use Row only when there's enough horizontal space to avoid crowding content.
          if (constraints.maxWidth >= 1000) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: _buildContactForm()),
                const SizedBox(width: 48),
                Expanded(flex: 4, child: _buildContactSidebar()),
              ],
            );
          }
          return Column(
            children: [
              _buildContactForm(),
              const SizedBox(height: 60),
              _buildContactSidebar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactForm() {
    return AppCardContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel(text: "ASHRAM DISPATCH"),
            const SizedBox(height: 16),
            const Text("Seeker Inquiry Form", style: AppTextStyles.heading2),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, box) {
                bool isWide = box.maxWidth > 500;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              controller: _nameController,
                              label: "Full Name *",
                              hint: "e.g. Shridhar Sharma",
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter your name'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildFormField(
                              controller: _emailController,
                              label: "Email Address *",
                              hint: "name@example.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildFormField(
                            controller: _nameController,
                            label: "Full Name *",
                            hint: "e.g. Shridhar Sharma",
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter your name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            controller: _emailController,
                            label: "Email Address *",
                            hint: "name@example.com",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || !v.contains('@'))
                                ? 'Please enter a valid email'
                                : null,
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, box) {
                bool isWide = box.maxWidth > 500;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildFormField(
                              controller: _phoneController,
                              label: "Contact Number (Optional)",
                              hint: "+91 98765 43210",
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildFormField(
                              controller: _inquiryTypeController,
                              label: "Nature of Inquiry",
                              hint: "General Spiritual Guidance",
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildFormField(
                            controller: _phoneController,
                            label: "Contact Number (Optional)",
                            hint: "+91 98765 43210",
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            controller: _inquiryTypeController,
                            label: "Nature of Inquiry",
                            hint: "General Spiritual Guidance",
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 20),
            _buildFormField(
              controller: _messageController,
              label: "Message / Philosophical Inquiry *",
              hint: "Type your message here...",
              maxLines: 5,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your message'
                  : null,
            ),
            const SizedBox(height: 40),
            AppButton(
              text: _isSubmitting ? "Dispatching..." : "Dispatch Inquiry",
              onPressed: _isSubmitting ? () {} : _submitInquiry,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          minLines: 1,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.black26),
            filled: true,
            fillColor: const Color(0xFFF9F6F1),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10, // Reduce this for a shorter field.
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSidebar() {
    return Column(
      children: [
        // Helpline Card
        AppCardContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 24,
          backgroundColor: AppColor.primary,
          borderColor: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TRANSIT HELPLINE",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.phone_in_talk,
                    color: Colors.white.withAlpha(150),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "24/7 Spiritual & Ashram Assistance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Calling Ashram Helpline (+91 0 587 266 15)...',
                      ),
                    ),
                  );
                },
                child: const Text(
                  "+91 (0) 587 266 15",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Call for urgent sanctuary admission or transit coordination.",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Address Card
        AppCardContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _contactInfoRow(
                Icons.location_on_outlined,
                "THE MAIN SANCTUARY",
                "108 Vedic Enclave, Cultural District\nRishikesh, Uttarakhand 249201",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening Rishikesh Sanctuary on Map...'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              _contactInfoRow(
                Icons.email_outlined,
                "REGISTRAR EMAIL",
                "archives@chaturvyuha.org",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Email client opened for archives@chaturvyuha.org',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Tags Card
        AppCardContainer(
          padding: const EdgeInsets.all(32),
          borderRadius: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("CANONICAL FEED", style: AppTextStyles.bulletLabel),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          "Service",
                          "Heritage",
                          "Sadhana",
                          "Manuscripts",
                          "Pilgrimage",
                        ]
                        .map(
                          (tag) => InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Filtered canonical feed by $tag',
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1E6D9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactInfoRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primary, size: 24),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bulletLabel.copyWith(fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. ASHRAM DEPARTMENT DIRECTORY ---
  Widget _buildDepartmentDirectory(bool isDesktop, double maxWidth) {
    final departments = [
      {
        "icon": Icons.support_agent,
        "title": "Seeker Support & Helpline",
        "desc":
            "Assistance for new practitioners, sanctuary visits, and general spiritual inquiries.",
      },
      {
        "icon": Icons.gavel,
        "title": "Acharya Council (Advisory)",
        "desc":
            "Contact for formal manuscript research approval and lineage validation requests.",
      },
      {
        "icon": Icons.school_outlined,
        "title": "Vidya Pathashala Admissions",
        "desc":
            "Questions regarding Gurukula enrollment, curriculum dates, and youth programs.",
      },
      {
        "icon": Icons.favorite_border,
        "title": "Seva & Philanthropy Hub",
        "desc":
            "Discussing sanctuary maintenance support, Goshala seva, and non-profit initiatives.",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "ASHRAM HIERARCHY"),
          const SizedBox(height: 24),
          const Text(
            "Ashram Department Directory",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: departments.map((d) {
              double width = isDesktop
                  ? (maxWidth - 120 - 24) / 2
                  : maxWidth - 40;
              return AppCardContainer(
                width: width,
                padding: const EdgeInsets.all(32),
                borderRadius: 24,
                backgroundColor: Colors.white,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Connecting to ${d["title"]}...')),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1E6D9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        d["icon"] as IconData,
                        color: AppColor.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d["title"]! as String,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 18,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            d["desc"]! as String,
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Contact Department →",
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

  // --- 4. THREE SACRED SANCTUARIES ---
  Widget _buildSacredSanctuaries(bool isDesktop, double maxWidth) {
    final sanctuaries = [
      {
        "img": "assets/image_1.png",
        "tag": "RISHIKESH • HEADQUARTERS",
        "name": "Tapovan Ganga Sanctuary",
        "desc":
            "The primary seat of archival preservation and advanced Sanskrit linguistics on the holy riverbanks.",
      },
      {
        "img": "assets/image_2.png",
        "tag": "VARANASI • RESEARCH",
        "name": "Kashi Moksha Ashram",
        "desc":
            "Dedicated to the study of Advaita Vedanta and the digitization of rare Devanagari manuscripts.",
      },
      {
        "img": "assets/image_3.png",
        "tag": "GOKARNA • COASTAL SANCTUM",
        "name": "Gokarna Vedic Atma",
        "desc":
            "Focusing on the performance of traditional Vedic rituals and oral transmission along the Arabian Sea.",
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "LOCATIONS & CENTERS"),
          const SizedBox(height: 24),
          const Text(
            "Our Three Sacred Sanctuaries",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: sanctuaries.map((s) {
              double width = isDesktop
                  ? (maxWidth - 120 - 48) / 3
                  : maxWidth - 40;
              return AppCardContainer(
                width: width,
                padding: EdgeInsets.zero,
                borderRadius: 24,
                clipBehavior: Clip.antiAlias,
                onTap: () => _showImagePreview(s["img"]!, s["name"]!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      s["img"]!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s["tag"]!,
                            style: AppTextStyles.bulletLabel.copyWith(
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s["name"]!,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 22,
                              fontFamily: 'Georgia',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s["desc"]!,
                            style: AppTextStyles.bodySmall.copyWith(
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 16,
                                color: AppColor.primary,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "View Ashram on Maps →",
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
          ),
        ],
      ),
    );
  }

  // --- 5. TRANSIT COORDINATION BANNER ---
  Widget _buildTransitBanner(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: AppCardContainer(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
        borderRadius: 24,
        backgroundColor: const Color(0xFFF1E6D9),
        borderColor: null,
        child: LayoutBuilder(
          builder: (context, box) {
            bool isWide = box.maxWidth > 700;
            return isWide
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.commute,
                          color: AppColor.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 32),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TRANSIT & PILGRIMAGE",
                              style: AppTextStyles.bulletLabel,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Vedic Transit & Pilgrimage Coordination",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Assisting international seekers with local travel, stay, and documentation for sanctuary visits.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      AppButton(
                        text: "Start Travel Dialogue",
                        onPressed: _scrollToForm,
                        isPrimary: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.commute,
                              color: AppColor.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "Vedic Transit & Pilgrimage Coordination",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Assisting international seekers with local travel, stay, and documentation for sanctuary visits.",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          text: "Start Travel Dialogue",
                          onPressed: _scrollToForm,
                          isPrimary: true,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
