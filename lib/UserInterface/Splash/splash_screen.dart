import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import '../Dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = _animationController.drive(
      CurveTween(curve: Curves.easeIn),
    );

    _scaleAnimation = _animationController
        .drive(CurveTween(curve: Curves.easeOutBack))
        .drive(Tween<double>(begin: 0.85, end: 1.0));

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startSplashSequence();
    });
  }

  void _startSplashSequence() {
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  const Spacer(),

                  // White circle with the logo tinted in the primary color.
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withAlpha(25),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.spa, size: 70, color: AppColor.primary),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'CHATURVEDA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                      color: AppColor.heading,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'FOUNDATIONS',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.sectionLabel.copyWith(
                      fontSize: 12,
                      letterSpacing: 3,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'WISDOM • WELLNESS • COMMUNITY',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bulletLabel.copyWith(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: AppColor.bodyText.withAlpha(180),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColor.primary.withAlpha(30),
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Guarding Eternal Wisdom in a Rapidly Moving Age',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColor.bodyText.withAlpha(150),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
