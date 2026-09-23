import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import '../Dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;
  const SplashScreen({super.key, this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;

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
      begin: 0.82,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startSplashSequence();
    });
  }

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF824F1A), // Brand primary warm brown
              Color(0xFF4A2B0E), // Deep sanctuary dark bronze
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
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 20),

                            // Main Central Emblem & Brand Name Section
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),

                                // Animated Concentric Sacred Lotus Badge
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        width: 140,
                                        height: 140,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(
                                              0xFFE5C185,
                                            ).withAlpha(100),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(60),
                                              blurRadius: 30,
                                              offset: const Offset(0, 10),
                                            ),
                                            BoxShadow(
                                              color: const Color(
                                                0xFFE5C185,
                                              ).withAlpha(30),
                                              blurRadius: 40,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withAlpha(20),
                                            border: Border.all(
                                              color: Colors.white.withAlpha(40),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.spa,
                                              size: 68,
                                              color: Color(0xFFFDFBF7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 36),

                                // Foundation Title
                                const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'CHATURVEDA',
                                    style: TextStyle(
                                      fontFamily: 'Georgia',
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Gold Sub-Label
                                const Text(
                                  'FOUNDATIONS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 6,
                                    color: Color(0xFFE5C185),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Decorative Gold Divider
                                Container(
                                  width: 44,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE5C185,
                                    ).withAlpha(180),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // Poetic Tagline
                                const Text(
                                  'Ancient Wisdom.\nA Meaningful Life.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 22,
                                    height: 1.5,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFFFDFBF7),
                                  ),
                                ),
                              ],
                            ),

                            // Bottom Indicator & Tagline
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 40,
                                bottom: 28,
                              ),
                              child: Column(
                                children: [
                                  // Subtle Circular / Linear Loading Bar
                                  SizedBox(
                                    width: 140,
                                    child: LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: Colors.white24,
                                      color: const Color(0xFFE5C185),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  const Text(
                                    'WISDOM • WELLNESS • COMMUNITY',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.0,
                                      color: Color(0xFFE5C185),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Text(
                                    'Guarding Eternal Wisdom in a Rapidly Moving Age',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70,
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
}
