import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/membership_provider.dart';

class BecomeMemberScreen extends StatefulWidget {
  const BecomeMemberScreen({super.key});

  @override
  State<BecomeMemberScreen> createState() => _BecomeMemberScreenState();
}

class _BecomeMemberScreenState extends State<BecomeMemberScreen> {
  bool _isLoginMode = false;

  // Form keys & controllers
  final _enrollFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final _legalNameController = TextEditingController();
  final _spiritualNameController = TextEditingController();
  final _enrollEmailController = TextEditingController();
  final _enrollPhoneController = TextEditingController();
  final _enrollPasswordController = TextEditingController();

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Selections & state flags

  String _selectedStream = "Vedic Chanting (Mantra Ganaveda)";
  String _selectedSanctuary = "Rishikesh — Tapovan Ghat Kutir";
  bool _affirmedProtocol = false;
  bool _rememberMe = true;

  bool _isEnrollPasswordVisible = false;
  bool _isSignInPasswordVisible = false;
  bool _isEnrollSubmitting = false;
  bool _isSignInSubmitting = false;

  final List<String> _sacredStreams = [
    "Vedic Chanting (Mantra Ganaveda)",
    "Upanishadic Hermeneutics",
    "Pāṇinian Sanskrit Vyākaraṇa",
    "Classical Hatha & Rāja Yoga",
  ];

  final List<String> _sanctuaries = [
    "Rishikesh — Tapovan Ghat Kutir",
    "Varanasi — Assi Ghat Hermitage",
    "Gokarna — Om Beach Sanctum",
  ];

  @override
  void dispose() {
    _legalNameController.dispose();
    _spiritualNameController.dispose();
    _enrollEmailController.dispose();
    _enrollPhoneController.dispose();
    _enrollPasswordController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  // Submit Enrollment
  Future<void> _submitEnrollmentForm() async {
    if (!_affirmedProtocol) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please affirm the ashram Sadhana protocol pledge to proceed.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_enrollFormKey.currentState!.validate()) {
      setState(() => _isEnrollSubmitting = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isEnrollSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enrollment submitted for ${_legalNameController.text.trim()}! Confirmation sent to ${_enrollEmailController.text.trim()}.',
          ),
          backgroundColor: AppColor.primary,
        ),
      );
      _legalNameController.clear();
      _spiritualNameController.clear();
      _enrollEmailController.clear();
      _enrollPhoneController.clear();
      _enrollPasswordController.clear();
    }
  }

  // Submit Sign In
  Future<void> _submitSignInForm() async {
    if (_signInFormKey.currentState!.validate()) {
      setState(() => _isSignInSubmitting = true);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _isSignInSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome back to the Sacred Portal, ${_signInEmailController.text.trim()}!',
          ),
          backgroundColor: AppColor.primary,
        ),
      );
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
    final membershipProvider = context.watch<MembershipProvider>();

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

                const SizedBox(height: 60),

                // 2. MAIN PORTAL
                _buildMainPortal(isDesktop),

                const SizedBox(height: 120),

                const SizedBox(height: 120),

                // 4. FAQ SECTION
                _buildFAQSection(isDesktop, membershipProvider),

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
          Image.asset(
            "assets/chaturvedal-logo.png",
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          const SectionLabel(text: "INITIATION & SANGHA PORTAL"),
          const SizedBox(height: 24),
          Text(
            'Walk the Path of Living Wisdom — Member\nSanctuary',
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: isDesktop ? 54 : 36,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'Whether stepping into the sacred circle for the first time or returning to continue your daily Sadhana, enter with reverence into an unbroken Gurukula tradition.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. MAIN PORTAL ---
  Widget _buildMainPortal(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          // Mode Toggles
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            children: [
              _portalTab(
                "Initiation & New Memberships",
                !_isLoginMode,
                () => setState(() => _isLoginMode = false),
                Icons.person_add_alt_1_outlined,
              ),
              _portalTab(
                "Returning Member Sign-In",
                _isLoginMode,
                () => setState(() => _isLoginMode = true),
                Icons.login_outlined,
              ),
            ],
          ),
          const SizedBox(height: 48),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _buildPrivilegesList()),
                const SizedBox(width: 80),
                Expanded(
                  flex: 6,
                  child: _isLoginMode
                      ? _buildSignInForm()
                      : _buildEnrollmentForm(),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildPrivilegesList(),
                const SizedBox(height: 60),
                _isLoginMode ? _buildSignInForm() : _buildEnrollmentForm(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _portalTab(
    String text,
    bool isActive,
    VoidCallback onTap,
    IconData icon,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? AppColor.primary : AppColor.border,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColor.primary.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivilegesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: "SACRED PRIVILEGES"),
        const SizedBox(height: 16),
        const Text("Why Enter the Sanctuary?", style: AppTextStyles.heading2),
        const SizedBox(height: 24),
        const Text(
          "Every member is a respected active Guru, who joins the sacred heart of the Vedic community, preserved by fast practice into authority.",
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 40),
        _privilegeItem(
          Icons.history_edu,
          "Unbroken Gurukula Lineage",
          "Live daily Ganga Arati streaming, scholarly broadcasts from the ashram, and traditional linguistic education.",
        ),
        _privilegeItem(
          Icons.home_work_outlined,
          "Ashram/Sanctum Stays",
          "2+ nights built-in accommodation at Rishikesh (Ganga view), Varanasi (Ghat side), and Gokarna (Ocean view) sanctuaries.",
        ),
        _privilegeItem(
          Icons.menu_book_outlined,
          "Rare Palm-Leaf Manuscripts",
          "Curated digital access to 500+ preserved ancient Sanskrit treatises, commentary databases, and scholarly research tools.",
        ),
        _privilegeItem(
          Icons.psychology_outlined,
          "1-on-1 Acharya Guidance",
          "Direct Sadhana consultations, personalized expert mentorship, and access to exclusive Mahasadhana sessions.",
        ),

        const SizedBox(height: 48),
        _testimonialMini(),
      ],
    );
  }

  Widget _privilegeItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E6D9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.primary, size: 20),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialMini() {
    return AppCardContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      backgroundColor: const Color(0xFFF9F6F1),
      borderColor: null,
      onTap: () => _showImagePreview("assets/image_2.png", "Dr. Rajesh Varma"),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage("assets/image_2.png"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\"Joining the Sangha transformed my ritual approach and provided access to texts I never thought possible.\"",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dr. Rajesh Varma • Sadhaka Member, California",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ENROLLMENT FORM ---
  Widget _buildEnrollmentForm() {
    return AppCardContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      child: Form(
        key: _enrollFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.app_registration, color: AppColor.primary, size: 20),
                SizedBox(width: 12),
                Text(
                  "Enrollment",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.lock_outline, color: Colors.black12, size: 18),
              ],
            ),
            const Text(
              "Step into the eternal mandate of the Sanctuary",
              style: TextStyle(fontSize: 12, color: Colors.black38),
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, box) {
                bool isWide = box.maxWidth > 500;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _legalNameController,
                              label: "Full Name *",
                              hint: "e.g. Ananya Sharma",
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter your legal name'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _spiritualNameController,
                              label: "Spiritual/Diksha Name (Optional)",
                              hint: "e.g. Satya Chaitanya",
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextFormField(
                            controller: _legalNameController,
                            label: "Legal Name (as on Passport/ID) *",
                            hint: "e.g. Ananya Sharma",
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter your legal name'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            controller: _spiritualNameController,
                            label: "Spiritual/Diksha Name (Optional)",
                            hint: "e.g. Satya Chaitanya",
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
                            child: _buildTextFormField(
                              controller: _enrollEmailController,
                              label: "Email Address *",
                              hint: "ananya@sangha.org",
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Please enter a valid email'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _enrollPhoneController,
                              label: "WhatsApp/Mobile (for Alerts) *",
                              hint: "+91 98765 43210",
                              keyboardType: TextInputType.phone,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter phone number'
                                  : null,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextFormField(
                            controller: _enrollEmailController,
                            label: "Email Address *",
                            hint: "ananya@sangha.org",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || !v.contains('@'))
                                ? 'Please enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            controller: _enrollPhoneController,
                            label: "WhatsApp/Mobile (for Alerts) *",
                            hint: "+91 98765 43210",
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter phone number'
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
                            child: _buildDropdown(
                              label: "Primary Sacred Stream *",
                              value: _selectedStream,
                              items: _sacredStreams,
                              onChanged: (val) =>
                                  setState(() => _selectedStream = val!),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildDropdown(
                              label: "Preferred Guest Sanctuary *",
                              value: _selectedSanctuary,
                              items: _sanctuaries,
                              onChanged: (val) =>
                                  setState(() => _selectedSanctuary = val!),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDropdown(
                            label: "Primary Sacred Stream *",
                            value: _selectedStream,
                            items: _sacredStreams,
                            onChanged: (val) =>
                                setState(() => _selectedStream = val!),
                          ),
                          const SizedBox(height: 16),
                          _buildDropdown(
                            label: "Preferred Guest Sanctuary *",
                            value: _selectedSanctuary,
                            items: _sanctuaries,
                            onChanged: (val) =>
                                setState(() => _selectedSanctuary = val!),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _enrollPasswordController,
              label: "Create Secret Paraphrase (Master Password) *",
              hint: "Minimum 8 characters",
              isPassword: true,
              isPasswordVisible: _isEnrollPasswordVisible,
              onTogglePassword: () => setState(
                () => _isEnrollPasswordVisible = !_isEnrollPasswordVisible,
              ),
              validator: (v) => (v == null || v.length < 8)
                  ? 'Password must be at least 8 characters'
                  : null,
            ),

            const SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _affirmedProtocol,
                  activeColor: AppColor.primary,
                  onChanged: (v) =>
                      setState(() => _affirmedProtocol = v ?? false),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "I solemnly affirm with reverence and pledge to follow the ashram ABHIM Sadhana protocol, respecting the ritual teachers and lineage principles.",
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: _isEnrollSubmitting
                    ? "Submitting Initiation..."
                    : "Begin Sacred Membership & Proceed to Offering",
                onPressed: _isEnrollSubmitting ? () {} : _submitEnrollmentForm,
                isPrimary: true,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isLoginMode = true),
                child: const Text(
                  "Already initiated? Enter Returning Member Portal →",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SIGN IN FORM ---
  Widget _buildSignInForm() {
    return AppCardContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 32,
      child: Form(
        key: _signInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.login, color: AppColor.primary, size: 20),
                SizedBox(width: 12),
                Text(
                  "Returning Member Sign-In",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Icon(Icons.lock_outline, color: Colors.black12, size: 18),
              ],
            ),
            const Text(
              "Access your manuscript archives, live streams, and Kutir bookings",
              style: TextStyle(fontSize: 12, color: Colors.black38),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: _socialAuthButton(
                    Icons.telegram_outlined,
                    "WhatsApp OTP",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _socialAuthButton(
                    Icons.g_mobiledata,
                    "Google Sign In",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Center(
              child: Text(
                "OR SIGN IN WITH PASSWORD",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black26,
                ),
              ),
            ),
            const SizedBox(height: 28),

            _buildTextFormField(
              controller: _signInEmailController,
              label: "Seeker ID / Registered Email Address *",
              hint: "seeker@chaturveda.org or Member ID",
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your Seeker ID or Email'
                  : null,
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _signInPasswordController,
              label: "Secret Sadhana Paraphrase / Password *",
              hint: "Enter your confidential passphrase",
              isPassword: true,
              isPasswordVisible: _isSignInPasswordVisible,
              onTogglePassword: () => setState(
                () => _isSignInPasswordVisible = !_isSignInPasswordVisible,
              ),
              extraLabel: "Reset Password?",
              onExtraTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Password reset link dispatched to registered contact.',
                    ),
                  ),
                );
              },
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Please enter your password'
                  : null,
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  activeColor: AppColor.primary,
                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                ),
                const Text(
                  "Remember my sacred session on this device",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: _isSignInSubmitting
                    ? "Authenticating..."
                    : "Enter the Sacred Portal",
                onPressed: _isSignInSubmitting ? () {} : _submitSignInForm,
                isPrimary: true,
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1E6D9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: AppColor.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: "Need help accessing Kutir reservations?\n",
                          ),
                          TextSpan(text: "Contact Ashram Seva Desk at "),
                          TextSpan(
                            text: "+91 9988776655",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " or "),
                          TextSpan(
                            text: "seva@chaturveda.org",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isLoginMode = false),
                child: const Text(
                  "New seeker visiting for first time? Apply for Sacred Initiation",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialAuthButton(IconData icon, String text) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text initiated. Follow prompt on screen.')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F3EA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColor.heading),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColor.heading,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FORM HELPERS ---
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? extraLabel,
    VoidCallback? onExtraTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            if (extraLabel != null)
              GestureDetector(
                onTap: onExtraTap,
                child: Text(
                  extraLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black26),
            filled: true,
            fillColor: const Color(0xFFF9F6F1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.black45,
                    ),
                    onPressed: onTogglePassword,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9F6F1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // --- 4. FAQ SECTION ---
  Widget _buildFAQSection(bool isDesktop, MembershipProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          const SectionLabel(text: "SEEKER CLARIFICATIONS"),
          const SizedBox(height: 24),
          const Text(
            "Frequently Contemplated Questions",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 60),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: provider.faqs
                  .map((f) => _faqTile(f["question"]!, f["answer"]!))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqTile(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          q,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColor.heading,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Text(
              a,
              style: AppTextStyles.bodySmall.copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
