import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/event_provider.dart';
import '../../models/event_item.dart';

/// A screen displaying the Events, Programs, and Sanctuary Assemblies.
///
/// Features top announcement banner, featured immersion hero, category filters,
/// upcoming assemblies grid with seat reservation request modals, visual gallery of sanctuary moments,
/// and past assembly transcripts archives.
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

/// State implementation for [EventsScreen], managing active program filter,
/// image preview modals, seat booking dialogs, and responsive layout scaling.
class _EventsScreenState extends State<EventsScreen> {
  /// Controller for managing main page scrolling.
  final ScrollController _scrollController = ScrollController();

  /// Currently active program filter category (defaults to 'All Programs').
  String _activeFilter = 'All Programs';

  /// Available program filter categories.
  final List<String> _filters = [
    'All Programs',
    'Upcoming Retreats',
    'Spiritual Gatherings',
    'Vedic Education',
    'Online Sanghas',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Displays an interactive fullscreen modal dialog showing an enlarged preview
  /// of the specified event image.
  ///
  /// [imagePath] Path to the asset image.
  /// [title] Display title for the modal header overlay.
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
                      debugPrint('Events image preview error: $e');
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

  /// Displays a responsive seat pass booking modal dialog for requesting event entry.
  ///
  /// [eventTitle] Title of the event for which the seat is requested.
  void _showSeatBookingDialog(String eventTitle) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
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
                            style: AppTextStyles.title.copyWith(fontSize: 20),
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
                      eventTitle,
                      style: AppTextStyles.bulletLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Divider(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Full Name *",
                        filled: true,
                        fillColor: Color(0xFFF9F6F1),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Seat requested for "${nameController.text.trim()}". Details sent to ${emailController.text.trim()}.',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. TOP NOTICE BAR
                _buildTopNoticeBar(isDesktop),

                // 2. HERO FEATURED EVENT
                _buildHeroEvent(isDesktop),

                const SizedBox(height: 60),

                // 3. FILTERS BAR
                _buildFiltersSection(isDesktop),

                const SizedBox(height: 80),

                // 4. UPCOMING ASSEMBLIES GRID
                _buildUpcomingAssemblies(isDesktop, eventProvider),

                const SizedBox(height: 120),

                // 5. ECHOES GALLERY
                _buildEchoesGallery(isDesktop),

                const SizedBox(height: 120),

                // 6. PAST ASSEMBLIES & TRANSCRIPTS
                _buildPastAssemblies(isDesktop, eventProvider),

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

  /// Builds the top announcement notice banner for upcoming major sanctuary assemblies.
  Widget _buildTopNoticeBar(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF8B5E3C),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 14,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Next Sanctuary Assembly: Rigveda Chanting Mahayagna commences in 12 days.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isDesktop && constraints.maxWidth > 800) ...[
                const SizedBox(width: 24),
                InkWell(
                  onTap: () =>
                      _showSeatBookingDialog("Rigveda Chanting Mahayagna"),
                  child: const Text(
                    "Join online →",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Builds the top breadcrumb navigation trail (Home > Events & Programs).
  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        Text(
          "Home",
          style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
        ),
        const Icon(Icons.chevron_right, size: 14, color: AppColor.grey),
        Text(
          "Events & Programs",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Builds the hero banner displaying the featured immersion retreat card.
  Widget _buildHeroEvent(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumbs(),
          const SizedBox(height: 24),
          AppCardContainer(
            padding: EdgeInsets.zero,
            borderRadius: 32,
            clipBehavior: Clip.antiAlias,
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildHeroImage(isDesktop: true),
                        ),
                        Expanded(flex: 4, child: _buildHeroDetails(isDesktop)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      _buildHeroImage(isDesktop: false),
                      _buildHeroDetails(isDesktop),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Builds the image portion of the hero retreat card with title gradient overlay.
  Widget _buildHeroImage({bool isDesktop = true}) {
    return AppCardContainer(
      height: isDesktop ? null : 340,
      borderRadius: 0,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      onTap: () => _showImagePreview(
        "assets/image_1.png",
        "Sharad Purnima Silent Immersion",
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/image_1.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF2C1B10),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 64,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minHeight: isDesktop ? 360 : 200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withAlpha(210),
                  Colors.black.withAlpha(80),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            padding: EdgeInsets.all(isDesktop ? 40 : 20),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(
                  text: "FEATURED IMMERSION",
                  color: Colors.white70,
                ),
                SizedBox(height: isDesktop ? 16 : 8),
                Text(
                  "Sharad Purnima 7-Day Silent Brahma Muhurta Immersion",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 32 : 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isDesktop ? 16 : 8),
                Text(
                  "A deep contemplative retreat focusing on the internal resonance of the moon cycles and Vedic silence methodologies.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isDesktop ? 14 : 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the detail specifications side-panel inside the featured retreat hero card.
  Widget _buildHeroDetails(bool isDesktop) {
    return Container(
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.all(isDesktop ? 48 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _eventDetailItem(
            Icons.calendar_today,
            "DATE & DURATION",
            "Oct 12 - 18, 2024",
          ),
          const SizedBox(height: 24),
          _eventDetailItem(
            Icons.access_time,
            "DAILY TIMINGS",
            "04:30 AM - 08:00 AM IST",
          ),
          const SizedBox(height: 24),
          _eventDetailItem(
            Icons.location_on_outlined,
            "SANCTUARY STATUS",
            "Ganga-front Hermitage, Rishikesh",
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 32),
          _bulletPoint("7-Day Silent Vow (Mauna)"),
          _bulletPoint("Guided Brahma Muhurta Dhyana"),
          _bulletPoint("Soma Mandala Sukta Recitations"),
          const SizedBox(height: 40),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                text: "Request Booking Seat",
                onPressed: () => _showSeatBookingDialog(
                  "Sharad Purnima 7-Day Silent Immersion",
                ),
                isPrimary: true,
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Downloading Sharad Purnima Immersion PDF Guide...',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: AppColor.primary,
                ),
                tooltip: "Download PDF Guide",
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper builder for individual metadata rows (Icon + Label + Value).
  Widget _eventDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColor.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bulletLabel.copyWith(fontSize: 9),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper builder for bulleted feature text items with check icons.
  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColor.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  /// Filters upcoming events based on the currently selected category [_activeFilter].
  List<EventItem> _getFilteredUpcomingEvents(List<EventItem> events) {
    if (_activeFilter == 'All Programs') return events;

    return events.where((ev) {
      final title = ev.title.toLowerCase();
      final desc = ev.description.toLowerCase();
      final filter = _activeFilter.toLowerCase();

      if (filter.contains('retreat')) {
        return title.contains('retreat') ||
            desc.contains('retreat') ||
            title.contains('sadhana') ||
            desc.contains('sadhana') ||
            desc.contains('wellness');
      } else if (filter.contains('spiritual') || filter.contains('gathering')) {
        return title.contains('yagna') ||
            desc.contains('gathering') ||
            title.contains('dhyana') ||
            desc.contains('meditative');
      } else if (filter.contains('vedic') || filter.contains('education')) {
        return title.contains('grammar') ||
            title.contains('chanting') ||
            desc.contains('recitation') ||
            desc.contains('prosody');
      } else if (filter.contains('online') || filter.contains('sangha')) {
        return desc.contains('global') || title.contains('soma');
      }
      return true;
    }).toList();
  }

  /// Builds a responsive category selection chip bar for filtering events.
  ///
  /// On wide desktop/tablet viewports, chips wrap naturally across lines.
  /// On mobile viewports, chips scroll horizontally in a single row.
  Widget _buildFiltersSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: LayoutBuilder(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: isActive ? AppColor.primary : AppColor.border,
                ),
              ),
            );
          }).toList();

          if (constraints.maxWidth >= 768) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
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
                        padding: const EdgeInsets.only(right: 12),
                        child: chip,
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds a responsive grid of upcoming assemblies and immersion retreats.
  Widget _buildUpcomingAssemblies(bool isDesktop, EventProvider provider) {
    final filteredEvents = _getFilteredUpcomingEvents(provider.upcomingEvents);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SADHANĀ ASSEMBLIES"),
          const SizedBox(height: 24),
          const Text(
            "Upcoming Assemblies & Immersion Retreats",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          if (filteredEvents.isEmpty)
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
                    "No assemblies scheduled for this category.",
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
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth >= 900 ? 2 : 1;
                double spacing = 24.0;
                double itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                    crossAxisCount;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: filteredEvents.map((ev) {
                    return _eventCard(itemWidth, ev, isDesktop);
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  /// Builds an individual upcoming event card widget.
  Widget _eventCard(double width, EventItem ev, bool isDesktop) {
    return AppCardContainer(
      width: width,
      padding: EdgeInsets.all(isDesktop ? 32 : 20),
      borderRadius: 24,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1E6D9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "SADHANĀ RETREAT",
                  style: AppTextStyles.bulletLabel.copyWith(
                    fontSize: 9,
                    color: AppColor.primary,
                  ),
                ),
              ),
              Text(
                "${ev.date.day}th Oct, 2024",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            ev.title,
            style: AppTextStyles.title.copyWith(
              fontSize: 20,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ev.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.black54,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColor.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ev.location,
                  style: const TextStyle(fontSize: 12, color: AppColor.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              const Text(
                "Enrolling: 12 Seats Left",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              AppButton(
                text: "Apply Online",
                onPressed: () => _showSeatBookingDialog(ev.title),
                isPrimary: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the "Echoes Gallery" section showcasing sanctuary photo memories.
  Widget _buildEchoesGallery(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: isDesktop ? 100 : 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 800) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionLabel(text: "SANCTUARY MOMENTS"),
                        SizedBox(height: 16),
                        Text(
                          "Echoes of Gurukula, Ghats & Yagya",
                          style: AppTextStyles.heading2,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "A visual archival of our previous assemblies, capturing the essence of spiritual study and traditional methodology across various holy sites.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionLabel(text: "SANCTUARY MOMENTS"),
                            SizedBox(height: 24),
                            Text(
                              "Echoes of Gurukula, Ghats & Yagya",
                              style: AppTextStyles.heading2,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "A visual archival of our previous assemblies, capturing the essence of spiritual study and traditional methodology across various holy sites.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 60),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _galleryCard(
                        "Veda Pathashala Palm-Leaf Reading Assembly",
                        "assets/image_2.png",
                        height: 450,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          _galleryCard(
                            "Dawn Sadhana on the Ghats",
                            "assets/image_1.png",
                            height: 213,
                          ),
                          const SizedBox(height: 24),
                          _galleryCard(
                            "Daily Sandhya Arpana Puja",
                            "assets/image_3.png",
                            height: 213,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _galleryCard(
                      "Veda Pathashala Palm-Leaf Reading Assembly",
                      "assets/image_2.png",
                      height: 260,
                    ),
                    const SizedBox(height: 24),
                    _galleryCard(
                      "Dawn Sadhana on the Ghats",
                      "assets/image_1.png",
                      height: 200,
                    ),
                    const SizedBox(height: 24),
                    _galleryCard(
                      "Daily Sandhya Arpana Puja",
                      "assets/image_3.png",
                      height: 200,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a gallery photo card widget with bottom section overlay title.
  Widget _galleryCard(String title, String img, {required double height}) {
    return AppCardContainer(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.zero,
      borderRadius: 24,
      clipBehavior: Clip.antiAlias,
      onTap: () => _showImagePreview(img, title),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            img,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF2C1B10),
              child: const Center(
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 48,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withAlpha(120), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel(
                  text: "SHRAVANA & SADHANĀ",
                  color: Colors.white70,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the past assemblies section with audio transcripts & archives.
  Widget _buildPastAssemblies(bool isDesktop, EventProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              bool isNarrow = box.maxWidth < 600;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Past Assemblies & Audio Transcripts",
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Loading all historical sanctuary assembly archives...',
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      child: const Text(
                        "View All Records →",
                        style: AppTextStyles.link,
                      ),
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Past Assemblies & Audio Transcripts",
                      style: AppTextStyles.heading2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Loading all historical sanctuary assembly archives...',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "View All Records →",
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
              int crossAxisCount = constraints.maxWidth >= 1100
                  ? 3
                  : (constraints.maxWidth >= 700 ? 2 : 1);
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.pastEvents.map((ev) {
                  return AppCardContainer(
                    width: itemWidth,
                    padding: EdgeInsets.all(isDesktop ? 32 : 20),
                    borderRadius: 24,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Accessing audio recording & transcript for ${ev['title']}...',
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              ev['year'],
                              style: AppTextStyles.bulletLabel.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "COMPLETED",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          ev['title'],
                          style: AppTextStyles.title.copyWith(
                            fontSize: 18,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ev['desc'],
                          style: AppTextStyles.bodySmall.copyWith(
                            height: 1.6,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (ev['transcript'])
                          Row(
                            children: [
                              const Icon(
                                Icons.headset_outlined,
                                size: 14,
                                color: AppColor.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Transcript & Audio Available",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        else
                          const Text(
                            "Archival In Progress",
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.black38,
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
    );
  }
}
