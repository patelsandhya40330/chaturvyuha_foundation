import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import '../Dashboard/dashboard_screen.dart';

/// A splash screen displaying brand identity and entrance animations.
///
/// Matches the sanctuary aesthetic of the Chaturvyuha Foundation, featuring
/// ivory backgrounds, saffron accenting, animated lotus badge, and automatic
/// fade transition to the target [nextScreen].
class SplashScreen extends StatefulWidget {
  /// The target screen to navigate to after the splash sequence completes.
  /// If null, defaults to [DashboardScreen].
  final Widget? nextScreen;

  const SplashScreen({super.key, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// State implementation for [SplashScreen], managing entrance fade, scale,
/// and pulse animations alongside automatic navigation timer.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controller managing splash entrance animations.
  late final AnimationController _controller;

  /// Fade-in animation for content opacity.
  late final Animation<double> _fadeAnimation;

  /// Scale-up animation for central logo badge.
  late final Animation<double> _scaleAnimation;

  /// Continuous subtle pulse animation for sacred emblem ring.
  late final Animation<double> _pulseAnimation;

  /// Timer managing navigation delay.
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startSplashSequence();
    });
  }

  /// Initiates the timer delay before smoothly navigating to [nextScreen].
  void _startSplashSequence() {
    _navigationTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;

      final target = widget.nextScreen ?? const DashboardScreen();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) => target,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.backgroundColor, // Serene Ivory (#FDFBF7)
              AppColor.cardBg, // Soft Warm Cream (#F7F2EB)
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 20,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 10),

                            // Main Central Emblem & Brand Name Section
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),

                                // Animated Concentric Sacred Lotus Badge
                                _buildSacredEmblem(),

                                const SizedBox(height: 36),

                                // Brand Title
                                const Text(
                                  'CHATURVEDA',
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                    color: AppColor.heading,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),

                                // Sub-label Badge
                                const Text(
                                  'FOUNDATION',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 6,
                                    color: AppColor.primary,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Decorative Saffron Divider with Center Dot
                                _buildDecorativeDivider(),

                                const SizedBox(height: 24),

                                // Poetic Tagline
                                const Text(
                                  'Ancient Wisdom.\nLiving Traditions. Harmonious Life.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 20,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                    color: AppColor.bodyText,
                                  ),
                                ),
                              ],
                            ),

                            // Bottom Indicator & Tagline
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 40,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  // Subtle Linear Progress Bar in Brand Saffron
                                  SizedBox(
                                    width: 140,
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: AppColor.border,
                                      color: AppColor.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Pill Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.lightPrimary,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor.border,
                                      ),
                                    ),
                                    child: const Text(
                                      '• ETERNAL DHARMA • VEDIC HERITAGE •',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  Text(
                                    'Bridging Primordial Knowledge with Modern Living',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: AppColor.grey,
                                    ),
                                  ),
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
            },
          ),
        ),
      ),
    );
  }

  /// Builds the animated concentric emblem badge with sacred lotus icon.
  Widget _buildSacredEmblem() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 130,
            height: 130,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.primary.withAlpha(120),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withAlpha(20),
                  blurRadius: 30,
                  spreadRadius: 4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColor.border),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/chaturvedal-logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('Splash logo load error: $error');
                      return const SizedBox(width: 60, height: 60);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the decorative divider line with a central ornament.
  Widget _buildDecorativeDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 1,
          color: AppColor.secondary.withAlpha(150),
        ),
        const SizedBox(width: 8),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 1,
          color: AppColor.secondary.withAlpha(150),
        ),
      ],
    );
  }
}
