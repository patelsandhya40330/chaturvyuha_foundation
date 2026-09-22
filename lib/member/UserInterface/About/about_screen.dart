import 'package:chaturvyuha_foundation/member/dataProvider/foundation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/member/models/team_member.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                        // 1. Introduction section
                        _buildIntroduction(isDesktop),
                        const SizedBox(height: 48),

                        // 2. Vision and Mission
                        _buildVisionMission(isDesktop),
                        const SizedBox(height: 48),

                        // 3. Logo & Identity explanation
                        _buildLogoExplanation(provider),
                        const SizedBox(height: 48),

                        // 4. History/Timeline
                        _buildTimeline(isDesktop),
                        const SizedBox(height: 48),

                        // 5. Objectives
                        _buildSectionLabel('OUR CORE OBJECTIVES'),
                        const SizedBox(height: 12),
                        Text(
                          'What we work towards',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildObjectives(constraints.maxWidth),
                        const SizedBox(height: 48),

                        // 6. Leadership/Team
                        _buildLeadershipTeam(isDesktop, provider),
                        const SizedBox(height: 48),

                        // 7. Organization & Contact Info
                        _buildOrgAndContact(isDesktop),
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

  Widget _buildIntroduction(bool isDesktop) {
    final introduction = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('ABOUT CHATURVYUHA FOUNDATION'),
        const SizedBox(height: 18),
        Text(
          'Rooted in wisdom.\nUnited in purpose.',
          style: AppTextStyles.heading.copyWith(
            fontSize: isDesktop ? 48 : 34,
            color: AppColor.heading,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Chaturvyuha Foundation is a non-profit spiritual and cultural organization dedicated to preserving ancient heritage, sharing Vedic wisdom, and encouraging a balanced, meaningful way of life.',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: 16),
        const Text(
          'Our multi-faceted purpose encompasses regular spiritual activities, classical yoga systems, structured meditation methodologies, and language instruction to promote wellbeing, planetary harmony, and respectful community integration.',
          style: AppTextStyles.body,
        ),
      ],
    );

    final logo = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Image.asset(
            'assets/chaturvedal-logo.png',
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.spa_outlined,
              size: 100,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'CHATURVEDA FOUNDATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Wisdom • Wellness • Community',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 7, child: introduction),
          const SizedBox(width: 56),
          Expanded(flex: 5, child: logo),
        ],
      );
    }
    return Column(children: [introduction, const SizedBox(height: 28), logo]);
  }

  Widget _buildVisionMission(bool isDesktop) {
    final visionCard = Expanded(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0DC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.primary.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('OUR VISION'),
            const SizedBox(height: 12),
            Text('A Harmonious & Balanced Society', style: AppTextStyles.title),
            const SizedBox(height: 12),
            const Text(
              'To cultivate an enlightened world community where timeless spiritual understanding acts as a guide for sustainable living, unity, and shared social welfare.',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );

    final missionCard = Expanded(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0DC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColor.primary.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('OUR MISSION'),
            const SizedBox(height: 12),
            Text(
              'Preserving Traditions & Inspiring Mindful Living',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 12),
            const Text(
              'To make spiritual learning, authentic Vedic education, classical yoga, and traditional languages fully accessible to individuals across all classes, castes, and backgrounds.',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [visionCard, const SizedBox(width: 24), missionCard],
        ),
      );
    }
    return Column(
      children: [visionCard, const SizedBox(height: 20), missionCard],
    );
  }

  Widget _buildLogoExplanation(FoundationProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('IDENTITY & LOGO MEANING'),
          const SizedBox(height: 14),
          Text(
            'Fictional Placeholder Interpretation',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 12),
          Text(provider.logoExplanation, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildTimeline(bool isDesktop) {
    final timelineEvents = [
      {
        "year": "2021",
        "title": "Foundation Inception",
        "desc":
            "Started as a small scriptural reading circle focused on primary Vedic text analysis.",
      },
      {
        "year": "2022",
        "title": "Community Yoga Launch",
        "desc":
            "Opened virtual and localized introductory breathing training sessions for health relief.",
      },
      {
        "year": "2023",
        "title": "Establishment of Core Center",
        "desc":
            "Acquired physical infrastructure to support direct Sanskrit learning cohorts and seminars.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('OUR JOURNEY TIMELINE'),
        const SizedBox(height: 12),
        Text(
          'Milestones achieved',
          style: AppTextStyles.heading2.copyWith(fontSize: isDesktop ? 36 : 28),
        ),
        const SizedBox(height: 24),
        Column(
          children: timelineEvents
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          e["year"]!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e["title"]!,
                              style: AppTextStyles.title.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(e["desc"]!, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildObjectives(double maxWidth) {
    final objectives = [
      {
        "title": "Spiritual Activities",
        "desc":
            "Organize regular scriptural gatherings and collaborative prayer frameworks.",
      },
      {
        "title": "Culture & Heritage",
        "desc":
            "Promote protection models for ancient traditions and indigenous societal values.",
      },
      {
        "title": "Yoga & Meditation",
        "desc":
            "Teach classical systems to support daily mental clarity and physical balance.",
      },
      {
        "title": "Vedic Education",
        "desc":
            "Foster comprehensive scripture academies for educational social research.",
      },
    ];

    final columns = maxWidth >= 900 ? 2 : 1;
    final cardWidth = (maxWidth - (columns - 1) * 20) / columns;

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: objectives
          .map(
            (obj) => Container(
              width: cardWidth,
              padding: const EdgeInsets.all(24),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColor.primary),
                  const SizedBox(height: 12),
                  Text(obj["title"]!, style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  Text(obj["desc"]!, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLeadershipTeam(bool isDesktop, FoundationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('LEADERSHIP & MASTER TEACHERS'),
        const SizedBox(height: 12),
        Text(
          'Guides along the path',
          style: AppTextStyles.heading2.copyWith(fontSize: isDesktop ? 36 : 28),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            if (isDesktop) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: provider.teamMembers
                      .map(
                        (m) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _buildTeamCard(m),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            }
            return Column(
              children: provider.teamMembers
                  .map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildTeamCard(m),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTeamCard(TeamMember member) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFFFF0DC),
            child: Icon(Icons.person, color: AppColor.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text(member.name, style: AppTextStyles.title.copyWith(fontSize: 18)),
          Text(
            member.role,
            style: AppTextStyles.bulletLabel.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(member.bio, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildOrgAndContact(bool isDesktop) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('OFFICIAL ORGANIZATION INFORMATION'),
        const SizedBox(height: 16),
        Text('Chaturvyuha Foundation (Demo Setup)', style: AppTextStyles.title),
        const SizedBox(height: 12),
        const Text(
          '• Headquarters Placeholder Address: 108 Vedic Enclave, Cultural District',
          style: AppTextStyles.bodySmall,
        ),
        const Text(
          '• Primary Support Email: info@chaturvyuha.org',
          style: AppTextStyles.bodySmall,
        ),
        const Text(
          '• Registration Reference: CF-DEMO-2024-501C3',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 16),
        const Text(
          '// TODO: Replace with official state validation parameters when final parameters are formalized.',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.primary.withAlpha(40)),
      ),
      child: cardContent,
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: AppTextStyles.sectionLabel);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColor.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColor.primary.withAlpha(30)),
    );
  }
}
