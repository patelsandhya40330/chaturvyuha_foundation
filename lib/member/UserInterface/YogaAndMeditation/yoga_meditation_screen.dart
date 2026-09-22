import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/member/models/yoga_program.dart';

import '../../dataProvider/foundation_provider.dart';

class YogaMeditationScreen extends StatefulWidget {
  const YogaMeditationScreen({super.key});

  @override
  State<YogaMeditationScreen> createState() => _YogaMeditationScreenState();
}

class _YogaMeditationScreenState extends State<YogaMeditationScreen> {
  String _activeFilter = 'ALL';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedProgram = 'Vedic Hatha Yoga Flow';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Demo Registration Entry'),
          content: Text(
            'Thank you, ${_nameController.text}. This is a working frontend prototype demonstration. '
            'Your request for "$_selectedProgram" was validated locally, but no remote data transactions were processed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nameController.clear();
                _emailController.clear();
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
    final filteredPrograms = provider.yogaPrograms.where((p) {
      if (_activeFilter == 'ALL') return true;
      if (_activeFilter == 'YOGA') return p.type == ProgramType.yoga;
      return p.type == ProgramType.meditation;
    }).toList();

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
                        // Title / Header Labels
                        Text(
                          'YOGA & MEDITATION',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Experience Inner Stillness',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Join structured programs offering authentic holistic health practices, vital energy balancing, and profound mental focus.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        // Filter Navigation Tabs
                        Row(
                          children: ['ALL', 'YOGA', 'MEDITATION'].map((tab) {
                            final bool isActive = _activeFilter == tab;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ChoiceChip(
                                label: Text(tab),
                                selected: isActive,
                                onSelected: (val) {
                                  if (val) setState(() => _activeFilter = tab);
                                },
                                selectedColor: AppColor.primary,
                                labelStyle: TextStyle(
                                  color: isActive ? Colors.white : Colors.black,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Programs Grid
                        LayoutBuilder(
                          builder: (context, boxConstraints) {
                            final double cardWidth = isDesktop
                                ? (boxConstraints.maxWidth - 20) / 2
                                : boxConstraints.maxWidth;
                            return Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: filteredPrograms.map((program) {
                                return Container(
                                  width: cardWidth,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppColor.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColor.primary.withAlpha(30),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            program.type == ProgramType.yoga
                                                ? Icons.spa_outlined
                                                : Icons.psychology_outlined,
                                            color: AppColor.primary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            program.type == ProgramType.yoga
                                                ? 'YOGA'
                                                : 'MEDITATION',
                                            style: AppTextStyles.bulletLabel,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        program.title,
                                        style: AppTextStyles.title,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        program.description,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(height: 16),
                                      Divider(
                                        color: AppColor.primary.withAlpha(20),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_outline,
                                            size: 16,
                                            color: AppColor.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Guide: ${program.instructor}',
                                            style: AppTextStyles.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: AppColor.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              program.schedule,
                                              style: AppTextStyles.bodySmall,
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
                        const SizedBox(height: 48),

                        // Form Section
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
                                  'PROGRAM REGISTRATION',
                                  style: AppTextStyles.sectionLabel,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Secure Your Session Seat',
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Name Input Field
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? 'Please enter your name'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Email Input Field
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email Address',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || !value.contains('@'))
                                      ? 'Please enter a valid email address'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Program Dropdown selector
                                DropdownButtonFormField<String>(
                                  value: _selectedProgram,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Program Cohort',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: provider.yogaPrograms.map((p) {
                                    return DropdownMenuItem<String>(
                                      value: p.title,
                                      child: Text(p.title),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedProgram = val);
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Submit action trigger button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitRegistration,
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
                                      'Submit Application Request →',
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
