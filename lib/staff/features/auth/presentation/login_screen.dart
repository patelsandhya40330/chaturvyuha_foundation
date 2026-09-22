import 'package:cfoundation/core/routing/app_router.dart';
import 'package:cfoundation/core/theme/app_theme.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _generalErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _generalErrorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request latency
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isLoading = false;
      });

      // Frontend Mock Verification Matcher Rule
      if (_emailController.text.trim() == 'staff@cfoundation.org' && 
          _passwordController.text == 'password123') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.dashboard);
        }
      } else {
        setState(() {
          _generalErrorMessage = 'Invalid email or password. Please use correct credentials.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = ResponsiveLayout.isMobile(context);
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
      height: 550,
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
                    color: Colors.white, // Pure white background to match image exactly
                    shape: BoxShape.circle, // Rounded circle shape for seamless integration
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
                'Preserving Tradition,\nEmpowering Future.',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSizes.s16),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const Text(
            'Centralized Content Management System & Staff Management Framework.',
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 450,
      constraints: const BoxConstraints(maxWidth: 450),
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
            
            Text(
              'Staff Portal Login',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.s8),
            const Text(
              'Access your administrative tools and dashboard.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: AppSizes.s32),

            if (_generalErrorMessage != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: AppSizes.s16),
                    Expanded(
                      child: Text(
                        _generalErrorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s24),
            ],

            CustomTextField(
              controller: _emailController,
              labelText: 'Email Address',
              hintText: 'name@cfoundation.org',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email address is required';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.s24),

            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.s16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSizes.s8),
                    const Text(
                      'Remember me',
                      style: TextStyle(color: AppColors.textBody, fontSize: 14),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.forgotPassword);
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s32),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Sign In to Account'),
            ),
            const SizedBox(height: AppSizes.s24),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New to the staff portal? ",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.signup);
                    },
                    child: const Text(
                      'Request Access',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
}
