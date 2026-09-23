import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;
  const BookingScreen({super.key, this.onTabSelected});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ScrollController _scrollController = ScrollController();
  String _activeFilter = 'All Bookings';

  final List<String> _filters = [
    'All Bookings',
    'Upcoming',
    'Yoga Sessions',
    'Event Immersions',
    'Completed',
    'Cancelled',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Digital Entry Pass Modal
  void _showPassModal(BookingItem booking) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SANCTUARY ENTRY PASS",
                      style: AppTextStyles.bulletLabel,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pass QR Code Placeholder
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.qr_code_2,
                        size: 140,
                        color: AppColor.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        booking.passCode,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  booking.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "${booking.date} • ${booking.timeSlot}",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  booking.location,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: "Download Digital Pass",
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Pass ${booking.passCode} saved to your downloads.",
                          ),
                          backgroundColor: AppColor.primary,
                        ),
                      );
                    },
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reschedule Dialog
  void _showRescheduleDialog(BookingItem booking) {
    final dateController = TextEditingController(text: booking.date);
    final timeController = TextEditingController(text: booking.timeSlot);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColor.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Reschedule Session",
                      style: AppTextStyles.title,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  booking.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.primary,
                  ),
                ),
                const Divider(height: 24),

                const Text("New Date/Days:", style: AppTextStyles.caption),
                const SizedBox(height: 8),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9F6F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("New Time Slot:", style: AppTextStyles.caption),
                const SizedBox(height: 8),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9F6F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: "Confirm New Slot",
                    onPressed: () {
                      context.read<BookingProvider>().rescheduleBooking(
                        booking.id,
                        dateController.text.trim(),
                        timeController.text.trim(),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Session "${booking.title}" rescheduled successfully!',
                          ),
                          backgroundColor: AppColor.primary,
                        ),
                      );
                    },
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          final filteredBookings = bookingProvider.bookings.where((b) {
            if (_activeFilter == 'All Bookings') return true;
            if (_activeFilter == 'Upcoming') {
              return b.status == BookingStatus.upcoming;
            }
            if (_activeFilter == 'Completed') {
              return b.status == BookingStatus.completed;
            }
            if (_activeFilter == 'Cancelled') {
              return b.status == BookingStatus.cancelled;
            }
            if (_activeFilter == 'Yoga Sessions') {
              return b.type == BookingType.yoga;
            }
            if (_activeFilter == 'Event Immersions') {
              return b.type == BookingType.event;
            }
            return true;
          }).toList();

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. HERO SECTION
                _buildHeroSection(isDesktop, bookingProvider),

                const SizedBox(height: 60),

                // 2. FILTERS BAR
                _buildFiltersSection(isDesktop),

                const SizedBox(height: 60),

                // 3. BOOKINGS LIST / GRID
                _buildBookingsList(isDesktop, filteredBookings),

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
  Widget _buildHeroSection(bool isDesktop, BookingProvider provider) {
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
          const SectionLabel(text: "MY SANCTUARY RESERVATIONS"),
          const SizedBox(height: 24),
          Text(
            'My Session Bookings & Digital Entry Passes',
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: isDesktop
                  ? 54
                  : (MediaQuery.of(context).size.width < 400 ? 28 : 36),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'View and manage all your upcoming yoga sessions, sacred event immersions, and digital entry passes in one place.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          _buildStatsRow(isDesktop, provider),
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
          "My Bookings",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isDesktop, BookingProvider provider) {
    final stats = [
      {
        "value": "${provider.bookings.length}",
        "label": "TOTAL RESERVATIONS",
        "icon": Icons.bookmark_added_outlined,
      },
      {
        "value": "${provider.upcomingBookings.length}",
        "label": "UPCOMING SESSIONS",
        "icon": Icons.event_available_outlined,
      },
      {
        "value": "${provider.completedBookings.length}",
        "label": "COMPLETED SADHANA",
        "icon": Icons.task_alt_outlined,
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = isDesktop
        ? 220.0
        : (screenWidth < 400 ? double.infinity : (screenWidth - 64) / 2);

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: stats.map((s) {
        return Container(
          width: itemWidth,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F6F1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(s["icon"] as IconData, color: AppColor.primary, size: 24),
              const SizedBox(height: 16),
              Text(
                s["value"]!.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s["label"]!.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 2. FILTERS BAR ---
  Widget _buildFiltersSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
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
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
    );
  }

  // --- 3. BOOKINGS LIST ---
  Widget _buildBookingsList(bool isDesktop, List<BookingItem> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            const Icon(Icons.bookmark_border, size: 64, color: AppColor.grey),
            const SizedBox(height: 16),
            Text(
              'No bookings found for "$_activeFilter".',
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: LayoutBuilder(
        builder: (context, box) {
          int count = isDesktop ? 2 : 1;
          double width = (box.maxWidth - (count - 1) * 24) / count;

          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: items.map((b) => _bookingCard(width, b)).toList(),
          );
        },
      ),
    );
  }

  Widget _bookingCard(double width, BookingItem item) {
    Color statusColor;
    String statusText;

    switch (item.status) {
      case BookingStatus.upcoming:
        statusColor = Colors.green;
        statusText = "CONFIRMED UPCOMING";
        break;
      case BookingStatus.completed:
        statusColor = AppColor.grey;
        statusText = "SADHANA COMPLETED";
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.redAccent;
        statusText = "CANCELLED";
        break;
    }

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
                  color: AppColor.lightPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.type == BookingType.yoga
                      ? "YOGA SESSION"
                      : "EVENT RETREAT",
                  style: AppTextStyles.bulletLabel.copyWith(
                    fontSize: 10,
                    color: AppColor.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            item.title,
            style: AppTextStyles.title.copyWith(
              fontSize: 20,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.event, size: 14, color: AppColor.primary),
              const SizedBox(width: 8),
              Text(
                "${item.date} • ${item.timeSlot}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

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
                  item.location,
                  style: AppTextStyles.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColor.grey),
              const SizedBox(width: 8),
              Text("Guide: ${item.instructor}", style: AppTextStyles.bodySmall),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Pass Code & Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pass: ${item.passCode}",
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Row(
                children: [
                  if (item.status == BookingStatus.upcoming) ...[
                    IconButton(
                      icon: const Icon(Icons.edit_calendar, size: 18),
                      tooltip: "Reschedule",
                      onPressed: () => _showRescheduleDialog(item),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      tooltip: "Cancel Booking",
                      onPressed: () {
                        context.read<BookingProvider>().cancelBooking(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Cancelled booking for "${item.title}".',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  AppButton(
                    text: "View Pass",
                    onPressed: () => _showPassModal(item),
                    isPrimary: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
