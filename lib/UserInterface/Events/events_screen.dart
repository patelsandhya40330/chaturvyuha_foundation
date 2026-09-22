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

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _activeFilter = 'All Programs';
  final List<String> _filters = [
    'All Programs',
    'Upcoming Retreats',
    'Spiritual Gatherings',
    'Vedic Education',
    'Online Sanghas',
  ];

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
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

  // --- 1. TOP NOTICE BAR ---
  Widget _buildTopNoticeBar(bool isDesktop) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF8B5E3C),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.white70,
            size: 14,
          ),
          const SizedBox(width: 8),
          const Text(
            "Next Sanctuary Assembly: Rigveda Chanting Mahayagna commences in 12 days.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 24),
            const Text(
              "Join from anywhere online →",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- 2. HERO FEATURED EVENT ---
  Widget _buildHeroEvent(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: AppCardContainer(
        padding: EdgeInsets.zero,
        borderRadius: 32,
        clipBehavior: Clip.antiAlias,
        child: isDesktop
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 6, child: _buildHeroImage()),
                    Expanded(flex: 4, child: _buildHeroDetails()),
                  ],
                ),
              )
            : Column(
                children: [
                  AspectRatio(aspectRatio: 16 / 9, child: _buildHeroImage()),
                  _buildHeroDetails(),
                ],
              ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image_1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withAlpha(150), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(40),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel(
              text: "FEATURED IMMERSION",
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            const Text(
              "Sharad Purnima 7-Day Silent\nBrahma Muhurta Immersion",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "A deep contemplative retreat focusing on the internal resonance of the moon cycles and Vedic silence methodologies.",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroDetails() {
    return Container(
      color: const Color(0xFFF9F6F1),
      padding: const EdgeInsets.all(48),
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
          Row(
            children: [
              AppButton(
                text: "Request Booking Seat",
                onPressed: () {},
                isPrimary: true,
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
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

  Widget _eventDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColor.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bulletLabel.copyWith(fontSize: 9)),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

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
          Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // --- 3. FILTERS BAR ---
  Widget _buildFiltersSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final bool isActive = _activeFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isActive,
                      onSelected: (val) {
                        if (val) setState(() => _activeFilter = filter);
                      },
                      selectedColor: AppColor.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: AppColor.border),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 24),
            const Icon(Icons.search, color: AppColor.grey),
            const SizedBox(width: 24),
            const Icon(Icons.grid_view, color: AppColor.primary),
            const SizedBox(width: 16),
            const Icon(Icons.list, color: AppColor.grey),
          ],
        ],
      ),
    );
  }

  // --- 4. UPCOMING ASSEMBLIES GRID ---
  Widget _buildUpcomingAssemblies(bool isDesktop, EventProvider provider) {
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
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop ? 2 : 1;
              double spacing = 24.0;
              double itemWidth =
                  (constraints.maxWidth - (crossAxisCount - 1) * spacing) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: provider.upcomingEvents.map((ev) {
                  return _eventCard(itemWidth, ev);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _eventCard(double width, EventItem ev) {
    return AppCardContainer(
      width: width,
      padding: const EdgeInsets.all(32),
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
                "${ev.date.day}nd Oct, 2024", // Placeholder date format from image
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
              Text(
                ev.location,
                style: const TextStyle(fontSize: 12, color: AppColor.grey),
              ),
              const Spacer(),
              const Icon(Icons.person_outline, size: 14, color: AppColor.grey),
              const SizedBox(width: 8),
              const Text(
                "Acharya Shridhar",
                style: TextStyle(fontSize: 12, color: AppColor.grey),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: () {},
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

  // --- 5. ECHOES GALLERY ---
  Widget _buildEchoesGallery(bool isDesktop) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel(text: "SANCTUARY MOMENTS"),
                        const SizedBox(height: 24),
                        const Text(
                          "Echoes of Gurukula, Ghats & Yagya",
                          style: AppTextStyles.heading2,
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    const Expanded(
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
              ),
              const SizedBox(height: 60),
              // Masonry-like grid
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
                      height: 300,
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

  Widget _galleryCard(String title, String img, {required double height}) {
    return AppCardContainer(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.zero,
      borderRadius: 24,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(img, fit: BoxFit.cover),
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

  // --- 6. PAST ASSEMBLIES & TRANSCRIPTS ---
  Widget _buildPastAssemblies(bool isDesktop, EventProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Past Assemblies & Audio Transcripts",
                style: AppTextStyles.heading2,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View All Records →",
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop ? 3 : 1;
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
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
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
                              Text(
                                "Transcript & Audio Available",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
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
