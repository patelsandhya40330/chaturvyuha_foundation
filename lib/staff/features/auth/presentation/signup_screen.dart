import 'package:cfoundation/core/routing/app_router.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _generalErrorMessage;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final String password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.transparent;
      });
      return;
    }

    double strength = 0.0;
    if (password.length >= 6) strength += 0.3;
    if (password.length >= 10) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
      if (strength <= 0.3) {
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = AppColors.error;
      } else if (strength <= 0.6) {
        _passwordStrengthText = 'Moderate';
        _passwordStrengthColor = AppColors.warning;
      } else {
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = AppColors.success;
      }
    });
  }

  void _handleSignup() async {
    setState(() {
      _generalErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      setState(() {
        _generalErrorMessage = 'You must accept the terms and security conditions to request access.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock API Latency Delay
    await Future.delayed(const Duration(milliseconds: 1800));

    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = ResponsiveLayout.isMobile(context);

    if (_isSuccess) {
      return _buildSuccessScreen(context);
    }

    final bool showResponsiveSideBanner = !isMobile && size.width >= 950;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: showResponsiveSideBanner
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildCulturalBrandingBanner(size),
                    const SizedBox(width: AppSizes.s48),
                    _buildFormCard(context, isMobile),
                  ],
                )
              : _buildFormCard(context, isMobile),
        ),
      ),
    );
  }

  Widget _buildCulturalBrandingBanner(Size size) {
    return Container(
      width: 400,
      height: 700,
      decoration: BoxDecoration(
        color: AppColors.sidebarBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: AppSizes.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSizes.s40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                child: Image.asset(
                  'assets/images/WhatsApp Image 2026-09-20 at 10.29.20.jpeg',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.auto_awesome,
                    color: AppColors.secondary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s16),
              const Text(
                'CHATURVYUHA',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppSizes.s16),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/WhatsApp Image 2026-09-20 at 10.29.20.jpeg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.auto_awesome,
                        color: AppColors.secondary,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s32),
              const Text(
                'Join the Administrative Core',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSizes.s16),
              const Text(
                'Account verification, specialized roles, and clearance properties are managed exclusively by the core system administrators.',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const Text(
            'CHATURVYUHA FOUNDATION Staff Directory v1.0',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 480,
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: AppSizes.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSizes.s32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMobile) ...[
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                      child: Image.asset(
                        'assets/images/WhatsApp Image 2026-09-20 at 10.29.20.jpeg',
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.auto_awesome,
                          color: AppColors.secondary,
                          size: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.s16),
                    const Text(
                      'CHATURVYUHA',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s32),
            ],
            Text('Access Request', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSizes.s8),
            const Text(
              'Register staff profiles to await management clearance.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: AppSizes.s24),

            if (_generalErrorMessage != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Text(
                  _generalErrorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: AppSizes.s16),
            ],

            CustomTextField(
              controller: _nameController,
              labelText: 'Full Name',
              hintText: 'Acharya Dev',
              prefixIcon: Icons.person_outline,
              validator: (v) => v == null || v.trim().isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: AppSizes.s16),

            CustomTextField(
              controller: _emailController,
              labelText: 'Email Address',
              hintText: 'name@cfoundation.org',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.s16),

            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              hintText: '+977 9851XXXXXX',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.trim().isEmpty ? 'Phone number is required' : null,
            ),
            const SizedBox(height: AppSizes.s16),

            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            
            if (_passwordStrength > 0.0) ...[
              const SizedBox(height: AppSizes.s8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: AppColors.border,
                        color: _passwordStrengthColor,
                        minHeight: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.s8),
                  Text(
                    _passwordStrengthText,
                    style: TextStyle(color: _passwordStrengthColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSizes.s16),

            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please confirm your password';
                if (v != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.s16),

            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreeToTerms,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                  ),
                ),
                const SizedBox(width: AppSizes.s8),
                const Expanded(
                  child: Text(
                    'I certify that I am a recognized team member and agree to internal guidelines.',
                    style: TextStyle(color: AppColors.textBody, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s24),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignup,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Submit Access Request'),
            ),
            const SizedBox(height: AppSizes.s16),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  InkWell(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(AppSizes.s40),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              boxShadow: AppSizes.cardShadow,
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.success, size: 72),
                const SizedBox(height: AppSizes.s24),
                Text('Request Submitted', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.s16),
                const Text(
                  'Thank you! Your access request profile has been successfully sent to system administrators.\n\nYou will be notified via email once your specific role and workspace authorizations have been cleared.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textBody, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: AppSizes.s32),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                  child: const Text('Return to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
