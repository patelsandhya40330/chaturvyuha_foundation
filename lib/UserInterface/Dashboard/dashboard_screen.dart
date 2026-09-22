import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/utils/app_constants.dart';

import '../About/about_screen.dart';
import '../Articles/articles_screen.dart';
import '../BecomeMember/become_member_screen.dart';
import '../ContactUs/contact_us_screen.dart';
import '../Home/home_screen.dart';
import '../dharma_sanskriti_screen/dharma_sanskriti_screen.dart';
import '../Media/media_screen.dart';
import '../YogaAndMeditation/yoga_meditation_screen.dart';
import '../Events/events_screen.dart';

// Edit shared dashboard dimensions and breakpoints here.
class _DashboardLayout {
  static const tablet = 600.0;
  static const desktop = 1100.0;
  static const logoSize = 50.0;
  static const logoAsset = 'assets/chaturvedal-logo.png';
  static const memberIndex = 8;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // A key accesses this Scaffold safely from callbacks above its context.
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Keep these indices aligned with AppConstants.navigationItems.
    _pages = [
      HomeScreen(onTabSelected: _selectPage), // 0
      const AboutScreen(), // 1
      const YogaMeditationScreen(), // 2
      const DharmaSanskritiScreen(), // 3
      const EventsScreen(), // 4
      const ArticlesScreen(), // 5
      const MediaScreen(), // 6
      const ContactUsScreen(), // 7
      const BecomeMemberScreen(), // 8
    ];
  }

  void _selectPage(int index) {
    if (!mounted) return;
    if (index < 0 || index >= _pages.length) {
      debugPrint('Dashboard: invalid page index $index (expected 0–8).');
      return;
    }
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _scaffoldKey.currentState?.closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: true,
      endDrawer: _DashboardDrawer(
        selectedIndex: _selectedIndex,
        onSelected: _selectPage,
        onClose: () => _scaffoldKey.currentState?.closeEndDrawer(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _DashboardHeader(
                  onMembership: () => _selectPage(_DashboardLayout.memberIndex),
                  onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
                Expanded(
                  child: IndexedStack(index: _selectedIndex, children: _pages),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onMembership, required this.onMenu});

  final VoidCallback onMembership;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final desktop = width >= _DashboardLayout.desktop;
        final mobile = width < _DashboardLayout.tablet;
        final brand = _Brand(desktop: desktop);

        // On mobile screens, present a clean single row: Brand on left, Menu icon on right.
        if (mobile) {
          return Material(
            color: AppColor.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: brand),
                  IconButton(
                    tooltip: 'Open Navigation Menu',
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: onMenu,
                  ),
                ],
              ),
            ),
          );
        }

        // On desktop/tablet, display brand on left and action controls on right.
        final controls = Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _MembershipButton(onPressed: onMembership),
            const _ProfileAvatar(),
            IconButton(
              tooltip: 'Open Navigation Menu',
              icon: const Icon(Icons.menu),
              onPressed: onMenu,
            ),
          ],
        );

        return Material(
          color: AppColor.backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width >= 1400 ? 60 : 24,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(child: brand),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: controls),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.desktop});
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Logo(size: _DashboardLayout.logoSize),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'CHATURVEDA\nFoundations',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: AppTextStyles.heading2.copyWith(
              color: AppColor.primary,
              fontSize: desktop ? 18 : 16,
              letterSpacing: 1.5,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _DashboardLayout.logoAsset,
      color: AppColor.primary,
      width: size,
      height: size,
      fit: BoxFit.contain,
      semanticLabel: 'CHATURVEDA Foundation logo',
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error, size: size, color: AppColor.primary);
      },
    );
  }
}

class _MembershipButton extends StatelessWidget {
  const _MembershipButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      child: const Text(
        'Become a Member',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  void _showUserInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: AppColor.surface,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Row with Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close Profile',
                    ),
                  ),

                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.primary, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColor.primary,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  const Text(
                    'Acharya Seeker',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.heading,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    'seeker@chaturvyuha.org',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.bodyText.withAlpha(180),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Membership Tag Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.primary.withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColor.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sadhaka Member • Active',
                          style: AppTextStyles.bulletLabel.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Quick Info Rows
                  _infoRow(Icons.card_membership, 'Member ID', 'CF-2024-8809'),
                  const SizedBox(height: 8),
                  _infoRow(Icons.calendar_today, 'Joined', 'January 15, 2024'),

                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Profile settings opened successfully',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings, size: 18),
                      label: const Text('Account Settings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out of Seeker Account'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 18,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.primary),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(value, style: AppTextStyles.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'User profile',
      button: true,
      child: Tooltip(
        message: 'View User Profile',
        child: InkWell(
          onTap: () => _showUserInfo(context),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.border, width: 1.5),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primary,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({
    required this.selectedIndex,
    required this.onSelected,
    required this.onClose,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textHeight = MediaQuery.textScalerOf(context).scale(14);
            final stickyMembership =
                constraints.maxHeight >= 420 && textHeight <= 21;
            final membership = Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: _MembershipButton(
                  onPressed: () => onSelected(_DashboardLayout.memberIndex),
                ),
              ),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _DrawerBrand(onClose: onClose),
                      for (var index = 0; index < 8; index++)
                        ListTile(
                          title: Text(_navigationLabel(index)),
                          selected: selectedIndex == index,
                          selectedColor: AppColor.primary,
                          onTap: () => onSelected(index),
                        ),
                      if (!stickyMembership) ...[
                        const Divider(height: 1),
                        membership,
                      ],
                    ],
                  ),
                ),
                if (stickyMembership) ...[const Divider(height: 1), membership],
              ],
            );
          },
        ),
      ),
    );
  }

  String _navigationLabel(int index) {
    const fallback = [
      'Home',
      'About',
      'Yoga & Meditation',
      'Dharma & Sanskriti',
      'Events',
      'Articles',
      'Media',
      'Contact Us',
    ];
    final labels = AppConstants.navigationItems;
    return index < labels.length ? labels[index] : fallback[index];
  }
}

class _DrawerBrand extends StatelessWidget {
  const _DrawerBrand({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColor.primary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Close Navigation Menu',
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            const Center(child: _Logo(size: 60)),
            const SizedBox(height: 12),

            const Text(
              'CHATURVEDA',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'Foundations',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
