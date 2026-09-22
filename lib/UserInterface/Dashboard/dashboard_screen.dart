import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/utils/app_constants.dart';
import 'package:flutter/material.dart';

// Import all functional screens
import '../About/about_screen.dart';
import '../BecomeMember/become_member_screen.dart';
import '../ContactUs/contact_us_screen.dart';
import '../Home/home_screen.dart';
import '../dharma_sanskriti_screen/dharma_sanskriti_screen.dart';
import '../Education/education_screen.dart';
import '../Media/media_screen.dart';
import '../YogaAndMeditation/yoga_meditation_screen.dart';
import '../Events/events_screen.dart';
import '../Knowledge/knowledge_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  final List<String> _navigation = AppConstants.navigationItems;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ), // 0
      const AboutScreen(),
      const DharmaSanskritiScreen(),
      const YogaMeditationScreen(),
      const EducationScreen(),
      const EventsScreen(),
      const KnowledgeScreen(),
      const MediaScreen(),
      const ContactUsScreen(),
      const BecomeMemberScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Breakpoint matches the wide layout requirement from screenshot
    final bool isDesktop = MediaQuery.of(context).size.width >= 1300;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 90, // Slightly taller for the branding
        titleSpacing: isDesktop ? 60 : 15,
        title: _buildLogoWithText(isDesktop),
        actions: isDesktop
            ? [
                // Navigation items mapped to correct pages
                _menuButton(text: "Home", index: 0),
                _menuButton(text: "Dharma &\nSanskriti", index: 2),
                _menuButton(text: "Yoga &\nMeditation", index: 3),
                _menuButton(text: "Education", index: 4),
                _menuButton(text: "Events &\nPrograms", index: 5),
                _menuButton(text: "Media", index: 7),
                _menuButton(text: "Contact Us", index: 8),

                _moreMenuButton(),

                const SizedBox(width: 12),

                // Utility Icons
                IconButton(
                  tooltip: 'Search',
                  icon: const Icon(
                    Icons.search,
                    color: AppColor.heading,
                    size: 22,
                  ),
                  onPressed: () => ('Search'),
                ),
                IconButton(
                  tooltip: 'Notifications',
                  icon: const Icon(
                    Icons.notifications_none,
                    color: AppColor.heading,
                    size: 22,
                  ),
                  onPressed: () => ('Notifications'),
                ),

                const SizedBox(width: 16),

                // "Become a Member" Button
                _membershipButton(index: 9),

                const SizedBox(width: 16),

                // Profile Avatar
                _profileAvatar(),

                const SizedBox(width: 40),
              ]
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Open menu',
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ),
              ],
      ),
      endDrawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerHeader(),
                  ...List.generate(
                    _navigation.length,
                    ((index) => _sideListTile(
                      context,
                      text: _navigation[index],
                      index: index,
                    )),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _membershipButton(index: 9, isFullWidth: true),
                  ),
                ],
              ),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
        ],
      ),
    );
  }

  // Branding: Logo + Title + Tagline
  Widget _buildLogoWithText(bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Foundation Logo Image
        Image.asset("assets/chaturvedal-logo.png", height: 50),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CHATURVEDA\nFoundations ",
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColor.primary,
                  fontSize: isDesktop ? 18 : 16, // Smaller font on mobile
                  letterSpacing: 1.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Desktop Nav Button
  Widget _menuButton({required String text, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => setState(() => _selectedIndex = index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? AppColor.primary.withAlpha(25)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: isSelected
              ? AppTextStyles.navButtonActive
              : AppTextStyles.navButton,
        ),
      ),
    );
  }

  // Dropdown for About/Knowledge
  Widget _moreMenuButton() {
    return PopupMenuButton<int>(
      tooltip: 'More options',
      onSelected: (index) => setState(() => _selectedIndex = index),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 1, child: Text("About Foundation")),
        const PopupMenuItem(value: 6, child: Text("Knowledge & Articles")),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Text("More", style: AppTextStyles.navButton),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColor.heading,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // Become a Member Styled Button
  Widget _membershipButton({required int index, bool isFullWidth = false}) {
    return ElevatedButton(
      onPressed: () => setState(() => _selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: AppColor.primary.withAlpha(102),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Become a Member",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }

  // Profile Avatar
  Widget _profileAvatar() {
    return InkWell(
      onTap: () => ('Profile'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.border),
        ),
        child: const CircleAvatar(
          radius: 18,
          backgroundColor: AppColor.primary,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // Drawer Header
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: AppColor.primary),
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Close button (X sign)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Logo and Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/chaturvedal-logo.png",
                  height: 60,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.spa, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 12),
                const Text(
                  "CHATURVEDA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  "Foundations",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Side List Tile
  ListTile _sideListTile(
    BuildContext context, {
    required String text,
    required int index,
  }) {
    return ListTile(
      title: Text(text),
      selected: _selectedIndex == index,
      selectedColor: AppColor.primary,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
