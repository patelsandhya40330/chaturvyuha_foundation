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

                // 2. MAIN PORTAL (TABS + FORM + PRIVILEGES)
                _buildMainPortal(isDesktop),

                const SizedBox(height: 120),

                // 3. MEMBERSHIP TIERS TABLE
                _buildMembershipTiers(isDesktop, membershipProvider),

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
          Row(
            mainAxisAlignment: isDesktop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              _portalTab(
                "Initiation & New Memberships",
                !_isLoginMode,
                () => setState(() => _isLoginMode = false),
                Icons.person_add_alt_1_outlined,
              ),
              const SizedBox(width: 16),
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
      padding: const EdgeInsets.all(48),
      borderRadius: 32,
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
          const SizedBox(height: 40),

          const Text(
            "Choose Your Level of Engagement:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 16),
          _tierSelector(),

          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _formField(
                  "Legal Name (as on Passport/ID) *",
                  "e.g. Ananya Sharma",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _formField(
                  "Spiritual/Diksha Name (Optional)",
                  "e.g. Satya Chaitanya",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _formField("Email Address *", "ananya@sangha.org"),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _formField(
                  "WhatsApp/Mobile (for Sanctuary Alerts) *",
                  "+91 98765 43210",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _dropdownField(
                  "Primary Sacred Stream *",
                  "Vedic Chanting (Mantra Ganaveda)",
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _dropdownField(
                  "Preferred Guest Sanctuary *",
                  "Rishikesh — Tapovan Ghat Kutir",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _formField(
            "Create Secret Paraphrase (Master Password) *",
            "Minimum 8 characters with numbers or symbols",
            isPassword: true,
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Checkbox(value: false, onChanged: (v) {}),
              const Expanded(
                child: Text(
                  "I solemnly affirm with reverence and pledge to follow the ashram ABHIM Sadhana protocol, respecting the ritual teachers and lineage principles.",
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          AppButton(
            text: "Begin Sacred Membership & Proceed to Offering",
            onPressed: () {},
            isPrimary: true,
            width: double.infinity,
          ),
          const SizedBox(height: 24),
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
    );
  }

  Widget _tierSelector() {
    return Row(
      children: [
        _tierTab("Upasaka", "Pure Vow", "Free", false),
        const SizedBox(width: 12),
        _tierTab("Sadhaka", "\$18 / mo", "Member", true),
        const SizedBox(width: 12),
        _tierTab("Upasaka", "\$45 / mo", "Member", false),
        const SizedBox(width: 12),
        _tierTab("Samrakshak", "\$1,000", "Foundation", false),
      ],
    );
  }

  Widget _tierTab(String title, String price, String sub, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C1B10) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C1B10) : AppColor.border,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.black45,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(
                color: isSelected ? Colors.white38 : Colors.black26,
                fontSize: 9,
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
      padding: const EdgeInsets.all(48),
      borderRadius: 32,
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
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: _socialAuthButton(
                  Icons.telegram_outlined,
                  "Sign in with WhatsApp OTP",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _socialAuthButton(
                  Icons.g_mobiledata,
                  "Sign in with Google",
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
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
          const SizedBox(height: 32),

          _formField(
            "Seeker ID / Registered Email Address *",
            "seeker@chaturveda.org or Member ID",
          ),
          const SizedBox(height: 24),
          _formField(
            "Secret Sadhana Paraphrase / Password *",
            "Enter your confidential passphrase",
            isPassword: true,
            extraLabel: "Reset Password?",
          ),

          const SizedBox(height: 32),
          Row(
            children: [
              Checkbox(value: true, onChanged: (v) {}),
              const Text(
                "Remember my sacred session on this device",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 40),
          AppButton(
            text: "Enter the Sacred Portal",
            onPressed: () {},
            isPrimary: true,
            width: double.infinity,
          ),

          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(24),
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
                          text:
                              "Need help accessing recordings or Kutir reservations?\n",
                        ),
                        TextSpan(
                          text: "Contact the ashram Seva Desk on WhatsApp at ",
                        ),
                        TextSpan(
                          text: "+91 9988776655",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: " or email "),
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

          const SizedBox(height: 40),
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
    );
  }

  Widget _socialAuthButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3EA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: AppColor.heading),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColor.heading,
            ),
          ),
        ],
      ),
    );
  }

  // --- FORM HELPERS ---
  Widget _formField(
    String label,
    String hint, {
    bool isPassword = false,
    String? extraLabel,
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
              Text(
                extraLabel,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.black26),
            filled: true,
            fillColor: const Color(0xFFF9F6F1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(18),
            suffixIcon: isPassword
                ? const Icon(
                    Icons.visibility_off_outlined,
                    size: 18,
                    color: Colors.black26,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value) {
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
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F6F1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 3. MEMBERSHIP TIERS ---
  Widget _buildMembershipTiers(bool isDesktop, MembershipProvider provider) {
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
            children: [
              const SectionLabel(text: "DETAILED LINEAGE OFFERING"),
              const SizedBox(height: 24),
              const Text(
                "Membership Tiers at a Glance",
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 16),
              const Text(
                "Every contribution, abundant or humble, helps preserve the sacred archival codices and supports young Pathshala students studying the Veda and Shastra.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 60),

              if (isDesktop)
                _buildTiersTable(provider)
              else
                const Text(
                  "// Table optimized for desktop view. Mobile version would be a list of cards.",
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTiersTable(MembershipProvider provider) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        // Table Header
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColor.border, width: 2),
            ),
          ),
          children: [
            _tableHeaderCell("Sadhana Privilege"),
            _tableHeaderCell("Upasaka (Free)"),
            _tableHeaderCell("Sadhaka (\$18/mo)", highlight: true),
            _tableHeaderCell("Upasaka (\$45/mo)"),
            _tableHeaderCell("Samrakshak (\$1,000)"),
          ],
        ),
        // Data Rows
        ...provider.membershipTiers.map((tier) {
          return TableRow(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColor.border)),
            ),
            children: [
              _tableCell(tier["privilege"], isLabel: true),
              _tableCell(tier["Upasaka (Free)"]),
              _tableCell(tier["Sadhaka (\$18/mo)"], highlight: true),
              _tableCell(tier["Upasaka (\$45/mo)"]),
              _tableCell(tier["Samrakshak (\$1,000)"]),
            ],
          );
        }),
      ],
    );
  }

  Widget _tableHeaderCell(String text, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      color: highlight ? const Color(0xFFF1E6D9).withAlpha(150) : null,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: highlight ? AppColor.primary : Colors.black,
        ),
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool highlight = false,
    bool isLabel = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: highlight ? const Color(0xFFF1E6D9).withAlpha(80) : null,
      alignment: isLabel ? Alignment.centerLeft : Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isLabel ? FontWeight.bold : FontWeight.normal,
          color: text == "—"
              ? Colors.black26
              : (highlight && !isLabel ? AppColor.primary : Colors.black87),
        ),
      ),
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
