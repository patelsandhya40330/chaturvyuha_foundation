import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/yoga_provider.dart';
import '../../dataProvider/foundation_provider.dart';
import '../../dataProvider/article_provider.dart';
import '../../models/yoga_program.dart';
import '../../models/article_item.dart';

/// A screen displaying Vedic Yoga, Contemplative Dhyana, Sadhana Curricula,
/// Daily Timetable, 1-on-1 Private Sessions, Lineage Acharyas, and Shastra Essays.
class YogaMeditationScreen extends StatefulWidget {
  const YogaMeditationScreen({super.key});

  @override
  State<YogaMeditationScreen> createState() => _YogaMeditationScreenState();
}

/// State implementation for [YogaMeditationScreen], managing active timetable
/// filters, seat pass booking modals, custom 1-on-1 private session booking,
/// curricula detail dialogs, and responsive layout.
class _YogaMeditationScreenState extends State<YogaMeditationScreen> {
  /// Controller managing main page scrolling.
  final ScrollController _scrollController = ScrollController();

  /// Active filter option for the daily sanctuary timetable (defaults to 'All Session').
  String _activeFilter = 'All Session';

  /// Available session mode filters.
  final List<String> _filters = [
    'All Session',
    'In-person at Sanctuary',
    'Virtual Classes',
    'Private Sadhana',
    'Youth Programs',
  ];

  /// State variables for the 1-on-1 Private Sadhana custom booking section.
  DateTime? _selectedPrivateDate;
  TimeOfDay? _selectedPrivateTime;
  String _selectedFocusArea = 'Asana & Posture Alignment';
  String _selectedPrivateMode = 'In-person at Sanctuary Hermitage';

  final TextEditingController _privateNameController = TextEditingController();
  final TextEditingController _privateEmailController = TextEditingController();
  final TextEditingController _privateNotesController = TextEditingController();
  final GlobalKey<FormState> _privateFormKey = GlobalKey<FormState>();

  final List<String> _focusAreas = [
    'Asana & Posture Alignment',
    'Therapeutic Pranayama',
    'Advaita Dhyana & Meditation',
    'Sanskrit Phonetics & Mantra',
  ];

  final List<String> _privateModes = [
    'In-person at Sanctuary Hermitage',
    'Virtual Private Zoom Room',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _privateNameController.dispose();
    _privateEmailController.dispose();
    _privateNotesController.dispose();
    super.dispose();
  }

  /// Date picker launcher for private session booking.
  Future<void> _pickPrivateDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedPrivateDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedPrivateDate = picked);
    }
  }

  /// Time picker launcher for private session booking.
  Future<void> _pickPrivateTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedPrivateTime ?? const TimeOfDay(hour: 7, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedPrivateTime = picked);
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return "Choose Preferred Date *";
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  String _formatTime(TimeOfDay? tod) {
    if (tod == null) return "Choose Preferred Time *";
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  /// Handles custom 1-on-1 private sadhana booking submission.
  void _submitPrivateBooking() {
    if (_privateFormKey.currentState!.validate()) {
      if (_selectedPrivateDate == null || _selectedPrivateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select both a preferred Date and Time for your session.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final dateStr = _formatDate(_selectedPrivateDate);
      final timeStr = _formatTime(_selectedPrivateTime);
      final name = _privateNameController.text.trim();
      final email = _privateEmailController.text.trim();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColor.surface,
          title: const Text(
            "1-on-1 Private Sadhana Confirmed",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Namaste $name,",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Your private $_selectedFocusArea session request has been booked for $dateStr at $timeStr ($_selectedPrivateMode).",
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                "A confirmation email and preparation guide have been sent to $email.",
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          actions: [
            AppButton(
              text: "Done",
              onPressed: () {
                Navigator.pop(ctx);
                _privateNameController.clear();
                _privateEmailController.clear();
                _privateNotesController.clear();
                setState(() {
                  _selectedPrivateDate = null;
                  _selectedPrivateTime = null;
                });
              },
              isPrimary: true,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ],
        ),
      );
    }
  }

  /// Displays an information modal dialog containing program or acharya details.
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
                      debugPrint('Yoga image preview error: $e');
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

  /// Displays a responsive seat pass reservation modal dialog for booking a session,
  /// featuring interactive preferred Date & Time selection.
  void _showSeatBookingDialog(String sessionTitle, [String? sessionTime]) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    DateTime? dialogDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay? dialogTime = const TimeOfDay(hour: 7, minute: 0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          String formatDate(DateTime? dt) {
            if (dt == null) return "Choose Date *";
            return "${dt.day}/${dt.month}/${dt.year}";
          }

          String formatTime(TimeOfDay? tod) {
            if (tod == null) return "Choose Time *";
            final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
            final minute = tod.minute.toString().padLeft(2, '0');
            final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
            return "$hour:$minute $period";
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: AppColor.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Request Seat Pass",
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => Navigator.pop(ctx),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          sessionTime != null
                              ? "$sessionTitle ($sessionTime)"
                              : sessionTitle,
                          style: AppTextStyles.bulletLabel,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Divider(height: 24),

                        // Preferred Date & Time Selection
                        const Text(
                          "Preferred Date & Time Slot *",
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final now = DateTime.now();
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        dialogDate ??
                                        now.add(const Duration(days: 1)),
                                    firstDate: now,
                                    lastDate: now.add(const Duration(days: 90)),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColor.primary,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setDialogState(() => dialogDate = picked);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9F6F1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColor.primary),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: AppColor.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          formatDate(dialogDate),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        dialogTime ??
                                        const TimeOfDay(hour: 7, minute: 0),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: AppColor.primary,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    setDialogState(() => dialogTime = picked);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9F6F1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColor.primary),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        color: AppColor.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          formatTime(dialogTime),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Full Name *",
                            filled: true,
                            fillColor: Color(0xFFF9F6F1),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email Address *",
                            filled: true,
                            fillColor: Color(0xFFF9F6F1),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || !v.contains('@'))
                              ? 'Please enter a valid email'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: "Confirm Seat Pass Request",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(ctx);
                                final dateStr = formatDate(dialogDate);
                                final timeStr = formatTime(dialogTime);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Seat requested for "${nameController.text.trim()}" ($sessionTitle on $dateStr at $timeStr). Confirmation sent to ${emailController.text.trim()}.',
                                    ),
                                    backgroundColor: AppColor.primary,
                                  ),
                                );
                              }
                            },
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final yogaProvider = context.watch<YogaProvider>();
    final foundationProvider = context.watch<FoundationProvider>();
    final articleProvider = context.watch<ArticleProvider>();

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

                // 2. SADHANA CURRICULA GRID
                _buildCurriculaSection(isDesktop, yogaProvider),

                const SizedBox(height: 100),

                // 3. DAILY TIMETABLE
                _buildTimetableSection(isDesktop, yogaProvider),

                const SizedBox(height: 100),

                // 4. ONE-ON-ONE PRIVATE SADHANA (CUSTOM DATE & TIME)
                _buildPrivateSadhanaSection(isDesktop),

                const SizedBox(height: 100),

                // 5. LINEAGE ACHARYAS
                _buildAcharyasSection(isDesktop, foundationProvider),

                const SizedBox(height: 100),

                // 6. SHASTRA INSIGHTS & ESSAYS
                _buildEssaysSection(isDesktop, articleProvider),

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

  /// Builds the hero banner section including intro copy, live stream banner, and preview card.
  Widget _buildHeroSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "AUTHENTIC VEDIC TRADITION"),
          const SizedBox(height: 24),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: _buildHeroLeft()),
                const SizedBox(width: 60),
                Expanded(flex: 4, child: _buildHeroRight(isDesktop)),
              ],
            )
          else
            Column(
              children: [
                _buildHeroLeft(),
                const SizedBox(height: 24),
                _buildHeroRight(isDesktop),
              ],
            ),
          const SizedBox(height: 48),
          _buildHeroBanner(),
        ],
      ),
    );
  }

  /// Builds the left column inside hero section with headings and overview text.
  Widget _buildHeroLeft() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final double heroFontSize = screenWidth >= 1100
            ? 54
            : (screenWidth < 400 ? 28 : 36);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.heroHeading.copyWith(
                  fontSize: heroFontSize,
                  height: 1.1,
                ),
                children: [
                  const TextSpan(
                    text: "Union with the Eternal, Authentic Vedic ",
                  ),
                  TextSpan(
                    text: "Yoga & Contemplative Dhyana.",
                    style: AppTextStyles.heroSubheading.copyWith(
                      fontSize: heroFontSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Authentic meditation methods rooted in the Advaita Shastra tradition, providing professional guidance for inner inquiry. Join our live sangha for daily sessions dedicated to manuscript study and Vedic breath sciences with authorized lineage keepers.",
              style: AppTextStyles.bodyLarge,
            ),
          ],
        );
      },
    );
  }

  /// Builds the right card container inside the hero section showcasing the Gurukul image.
  Widget _buildHeroRight(bool isDesktop) {
    return AppCardContainer(
      height: isDesktop ? 400 : 280,
      borderRadius: 24,
      borderColor: null,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      onTap: () => _showImagePreview(
        "assets/image_3.png",
        "Dharma of the Soul: Gurukul",
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
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
                    "Dharma of the Soul: Gurukul",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Classical Chant Repository & Library",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 24,
            right: 24,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.fullscreen, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the daily live stream notice bar under the hero section.
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: AppColor.primary, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Daily at 5:30 AM IST at Surya Mandapam & Live stream",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => _showSeatBookingDialog(
              "5:30 AM Surya Mandapam Live Stream Pass",
            ),
            child: const Text("Access Stream →", style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }

  /// Builds the Sadhana Curricula grid displaying structured posture and meditation courses.
  Widget _buildCurriculaSection(bool isDesktop, YogaProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SHASTRA BASED SADHANA"),
          const SizedBox(height: 24),
          const Text(
            "Vedic Yoga Sadhana Curricula",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop
                  ? 4
                  : (constraints.maxWidth > 700 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.yogaPrograms.map((program) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(28),
                    borderRadius: 24,
                    onTap: () => _showInfoDialog(
                      program.title,
                      "${program.description}\n\nInstructor: ${program.instructor}\nSchedule: ${program.schedule}\nType: ${program.type == ProgramType.yoga ? 'Yoga' : 'Meditation'}\n\nThis curriculum integrates traditional posture work, prāṇāyāma breath cycles, and phonetic chant meditation. All participants receive digital guides and daily live stream access.",
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColor.lightPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: program.type == ProgramType.yoga
                              ? const Icon(
                                  Icons.self_improvement,
                                  color: AppColor.primary,
                                  size: 24,
                                )
                              : const Icon(
                                  Icons.psychology_outlined,
                                  color: AppColor.primary,
                                  size: 24,
                                ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          program.type == ProgramType.yoga
                              ? "YOGA"
                              : "MEDITATION",
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          program.title,
                          style: AppTextStyles.title.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "• Systematic Progression",
                          style: AppTextStyles.bodySmall,
                        ),
                        const Text(
                          "• Lineage Based Training",
                          style: AppTextStyles.bodySmall,
                        ),
                        const Text(
                          "• Vedic Phonetic Cycles",
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _showInfoDialog(
                                program.title,
                                "${program.description}\n\nInstructor: ${program.instructor}\nSchedule: ${program.schedule}\nType: ${program.type == ProgramType.yoga ? 'Yoga' : 'Meditation'}\n\nThis curriculum integrates traditional posture work, prāṇāyāma breath cycles, and phonetic chant meditation. All participants receive digital guides and daily live stream access.",
                              ),
                              child: const Text(
                                "Learn More →",
                                style: AppTextStyles.link,
                              ),
                            ),
                            AppButton(
                              text: "Book Pass",
                              onPressed: () => _showSeatBookingDialog(
                                program.title,
                                program.schedule,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the daily timetable list with mode tags and seat booking action buttons.
  Widget _buildTimetableSection(bool isDesktop, YogaProvider provider) {
    final filteredTimetable = provider.yogaTimetable.where((item) {
      if (_activeFilter == 'All Session') return true;
      final mode = item['mode'].toString().toLowerCase();
      final tag = item['tag'].toString().toLowerCase();
      final filter = _activeFilter.toLowerCase();
      return mode.contains(filter) || tag.contains(filter);
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sanctuary Daily Timetable",
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 48),
          if (filteredTimetable.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F6F1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                children: [
                  Icon(Icons.event_busy, size: 48, color: AppColor.grey),
                  SizedBox(height: 16),
                  Text(
                    "No sessions scheduled under this filter.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: filteredTimetable.map((item) {
                return AppCardContainer(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  borderRadius: 20,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isCompact = constraints.maxWidth < 550;

                      if (isCompact) {
                        // Stack vertically on narrow cards to prevent text/button overflow.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['time'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                _modeBadge(item['tag']),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item['title'],
                              style: AppTextStyles.title.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['location'],
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['mode'],
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ),
                                AppButton(
                                  text: "Book",
                                  onPressed: () => _showSeatBookingDialog(
                                    item['title'],
                                    item['time'],
                                  ),
                                  width: 90,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              item['time'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.title.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _modeBadge(item['tag']),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['location'],
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          if (isDesktop)
                            Expanded(
                              child: Text(
                                item['mode'],
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primary,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          const SizedBox(width: 20),
                          AppButton(
                            text: "Book",
                            onPressed: () => _showSeatBookingDialog(
                              item['title'],
                              item['time'],
                            ),
                            width: 90,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Builds a small pill badge for timetable tags (e.g. IN-PERSON, VIRTUAL).
  Widget _modeBadge(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E6D9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColor.primary,
        ),
      ),
    );
  }

  /// Builds the horizontal filter chip row for session types.
  Widget _buildFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final filterChips = _filters.map((filter) {
          final bool isActive = _activeFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isActive,
            onSelected: (val) {
              if (val) setState(() => _activeFilter = filter);
            },
            selectedColor: AppColor.primary,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            labelStyle: TextStyle(
              color: isActive ? Colors.white : Colors.black87,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isActive ? AppColor.primary : AppColor.border,
              ),
            ),
          );
        }).toList();

        if (constraints.maxWidth >= 768) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: filterChips,
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterChips
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
    );
  }

  /// Builds the "1-on-1 Private Sadhana" section allowing users to pick custom Date & Time.
  Widget _buildPrivateSadhanaSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: "PERSONALIZED SADHANĀ"),
              const SizedBox(height: 24),
              const Text(
                "One-on-One Private Sadhana & Mentorship",
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 16),
              const Text(
                "Schedule a 1-on-1 session tailored to your personal health, schedule, and spiritual goals. Choose your preferred date, time slot, and focus area with our authorized Acharyas.",
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 48),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildPrivateInfoSide()),
                    const SizedBox(width: 48),
                    Expanded(flex: 7, child: _buildPrivateBookingCard()),
                  ],
                )
              else
                Column(
                  children: [
                    _buildPrivateInfoSide(),
                    const SizedBox(height: 40),
                    _buildPrivateBookingCard(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivateInfoSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _privateFeatureCard(
          Icons.health_and_safety_outlined,
          "Tailored to Your Physiology",
          "Custom posture variations, spinal alignment adjustments, and breathwork pacing specifically adapted for your health profile.",
        ),
        const SizedBox(height: 20),
        _privateFeatureCard(
          Icons.person_outline,
          "Direct Lineage Mentorship",
          "One-on-one consultation with senior lineage Acharyas for personalized guidance in Advaita meditation and manuscript study.",
        ),
        const SizedBox(height: 20),
        _privateFeatureCard(
          Icons.event_available_outlined,
          "Your Date, Time & Attendance Mode",
          "Select any date and time slot that fits your schedule, available both in-person at our sanctuary suite or online via private video room.",
        ),
      ],
    );
  }

  Widget _privateFeatureCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.lightPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.primary, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title.copyWith(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateBookingCard() {
    return AppCardContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 24,
      backgroundColor: Colors.white,
      child: Form(
        key: _privateFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.edit_calendar,
                  color: AppColor.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Book Your Custom 1-on-1 Session",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.title.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            // Select Focus Area
            const Text(
              "1. Select Focus Area *",
              style: AppTextStyles.bulletLabel,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _focusAreas.map((area) {
                final bool isSelected = _selectedFocusArea == area;
                return ChoiceChip(
                  label: Text(area),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedFocusArea = area);
                  },
                  selectedColor: AppColor.primary,
                  backgroundColor: const Color(0xFFF9F6F1),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black87,
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
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Select Date & Time Pickers
            const Text(
              "2. Preferred Date & Time Slot *",
              style: AppTextStyles.bulletLabel,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, box) {
                bool isWide = box.maxWidth > 480;
                return isWide
                    ? Row(
                        children: [
                          Expanded(child: _datePickerButton()),
                          const SizedBox(width: 16),
                          Expanded(child: _timePickerButton()),
                        ],
                      )
                    : Column(
                        children: [
                          _datePickerButton(),
                          const SizedBox(height: 12),
                          _timePickerButton(),
                        ],
                      );
              },
            ),
            const SizedBox(height: 24),

            // Attendance Mode
            const Text(
              "3. Attendance Mode *",
              style: AppTextStyles.bulletLabel,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _privateModes.map((mode) {
                final bool isSelected = _selectedPrivateMode == mode;
                return ChoiceChip(
                  label: Text(mode),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedPrivateMode = mode);
                  },
                  selectedColor: AppColor.primary,
                  backgroundColor: const Color(0xFFF9F6F1),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black87,
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
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Contact Info Fields
            const Text(
              "4. Contact Information *",
              style: AppTextStyles.bulletLabel,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _privateNameController,
              decoration: InputDecoration(
                hintText: "Full Name *",
                prefixIcon: const Icon(Icons.person_outline, size: 20),
                filled: true,
                fillColor: const Color(0xFFF9F6F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _privateEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email Address *",
                prefixIcon: const Icon(Icons.email_outlined, size: 20),
                filled: true,
                fillColor: const Color(0xFFF9F6F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Please enter a valid email address'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _privateNotesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Special Requests / Health Considerations (Optional)",
                prefixIcon: const Icon(Icons.notes_outlined, size: 20),
                filled: true,
                fillColor: const Color(0xFFF9F6F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: "Confirm 1-on-1 Session Booking",
                onPressed: _submitPrivateBooking,
                isPrimary: true,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerButton() {
    return InkWell(
      onTap: _pickPrivateDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPrivateDate != null
                ? AppColor.primary
                : AppColor.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColor.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatDate(_selectedPrivateDate),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _selectedPrivateDate != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedPrivateDate != null
                      ? AppColor.primary
                      : Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timePickerButton() {
    return InkWell(
      onTap: _pickPrivateTime,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F6F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedPrivateTime != null
                ? AppColor.primary
                : AppColor.border,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColor.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _formatTime(_selectedPrivateTime),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _selectedPrivateTime != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedPrivateTime != null
                      ? AppColor.primary
                      : Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the "Revered Lineage Acharyas" section showcasing teacher cards.
  Widget _buildAcharyasSection(bool isDesktop, FoundationProvider provider) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel(text: "SADHANĀ & GURU SHISHYA"),
              const SizedBox(height: 24),
              const Text(
                "Revered Lineage Acharyas",
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = isDesktop
                      ? 3
                      : (constraints.maxWidth > 700 ? 2 : 1);
                  double spacing = 40.0;
                  double itemWidth =
                      (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                      crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: provider.teamMembers.map((member) {
                      return AppCardContainer(
                        width: itemWidth,
                        padding: EdgeInsets.zero,
                        borderRadius: 24,
                        clipBehavior: Clip.antiAlias,
                        onTap: () => _showInfoDialog(
                          member.name,
                          "${member.role}\n\n${member.bio}\n\nSpecializes in authentic manuscript commentary and traditional transmission of prāṇāyāma methods.",
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.2,
                              child: Image.asset(
                                "assets/image_2.png",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: const Color(0xFF2C1B10),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 48,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.role.toUpperCase(),
                                    style: AppTextStyles.bulletLabel,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    member.bio,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      height: 1.6,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 32),
                                  const Divider(),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Specialty: Vedic Wisdom",
                                        style: AppTextStyles.caption.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "Full Biography →",
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the "Shastra Insights & Essays" section showcasing articles.
  Widget _buildEssaysSection(bool isDesktop, ArticleProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "DHYĀNA VIDYĀ"),
          const SizedBox(height: 24),
          const Text(
            "Shastra Insights & Essays",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop
                  ? 3
                  : (constraints.maxWidth > 700 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.articles.map((article) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    onTap: () => _showArticleDialog(article),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.category.toUpperCase(),
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          article.title,
                          style: AppTextStyles.title.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          article.excerpt,
                          style: AppTextStyles.bodySmall.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "By ${article.author}",
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(
                              "Read Essay →",
                              style: AppTextStyles.link,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Displays an article reader dialog modal.
  void _showArticleDialog(ArticleItem article) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 650),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: AppTextStyles.bulletLabel,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: AppTextStyles.heading2.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  "By ${article.author} • ${article.publishedDate.day}/${article.publishedDate.month}/${article.publishedDate.year}",
                  style: AppTextStyles.caption,
                ),
                const Divider(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      article.content,
                      style: AppTextStyles.body.copyWith(height: 1.7),
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
}
