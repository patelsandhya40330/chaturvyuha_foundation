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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Ensure Flutter engine binding is active before starting animation & timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startSplashSequence();
    });

    // Setup smooth 1,200ms fade & scale entrance animation for logo
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  void _startSplashSequence() {
    // Automatically transition to DashboardScreen after 2,500ms
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
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
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Responsive Logo Container without tight circular clipping

                      // Foundation Name
                      const Text(
                        "CHATURVEDA",
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
                        "FOUNDATIONS",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.sectionLabel.copyWith(
                          fontSize: 12,
                          letterSpacing: 3.0,
                          color: AppColor.primary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle / Tagline
                      Text(
                        "WISDOM • WELLNESS • COMMUNITY",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bulletLabel.copyWith(
                          fontSize: 10,
                          letterSpacing: 2.0,
                          color: AppColor.bodyText.withAlpha(180),
                        ),
                      ),

                      const Spacer(),

                      // Subtle Loading Indicator
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
                        "Guarding Eternal Wisdom in a Rapidly Moving Age",
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
              );
            },
          ),
        ),
      ),
    );
  }
}
