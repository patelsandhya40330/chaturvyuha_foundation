import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AppFooter extends StatelessWidget {
  final bool isDesktop;

  const AppFooter({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F2EB), // Warm sanctuary ivory tint
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Logo Column
                    Expanded(flex: 3, child: _buildBrandColumn()),
                    const SizedBox(width: 48),
                    // Links Column 1: WISDOM WINGS
                    Expanded(
                      flex: 2,
                      child: _footerColumn("WISDOM WINGS", [
                        "The Upanishads & Veda",
                        "Prātah & Sandhyā Sādhana",
                        "Vedic Research Papers",
                        "Archival Manuscripts",
                      ]),
                    ),
                    // Links Column 2: SANCTUARY & SEVA
                    Expanded(
                      flex: 2,
                      child: _footerColumn("SANCTUARY & SEVA", [
                        "Festival & Yajna Calendar",
                        "Goshala & Cow Protection",
                        "Anna Dāna Seva",
                        "Sanctuary Maintenance",
                      ]),
                    ),
                    // Links Column 3: PANINI PATHSHALA
                    Expanded(
                      flex: 2,
                      child: _footerColumn("PANINI PATHSHALA", [
                        "Sanskrit Grammar Cohorts",
                        "Sāmasvera Chanting Academy",
                        "Youth Vedic Heritage",
                        "Online Darshan Portal",
                      ]),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandColumn(),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 32,
                      runSpacing: 32,
                      children: [
                        _footerColumn("WISDOM WINGS", [
                          "The Upanishads & Veda",
                          "Prātah & Sandhyā Sādhana",
                          "Vedic Research Papers",
                        ]),
                        _footerColumn("SANCTUARY & SEVA", [
                          "Festival & Yajna Calendar",
                          "Goshala & Cow Protection",
                          "Anna Dāna Seva",
                        ]),
                        _footerColumn("PANINI PATHSHALA", [
                          "Sanskrit Grammar Cohorts",
                          "Sāmasvera Chanting Academy",
                        ]),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 50),
              Divider(color: AppColor.border.withAlpha(120), height: 1),
              const SizedBox(height: 30),

              // Bottom bar with Copyright, Contact, and Legal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "© 2024 Chaturveda Foundation. All Rights Reserved.  •  +91 98765 43210",
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: AppColor.bodyText.withAlpha(180),
                      ),
                    ),
                  ),
                  if (isDesktop)
                    Row(
                      children: [
                        Text(
                          "Terms & Conditions",
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          "Privacy Safeguards",
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          "Seva & Refund Rules",
                          style: AppTextStyles.caption.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Brand Column with assets/chaturvedal-logo.png
  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Logo Image replaced as requested
            Image.asset(
              "assets/chaturvedal-logo.png",
              color: AppColor.primary,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.spa, color: AppColor.primary, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chaturveda Sanctuary",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: AppColor.heading,
                    ),
                  ),
                  Text(
                    "WISDOM • WELLNESS • COMMUNITY",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.bulletLabel.copyWith(
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          "Preserving, promoting, and perpetuating ancient Vedic knowledge, authentic classical systems of human wellbeing, sacred art forms, and indigenous environmental frameworks.",
          style: AppTextStyles.bodySmall.copyWith(
            height: 1.6,
            color: AppColor.bodyText.withAlpha(200),
          ),
        ),
        const SizedBox(height: 20),

        // Highlight box matching screenshot (PANCHALA DI DEEPA / QUOTE)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFE8DD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PANCHALA DI DEEPA",
                style: AppTextStyles.sectionLabel.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "“Truth is one, sages call it by various names.” — Rig Veda (1.164.46)",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColor.heading.withAlpha(220),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.5,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {},
              child: Text(
                link,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColor.bodyText,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
