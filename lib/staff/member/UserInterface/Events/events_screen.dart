import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/staff/member/models/event_item.dart';

import '../../dataProvider/foundation_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedEventTitle = 'Global Peace Chant Gathering';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return Colors.blue;
      case EventStatus.live:
        return Colors.green;
      case EventStatus.completed:
        return Colors.grey;
      case EventStatus.cancelled:
        return Colors.red;
    }
  }

  void _registerForEvent() {
    final provider = context.read<FoundationProvider>();
    final eventObj = provider.events.firstWhere(
      (e) => e.title == _selectedEventTitle,
    );

    // REQUIREMENT: Disable registration for completed or cancelled events
    if (eventObj.status == EventStatus.completed ||
        eventObj.status == EventStatus.cancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration is disabled for completed or cancelled events.',
          ),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Event Registration Entry'),
          content: Text(
            'Thank you ${_nameController.text}. Your registration for \"$_selectedEventTitle\" has been validated locally. '
            'This is a demo frontend application; no remote database entries were saved.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nameController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoundationProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 56 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section labels headers
                        Text(
                          'EVENTS & PROGRAMS',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Join Our Gathering Communities',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Track full event schedules, check active live statuses, browse historic event image galleries, and secure admission.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        // Event Cards Loops
                        Text(
                          'ALL SCHEDULED EVENTS',
                          style: AppTextStyles.title.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: provider.events.map((ev) {
                            final bool isActionDisabled =
                                ev.status == EventStatus.completed ||
                                ev.status == EventStatus.cancelled;

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColor.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColor.primary.withAlpha(30),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(
                                            ev.status,
                                          ).withAlpha(30),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          ev.status.name.toUpperCase(),
                                          style: TextStyle(
                                            color: _getStatusColor(ev.status),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: AppColor.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${ev.date.day}/${ev.date.month}/${ev.date.year}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(ev.title, style: AppTextStyles.title),
                                  const SizedBox(height: 8),
                                  Text(
                                    ev.description,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppColor.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        ev.time,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(width: 24),
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: AppColor.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          ev.location,
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Event Gallery images conditional
                                  if (ev.galleryImages.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'EVENT GALLERY HIGHLIGHTS:',
                                      style: AppTextStyles.bulletLabel,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 12,
                                      children: ev.galleryImages
                                          .map(
                                            (img) => Container(
                                              width: 80,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: AppColor.primary
                                                      .withAlpha(40),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  img,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (c, e, s) =>
                                                      const Icon(Icons.image),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],

                                  if (isActionDisabled) ...[
                                    const SizedBox(height: 16),
                                    const Text(
                                      '// Registration disabled because this event is either completed or cancelled.',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 48),

                        // Registration Form Container
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0DC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColor.primary.withAlpha(40),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RESERVE ADMISSION TICKET',
                                  style: AppTextStyles.sectionLabel,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Event Registration Placement',
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Name input field
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Attendee Full Name',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? 'Please type full name'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown target selectors
                                DropdownButtonFormField<String>(
                                  value: _selectedEventTitle,
                                  decoration: const InputDecoration(
                                    labelText: 'Choose Target Event',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: provider.events.map((e) {
                                    return DropdownMenuItem<String>(
                                      value: e.title,
                                      child: Text(e.title),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null)
                                      setState(() => _selectedEventTitle = val);
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Ticket submission button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _registerForEvent,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Confirm Local Reservation Ticket →',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
