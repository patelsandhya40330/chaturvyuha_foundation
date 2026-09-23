import 'package:flutter/material.dart';

import '../admin/presentation/shell/admin_shell.dart';
import '../member/UserInterface/Dashboard/dashboard_screen.dart' as member;
import '../staff/features/staff/dashboard/dashboard_screen.dart' as staff;

enum UserRole { admin, member, staff }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Selected Role for Login & Signup
  UserRole _selectedRole = UserRole.admin;

  // Controllers for Login
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Controllers for Signup
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  void _navigateToRoleDashboard(UserRole role) {
    Widget targetDashboard;
    switch (role) {
      case UserRole.admin:
        targetDashboard = const AdminShell();
        break;
      case UserRole.member:
        targetDashboard = const member.DashboardScreen();
        break;
      case UserRole.staff:
        targetDashboard = const staff.DashboardScreen();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => targetDashboard),
    );
  }

  void _handleLogin() {
    if (_formKeyLogin.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logging in as ${_roleTitle(_selectedRole)}...',
          ),
          backgroundColor: Colors.indigo,
          duration: const Duration(seconds: 1),
        ),
      );
      _navigateToRoleDashboard(_selectedRole);
    }
  }

  void _handleSignup() {
    if (_formKeySignup.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created! Redirecting to ${_roleTitle(_selectedRole)} Dashboard...',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 1),
        ),
      );
      _navigateToRoleDashboard(_selectedRole);
    }
  }

  String _roleTitle(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin Portal';
      case UserRole.member:
        return 'Member Portal';
      case UserRole.staff:
        return 'Staff Portal';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1E1E2C), const Color(0xFF2D2D44)]
                : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Header / Branding
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Chaturvyuha Foundation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Multi-Portal Gateway (Admin, Member, Staff)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: theme.colorScheme.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(icon: Icon(Icons.login), text: 'Login'),
                      Tab(icon: Icon(Icons.person_add), text: 'Sign Up'),
                      Tab(
                        icon: Icon(Icons.flash_on),
                        text: 'Direct Bypass',
                      ),
                    ],
                  ),

                  // Tab Views
                  SizedBox(
                    height: 480,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLoginView(theme),
                        _buildSignupView(theme),
                        _buildBypassView(theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- LOGIN VIEW ---
  Widget _buildLoginView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyLogin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Portal Role',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoleSelector(),
            const SizedBox(height: 20),
            TextFormField(
              controller: _loginEmailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loginPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => (v == null || v.length < 4)
                  ? 'Password must be at least 4 characters'
                  : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleLogin,
                icon: const Icon(Icons.login),
                label: Text(
                  'Login as ${_roleTitle(_selectedRole)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () => _tabController.animateTo(2),
                icon: const Icon(Icons.bolt, color: Colors.orange),
                label: const Text(
                  'Want to bypass login? Click Direct Bypass',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SIGNUP VIEW ---
  Widget _buildSignupView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeySignup,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Account Type',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoleSelector(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signupNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _signupEmailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please enter an email' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _signupPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => (v == null || v.length < 4)
                  ? 'Password must be at least 4 characters'
                  : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSignup,
                icon: const Icon(Icons.person_add),
                label: Text(
                  'Register as ${_roleTitle(_selectedRole)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BYPASS / DIRECT LAUNCHER VIEW ---
  Widget _buildBypassView(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: Colors.orange.shade800),
              const SizedBox(width: 8),
              const Text(
                'Direct Dashboard Launcher',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Bypass login and open any dashboard instantly to inspect or test features:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          _buildBypassCard(
            title: 'Admin Dashboard',
            subtitle: 'Manage events, announcements, courses, & site settings',
            icon: Icons.admin_panel_settings,
            color: const Color(0xFF4F46E5),
            onTap: () => _navigateToRoleDashboard(UserRole.admin),
          ),
          const SizedBox(height: 12),
          _buildBypassCard(
            title: 'Member Dashboard',
            subtitle: 'Explore Vedic articles, dharma content, & media',
            icon: Icons.people_alt,
            color: const Color(0xFF059669),
            onTap: () => _navigateToRoleDashboard(UserRole.member),
          ),
          const SizedBox(height: 12),
          _buildBypassCard(
            title: 'Staff Dashboard',
            subtitle: 'Internal operational workflow & staff task manager',
            icon: Icons.badge,
            color: const Color(0xFFD97706),
            onTap: () => _navigateToRoleDashboard(UserRole.staff),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: UserRole.values.map((role) {
        final isSelected = _selectedRole == role;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                role.name.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) {
                setState(() => _selectedRole = role);
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBypassCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
