import 'package:flutter/material.dart';
import 'package:flutter_2048/theme_controller.dart';

// Must match windowSplashScreenBackground in all styles.xml files.
// The OS splash is a blank screen with this color — identical to what
// Flutter draws, so there is no visible transition between them.
const _splashBg = Color(0xFF121212);

/// Full GPay-style animated splash screen.
///
/// The OS splash is a plain blank screen (transparent icon, #121212 bg).
/// Flutter takes over immediately and runs:
///   - Logo scales in from 0.6 → 1.0 with easeOutBack (the "pop")
///   - Logo fades in simultaneously
///   - App name + subtitle fade in with a slight delay
///   - After animation + hold, fades out to the game
class SplashContent extends StatefulWidget {
  final ThemeController themeController;
  final Widget destination;

  const SplashContent({
    super.key,
    required this.themeController,
    required this.destination,
  });

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;

  static const Duration _animDuration = Duration(milliseconds: 800);
  static const Duration _hold = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: _animDuration);

    // Logo pops in: scale 0.6 → 1.0 with springy easeOutBack curve
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    // Logo fades in during first 50% of animation
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text fades in during second half, slightly delayed for the stagger
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );

    // Start animation on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ctrl.forward().whenComplete(() {
          Future.delayed(_hold, _navigateAway);
        });
      }
    });
  }

  void _navigateAway() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget.destination,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _splashBg,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo ─────────────────────────────────────────────
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/game_logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Text ─────────────────────────────────────────────
              Opacity(
                opacity: _textFade.value,
                child: const Column(
                  children: [
                    Text(
                      '2048',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Slide & Merge',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0x8DFFFFFF),
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
