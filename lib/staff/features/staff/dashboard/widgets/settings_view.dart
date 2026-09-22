import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/dialogs.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Profile Form Controllers
  final _fullNameController = TextEditingController(text: 'Acharya Dev');
  final _emailController = TextEditingController(text: 'acharya.dev@cfoundation.org');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _departmentController = TextEditingController(text: 'Vedic Research & Administration');
  final String _staffId = 'STF-8842';

  // Security Form Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Preferences State
  String _selectedTheme = 'System Default';
  String _selectedLanguage = 'English (US)';
  String _selectedDateFormat = 'YYYY-MM-DD';

  // Notification Toggles
  bool _emailNotifications = true;
  bool _newMessageNotifications = true;
  bool _eventNotifications = true;
  bool _contentReviewNotifications = false;
  bool _systemNotifications = true;

  // Appearance Controls
  String _colorMode = 'Light';
  String _layoutDensity = 'Comfortable';
  String _fontSize = 'Normal';

  bool _isEditingProfile = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      _isEditingProfile = false;
    });
    UIUtils.showSuccessMessage(context, 'Staff profile updated successfully.');
  }

  void _updatePassword() {
    if (_newPasswordController.text.isEmpty) {
      UIUtils.showErrorMessage(context, 'Please enter a valid new password.');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      UIUtils.showErrorMessage(context, 'New password and confirmation do not match.');
      return;
    }
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    UIUtils.showSuccessMessage(context, 'Security password updated successfully.');
  }

  void _savePreferences() {
    UIUtils.showSuccessMessage(context, 'Preferences updated successfully.');
  }

  void _saveNotifications() {
    UIUtils.showSuccessMessage(context, 'Notification settings saved.');
  }

  void _saveAppearance() {
    UIUtils.showSuccessMessage(context, 'Appearance settings applied.');
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: AppSizes.s24),
          _buildTabBar(isMobile),
          const SizedBox(height: AppSizes.s24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildPreferencesTab(),
                _buildNotificationsTab(),
                _buildSecurityTab(),
                _buildAppearanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          tooltip: 'Back',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Staff Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage your profile, preferences, notifications, security, and interface appearance.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: isMobile ? 12 : 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(bool isMobile) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.person_outline, size: 20), text: 'Profile'),
          Tab(icon: Icon(Icons.tune_outlined, size: 20), text: 'Preferences'),
          Tab(icon: Icon(Icons.notifications_none_outlined, size: 20), text: 'Notifications'),
          Tab(icon: Icon(Icons.lock_outline, size: 20), text: 'Security'),
          Tab(icon: Icon(Icons.palette_outlined, size: 20), text: 'Appearance'),
        ],
      ),
    );
  }

  // TAB 1: Profile
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Staff Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (!_isEditingProfile)
                        SecondaryButton(
                          onPressed: () => setState(() => _isEditingProfile = true),
                          icon: Icons.edit_outlined,
                          label: 'Edit Profile',
                        )
                      else
                        PrimaryButton(
                          onPressed: _saveProfile,
                          icon: Icons.check,
                          label: 'Save Changes',
                        ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: const Text(
                          'AD',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: AppSizes.s24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_fullNameController.text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                            ),
                            child: Text(
                              'Staff ID: $_staffId',
                              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s32),
                  ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _buildProfileField('Full Name', _fullNameController, _isEditingProfile),
                        const SizedBox(height: 16),
                        _buildProfileField('Email Address', _emailController, _isEditingProfile, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        _buildProfileField('Phone Number', _phoneController, _isEditingProfile, keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildProfileField('Department', _departmentController, _isEditingProfile),
                      ],
                    ),
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildProfileField('Full Name', _fullNameController, _isEditingProfile),
                              const SizedBox(height: 16),
                              _buildProfileField('Phone Number', _phoneController, _isEditingProfile, keyboardType: TextInputType.phone),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildProfileField('Email Address', _emailController, _isEditingProfile, keyboardType: TextInputType.emailAddress),
                              const SizedBox(height: 16),
                              _buildProfileField('Department', _departmentController, _isEditingProfile),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, bool isEditable, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: isEditable,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isEditable ? AppColors.textPrimary : AppColors.textBody,
            fontWeight: isEditable ? FontWeight.w600 : FontWeight.normal,
          ),
          decoration: InputDecoration(
            filled: !isEditable,
            fillColor: isEditable ? AppColors.surface : AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
          ),
        ),
      ],
    );
  }

  // TAB 2: Preferences
  Widget _buildPreferencesTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('System Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Customize default workspace themes, regional language, and date display formats.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Divider(height: 32),
                  _buildDropdownRow(
                    title: 'Workspace Theme',
                    subtitle: 'Choose preferred color mode for dashboard interfaces.',
                    value: _selectedTheme,
                    items: const ['Light Mode', 'Dark Mode', 'System Default'],
                    onChanged: (val) => setState(() => _selectedTheme = val!),
                  ),
                  const Divider(height: 32),
                  _buildDropdownRow(
                    title: 'Language',
                    subtitle: 'Set preferred interface localization language.',
                    value: _selectedLanguage,
                    items: const ['English (US)', 'Hindi (हिंदी)', 'Sanskrit (संस्कृतम्)'],
                    onChanged: (val) => setState(() => _selectedLanguage = val!),
                  ),
                  const Divider(height: 32),
                  _buildDropdownRow(
                    title: 'Date Format',
                    subtitle: 'Select regional date display format.',
                    value: _selectedDateFormat,
                    items: const ['YYYY-MM-DD', 'DD/MM/YYYY', 'MM/DD/YYYY'],
                    onChanged: (val) => setState(() => _selectedDateFormat = val!),
                  ),
                  const SizedBox(height: AppSizes.s24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPressed: _savePreferences,
                      label: 'Save Preferences',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ResponsiveLayout(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
          ),
        ],
      ),
      desktop: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              initialValue: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Notifications
  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notification Alerts & Channels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Manage push and email alerts for staff dashboard events.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Divider(height: 32),
                  _buildSwitchRow(
                    title: 'Email Notifications',
                    subtitle: 'Receive daily digests and critical workspace updates via email.',
                    value: _emailNotifications,
                    onChanged: (val) => setState(() => _emailNotifications = val),
                  ),
                  const Divider(height: 24),
                  _buildSwitchRow(
                    title: 'New Message Notifications',
                    subtitle: 'Get notified when receiving direct staff messages or chat responses.',
                    value: _newMessageNotifications,
                    onChanged: (val) => setState(() => _newMessageNotifications = val),
                  ),
                  const Divider(height: 24),
                  _buildSwitchRow(
                    title: 'Event & Program Alerts',
                    subtitle: 'Receive reminders for scheduled seminars, workshops, and gatherings.',
                    value: _eventNotifications,
                    onChanged: (val) => setState(() => _eventNotifications = val),
                  ),
                  const Divider(height: 24),
                  _buildSwitchRow(
                    title: 'Content Review Notifications',
                    subtitle: 'Get alerted when articles or pages require peer approval.',
                    value: _contentReviewNotifications,
                    onChanged: (val) => setState(() => _contentReviewNotifications = val),
                  ),
                  const Divider(height: 24),
                  _buildSwitchRow(
                    title: 'System & Maintenance Alerts',
                    subtitle: 'Important notices regarding server updates and portal security.',
                    value: _systemNotifications,
                    onChanged: (val) => setState(() => _systemNotifications = val),
                  ),
                  const SizedBox(height: AppSizes.s24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPressed: _saveNotifications,
                      label: 'Save Notification Settings',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      value: value,
      activeThumbColor: AppColors.primary,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  // TAB 4: Security
  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Change Password Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Change Account Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Ensure your account uses a strong, unique password.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Divider(height: 24),
                  ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _buildPasswordField('Current Password', _currentPasswordController),
                        const SizedBox(height: 16),
                        _buildPasswordField('New Password', _newPasswordController),
                        const SizedBox(height: 16),
                        _buildPasswordField('Confirm New Password', _confirmPasswordController),
                      ],
                    ),
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildPasswordField('Current Password', _currentPasswordController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPasswordField('New Password', _newPasswordController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPasswordField('Confirm New Password', _confirmPasswordController)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPressed: _updatePassword,
                      icon: Icons.lock_reset,
                      label: 'Update Password',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s24),

          // Active Sessions & Login Audit Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Active Login Sessions & Security Audit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Review active sessions and recent authentication logs.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Divider(height: 24),
                  _buildSessionItem(
                    device: 'macOS Workstation (Chrome)',
                    location: 'New Delhi, India • IP: 192.168.1.45',
                    time: 'Current Active Session',
                    isCurrent: true,
                  ),
                  const Divider(height: 16),
                  _buildSessionItem(
                    device: 'Android Mobile App',
                    location: 'New Delhi, India • IP: 10.0.0.88',
                    time: 'Last active: Today, 08:30 AM',
                    isCurrent: false,
                  ),
                  const SizedBox(height: AppSizes.s24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Last Password Change: 45 days ago', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: 'Sign Out All Other Sessions?',
                              confirmLabel: 'Sign Out Others',
                              confirmColor: AppColors.error,
                              onConfirm: () {
                                Navigator.pop(context);
                                UIUtils.showSuccessMessage(context, 'Signed out of all other devices.');
                              },
                              content: const Text('Are you sure you want to revoke active tokens on all other devices?'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Log Out Other Sessions'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '••••••••',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMedium)),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem({
    required String device,
    required String location,
    required String time,
    required bool isCurrent,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isCurrent ? AppColors.success : AppColors.primary).withOpacity( 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Icon(
            isCurrent ? Icons.laptop_mac : Icons.phone_android,
            color: isCurrent ? AppColors.success : AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  if (isCurrent) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity( 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('This Device', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text('$location • $time', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  // TAB 5: Appearance
  Widget _buildAppearanceTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Interface & Layout Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Customize color palette mode, layout density, and font scaling.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const Divider(height: 32),

                  // Color Mode Selection
                  const Text('Color Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ResponsiveLayout(
                    mobile: Column(
                      children: [
                        _buildThemeCard('Light', Icons.light_mode_outlined, 'Default clean light theme'),
                        const SizedBox(height: 12),
                        _buildThemeCard('Dark', Icons.dark_mode_outlined, 'High contrast dark theme'),
                        const SizedBox(height: 12),
                        _buildThemeCard('System', Icons.settings_suggest_outlined, 'Follow OS preferences'),
                      ],
                    ),
                    desktop: Row(
                      children: [
                        Expanded(child: _buildThemeCard('Light', Icons.light_mode_outlined, 'Default clean light theme')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildThemeCard('Dark', Icons.dark_mode_outlined, 'High contrast dark theme')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildThemeCard('System', Icons.settings_suggest_outlined, 'Follow OS preferences')),
                      ],
                    ),
                  ),

                  const Divider(height: 32),

                  // Layout Density
                  _buildDropdownRow(
                    title: 'Layout Density',
                    subtitle: 'Choose item spacing for tables and list cards.',
                    value: _layoutDensity,
                    items: const ['Comfortable', 'Compact (High Density)'],
                    onChanged: (val) => setState(() => _layoutDensity = val!),
                  ),

                  const Divider(height: 32),

                  // Font Size
                  _buildDropdownRow(
                    title: 'Font Scale Accessibility',
                    subtitle: 'Adjust text size across dashboard components.',
                    value: _fontSize,
                    items: const ['Small', 'Normal', 'Large'],
                    onChanged: (val) => setState(() => _fontSize = val!),
                  ),

                  const SizedBox(height: AppSizes.s24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPressed: _saveAppearance,
                      label: 'Apply Appearance',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String title, IconData icon, String description) {
    final bool isSelected = _colorMode == title;

    return InkWell(
      onTap: () => setState(() => _colorMode = title),
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
