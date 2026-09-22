import 'package:cfoundation/core/routing/app_router.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _generalErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
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
        _isSuccess = true;
      });
    }
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
                'Password Recovery\nProcess',
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
            'Securely recover your access credentials for the foundation portal.',
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
              'Forgot Password?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.s8),
            const Text(
              'Enter your email address to receive password reset instructions.',
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
            const SizedBox(height: AppSizes.s32),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleResetPassword,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Send Reset Instructions'),
            ),
            const SizedBox(height: AppSizes.s24),

            Center(
              child: InkWell(
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Back to Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
                const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 72),
                const SizedBox(height: AppSizes.s24),
                Text('Reset Email Sent', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: AppSizes.s16),
                const Text(
                  'A professional password reset instruction has been sent to your email address. Please follow the link in the email to securely reset your password.',
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
