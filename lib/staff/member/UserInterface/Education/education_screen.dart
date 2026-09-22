import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/member/models/course_item.dart';

import '../../dataProvider/foundation_provider.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCourse = 'Foundations of Upanishadic Wisdom';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitEnrollment() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Demo Enrollment Success'),
          content: Text(
            'Hello ${_nameController.text}, your enrollment validation was successful. '
            'This is a local prototype demo; no information was transmitted to remote servers.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _nameController.clear();
                _phoneController.clear();
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
                        // Section headers
                        Text(
                          'VEDIC EDUCATION',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Empower Through Academy Knowledge',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Structured lineage academies providing classical models for Sanskrit grammar analysis and sacred philosophy structures.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        // Courses listing loop
                        Text(
                          'AVAILABLE COURSE ACADEMIES',
                          style: AppTextStyles.title.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: provider.courses.map((course) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(28),
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
                                      const Icon(
                                        Icons.school_outlined,
                                        color: AppColor.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        course.duration.toUpperCase(),
                                        style: AppTextStyles.bulletLabel,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    course.title,
                                    style: AppTextStyles.title,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    course.description,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 16),

                                  // Topics tags chips
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: course.topics
                                        .map(
                                          (t) => Chip(
                                            backgroundColor: const Color(
                                              0xFFFFF0DC,
                                            ),
                                            label: Text(
                                              t,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColor.primary,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  Divider(
                                    color: AppColor.primary.withAlpha(20),
                                  ),
                                  const SizedBox(height: 12),

                                  // Instructor and schedule meta
                                  Text(
                                    '• Lead Faculty: ${course.instructor}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  Text(
                                    '• Class Schedule: ${course.schedule}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 12),

                                  // Resources lists
                                  Text(
                                    'LEARNING RESOURCES:',
                                    style: AppTextStyles.bulletLabel.copyWith(
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ...course.resources.map(
                                    (res) => Text(
                                      '- $res (Sample Reference Asset Link)',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColor.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 48),

                        // Academy Enrollment Form widget
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
                                  'ACADEMY ADMISSION ENROLLMENT',
                                  style: AppTextStyles.sectionLabel,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Apply For a Course Placement',
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Name form field input
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Student Full Name',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                      ? 'Please fill in student name'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Contact phone form field
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Contact Phone Number',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.trim().length < 6)
                                      ? 'Please enter a valid telephone link'
                                      : null,
                                ),
                                const SizedBox(height: 16),

                                // Dropdown course selections
                                DropdownButtonFormField<String>(
                                  value: _selectedCourse,
                                  decoration: const InputDecoration(
                                    labelText: 'Select Target Course',
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                  items: provider.courses.map((c) {
                                    return DropdownMenuItem<String>(
                                      value: c.title,
                                      child: Text(c.title),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null)
                                      setState(() => _selectedCourse = val);
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Form trigger submit action button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitEnrollment,
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
                                      'Submit Academy Form →',
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
