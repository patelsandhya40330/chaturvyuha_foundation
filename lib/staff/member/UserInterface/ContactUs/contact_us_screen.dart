import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_text_styles.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _submitContact() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Message Sent (Demo)'),
          content: Text(
            'Hello ${_nameController.text}, your message has been validated. '
            'This is a demo frontend; no real message was transmitted to the foundation office.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        // Page labels
                        Text('CONTACT US', style: AppTextStyles.sectionLabel),
                        const SizedBox(height: 12),
                        Text(
                          'Get in Touch with the Foundation',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Two column layout for desktop: Info vs Form
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 1, child: _buildContactInfo()),
                              const SizedBox(width: 48),
                              Expanded(flex: 1, child: _buildContactForm()),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildContactInfo(),
                              const SizedBox(height: 48),
                              _buildContactForm(),
                            ],
                          ),
                        const SizedBox(height: 64),

                        // Map Placeholder Section
                        Text(
                          'OFFICE LOCATION',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor.primary.withAlpha(20),
                            ),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: AppColor.grey,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Interactive Map Component Placeholder',
                                  style: TextStyle(color: AppColor.grey),
                                ),
                                Text(
                                  '// Integration TODO: Add Google Maps or OpenStreetMaps widget.',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
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

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoCard(
          Icons.location_on_outlined,
          'Address',
          '108 Vedic Enclave, Cultural Heritage District, Global City',
        ),
        const SizedBox(height: 16),
        _infoCard(
          Icons.email_outlined,
          'Email Support',
          'info@chaturvyuha.org',
        ),
        const SizedBox(height: 16),
        _infoCard(Icons.phone_outlined, 'Phone/WhatsApp', '+1 (555) 012-3456'),
        const SizedBox(height: 32),
        Text('FOLLOW OUR SOCIAL UPDATES', style: AppTextStyles.bulletLabel),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            _socialIcon(Icons.facebook),
            _socialIcon(Icons.camera_alt_outlined), // Instagram
            _socialIcon(Icons.smart_display_outlined), // YouTube
          ],
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primary.withAlpha(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColor.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0DC),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColor.primary, size: 24),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0DC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.primary.withAlpha(40)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SEND A QUICK MESSAGE',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _msgController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Your Message',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.length < 10) ? 'Message too short' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Deliver Message →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
