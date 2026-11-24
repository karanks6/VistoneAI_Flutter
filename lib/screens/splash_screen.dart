import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/design_system.dart';

/// 10 Monk Skin Tone baseline references for the celestial calibration ring
const List<Color> _kMonkScaleColors = [
  Color(0xFFF6EDE4), // MST 01
  Color(0xFFF3E7DB), // MST 02
  Color(0xFFF7EAD0), // MST 03
  Color(0xFFEADABA), // MST 04
  Color(0xFFD7BD96), // MST 05
  Color(0xFFA07E56), // MST 06
  Color(0xFF825C43), // MST 07
  Color(0xFF604134), // MST 08
  Color(0xFF3A312A), // MST 09
  Color(0xFF292420), // MST 10
];

/// Data definition for floating golden embers / sparkling light motes
class _EmberParticleData {
  final double x;
  final double ySeed;
  final double speed;
  final double radius;
  final double driftAmp;
  final double driftFreq;
  final double maxAlpha;
  final Color darkColor;
  final Color lightColor;

  const _EmberParticleData({
    required this.x,
    required this.ySeed,
    required this.speed,
    required this.radius,
    required this.driftAmp,
    required this.driftFreq,
    required this.maxAlpha,
    required this.darkColor,
    required this.lightColor,
  });
}

const List<_EmberParticleData> _kEmberParticles = [
  _EmberParticleData(
    x: 0.15,
    ySeed: 0.05,
    speed: 0.35,
    radius: 2.4,
    driftAmp: 18,
    driftFreq: 1.2,
    maxAlpha: 0.85,
    darkColor: Color(0xFFFFD166),
    lightColor: Color(0xFFD4AF37),
  ),
  _EmberParticleData(
    x: 0.25,
    ySeed: 0.22,
    speed: 0.30,
    radius: 1.8,
    driftAmp: 22,
    driftFreq: 0.9,
    maxAlpha: 0.70,
    darkColor: Color(0xFFFFF3D6),
    lightColor: Color(0xFFE5A93C),
  ),
  _EmberParticleData(
    x: 0.38,
    ySeed: 0.45,
    speed: 0.42,
    radius: 3.2,
    driftAmp: 14,
    driftFreq: 1.5,
    maxAlpha: 0.90,
    darkColor: Color(0xFFFFE299),
    lightColor: Color(0xFFC59B27),
  ),
  _EmberParticleData(
    x: 0.50,
    ySeed: 0.12,
    speed: 0.36,
    radius: 2.2,
    driftAmp: 25,
    driftFreq: 1.1,
    maxAlpha: 0.80,
    darkColor: Color(0xFF88D49E),
    lightColor: Color(0xFF4A7C59),
  ),
  _EmberParticleData(
    x: 0.62,
    ySeed: 0.35,
    speed: 0.32,
    radius: 2.8,
    driftAmp: 16,
    driftFreq: 1.3,
    maxAlpha: 0.85,
    darkColor: Color(0xFFFFD166),
    lightColor: Color(0xFFD4AF37),
  ),
  _EmberParticleData(
    x: 0.72,
    ySeed: 0.58,
    speed: 0.44,
    radius: 1.5,
    driftAmp: 20,
    driftFreq: 0.8,
    maxAlpha: 0.65,
    darkColor: Color(0xFFFFF3D6),
    lightColor: Color(0xFFE5A93C),
  ),
  _EmberParticleData(
    x: 0.85,
    ySeed: 0.18,
    speed: 0.34,
    radius: 3.0,
    driftAmp: 12,
    driftFreq: 1.4,
    maxAlpha: 0.90,
    darkColor: Color(0xFFFFE299),
    lightColor: Color(0xFFC59B27),
  ),
  _EmberParticleData(
    x: 0.20,
    ySeed: 0.65,
    speed: 0.38,
    radius: 2.0,
    driftAmp: 15,
    driftFreq: 1.0,
    maxAlpha: 0.75,
    darkColor: Color(0xFF88D49E),
    lightColor: Color(0xFF4A7C59),
  ),
  _EmberParticleData(
    x: 0.32,
    ySeed: 0.82,
    speed: 0.28,
    radius: 3.5,
    driftAmp: 24,
    driftFreq: 1.6,
    maxAlpha: 0.85,
    darkColor: Color(0xFFFFD166),
    lightColor: Color(0xFFD4AF37),
  ),
  _EmberParticleData(
    x: 0.45,
    ySeed: 0.70,
    speed: 0.40,
    radius: 1.6,
    driftAmp: 18,
    driftFreq: 0.7,
    maxAlpha: 0.60,
    darkColor: Color(0xFFFFF3D6),
    lightColor: Color(0xFFE5A93C),
  ),
  _EmberParticleData(
    x: 0.55,
    ySeed: 0.92,
    speed: 0.36,
    radius: 2.6,
    driftAmp: 20,
    driftFreq: 1.2,
    maxAlpha: 0.80,
    darkColor: Color(0xFFFFE299),
    lightColor: Color(0xFFC59B27),
  ),
  _EmberParticleData(
    x: 0.68,
    ySeed: 0.78,
    speed: 0.41,
    radius: 2.1,
    driftAmp: 17,
    driftFreq: 1.5,
    maxAlpha: 0.75,
    darkColor: Color(0xFF88D49E),
    lightColor: Color(0xFF4A7C59),
  ),
  _EmberParticleData(
    x: 0.78,
    ySeed: 0.38,
    speed: 0.32,
    radius: 3.2,
    driftAmp: 22,
    driftFreq: 1.0,
    maxAlpha: 0.90,
    darkColor: Color(0xFFFFD166),
    lightColor: Color(0xFFD4AF37),
  ),
  _EmberParticleData(
    x: 0.90,
    ySeed: 0.88,
    speed: 0.46,
    radius: 1.8,
    driftAmp: 15,
    driftFreq: 1.3,
    maxAlpha: 0.70,
    darkColor: Color(0xFFFFF3D6),
    lightColor: Color(0xFFE5A93C),
  ),
  _EmberParticleData(
    x: 0.28,
    ySeed: 0.52,
    speed: 0.34,
    radius: 2.4,
    driftAmp: 19,
    driftFreq: 1.1,
    maxAlpha: 0.80,
    darkColor: Color(0xFFFFE299),
    lightColor: Color(0xFFC59B27),
  ),
  _EmberParticleData(
    x: 0.42,
    ySeed: 0.28,
    speed: 0.42,
    radius: 1.7,
    driftAmp: 16,
    driftFreq: 0.9,
    maxAlpha: 0.65,
    darkColor: Color(0xFF88D49E),
    lightColor: Color(0xFF4A7C59),
  ),
  _EmberParticleData(
    x: 0.65,
    ySeed: 0.15,
    speed: 0.38,
    radius: 2.9,
    driftAmp: 21,
    driftFreq: 1.4,
    maxAlpha: 0.85,
    darkColor: Color(0xFFFFD166),
    lightColor: Color(0xFFD4AF37),
  ),
  _EmberParticleData(
    x: 0.80,
    ySeed: 0.60,
    speed: 0.30,
    radius: 2.0,
    driftAmp: 14,
    driftFreq: 1.2,
    maxAlpha: 0.70,
    darkColor: Color(0xFFFFF3D6),
    lightColor: Color(0xFFE5A93C),
  ),
];

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _ambientController;
  late final AnimationController _orbitalController;
  bool _hasProceeded = false;

  @override
  void initState() {
    super.initState();

    // Ambient breathing loop (4.5s loop, reverse)
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat(reverse: true);

    // Continuous rising particles & orbital rotation (9s loop)
    _orbitalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    )..repeat();

    // Studio calibration timeline (2800ms)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        final accessible =
            MediaQuery.maybeOf(context)?.accessibleNavigation ?? false;
        if (!accessible) {
          _proceed();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final mediaQuery = MediaQuery.maybeOf(context);
      final reduceMotion = mediaQuery?.disableAnimations ?? false;
      final accessibleNavigation = mediaQuery?.accessibleNavigation ?? false;

      if (reduceMotion) {
        _progressController.value = 1.0;
        _proceed();
      } else if (accessibleNavigation) {
        _progressController.value = 1.0;
      } else {
        _progressController.forward();
      }
    });
  }

  void _proceed() {
    if (!mounted || _hasProceeded) return;
    _hasProceeded = true;
    context.go('/home');
  }

  @override
  void dispose() {
    _progressController.dispose();
    _ambientController.dispose();
    _orbitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // Color tokens calibrated for Light vs Dark luxury botanical aesthetic
    final bgImage = isDark
        ? 'assets/images/splash_bg_dark.png'
        : 'assets/images/splash_bg_light.png';
    final bgColor =
        isDark ? const Color(0xFF071914) : const Color(0xFFFAF7F2);
    final headlineColor =
        isDark ? Colors.white : const Color(0xFF0C251C);
    final captionColor =
        isDark ? AppColors.nightMuted : const Color(0xFF424543);
    final badgeBg = isDark
        ? AppColors.sage.withValues(alpha: 0.12)
        : const Color(0xFF1E5645).withValues(alpha: 0.10);
    final badgeBorder = isDark
        ? AppColors.sage.withValues(alpha: 0.25)
        : const Color(0xFF1E5645).withValues(alpha: 0.30);
    final badgeText = isDark ? AppColors.sage : const Color(0xFF1E5645);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1: Photographic botanical artwork template
          Positioned.fill(
            child: Image.asset(
              bgImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: bgColor),
            ),
          ),

          // Layer 2: Ethereal ambient light fields (smooth breathing aurora)
          if (!reduceMotion)
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _AuroraGlowPainter(
                    progress: _ambientController.value,
                    isDark: isDark,
                  ),
                );
              },
            ),

          // Layer 3: Horizon Light Beam / Lens Flare (Matching reference GIF)
          if (!reduceMotion)
            AnimatedBuilder(
              animation: _ambientController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _HorizonLightFlarePainter(
                    pulseValue: _ambientController.value,
                    isDark: isDark,
                  ),
                );
              },
            ),

          // Layer 4: Rising golden embers & sparkling light dust (Matching reference GIF)
          if (!reduceMotion)
            AnimatedBuilder(
              animation: _orbitalController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _FloatingEmbersPainter(
                    animationValue: _orbitalController.value,
                    isDark: isDark,
                  ),
                );
              },
            ),

          // Layer 5: Main interactive content wrapped in responsive layout
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScaler = MediaQuery.textScalerOf(context);
                final isHighScale = textScaler.scale(14) > 18;
                final isCompact = constraints.maxHeight < 720;
                final centerpieceSize =
                    (isCompact || isHighScale) ? 145.0 : 195.0;
                final verticalPadding =
                    isCompact ? AppSpacing.sm : AppSpacing.lg;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                        vertical: verticalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top Brand Bar with Skip action
                          _TopBrandBar(
                            isDark: isDark,
                            onSkip: () {
                              HapticFeedback.lightImpact();
                              _proceed();
                            },
                          ),

                          // Centerpiece: Kinetic App Logo & Monk Scale Aperture
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            child: Center(
                              child: _LuxeChromaticCenterpiece(
                                size: centerpieceSize,
                                orbitalAnimation: _orbitalController,
                                ambientAnimation: _ambientController,
                                reduceMotion: reduceMotion,
                                isDark: isDark,
                              ),
                            ),
                          ),

                          // Editorial typography block
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Eyebrow badge pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius:
                                      BorderRadius.circular(AppRadii.pill),
                                  border: Border.all(
                                    color: badgeBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: badgeText,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'INCLUSIVE CHROMATIC SCIENCE',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.6,
                                        color: badgeText,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fadeIn(
                                    duration: 500.ms,
                                    delay: 200.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .slideY(begin: 0.15, end: 0),

                              const SizedBox(height: AppSpacing.sm),

                              // Editorial headline
                              Text(
                                'Find the shades\nthat feel like you.',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: isCompact ? 32 : 40,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                  letterSpacing: -0.5,
                                  color: headlineColor,
                                ),
                              )
                                  .animate()
                                  .fadeIn(
                                    duration: 650.ms,
                                    delay: 350.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .slideY(begin: 0.12, end: 0),

                              const SizedBox(height: AppSpacing.xs),

                              // Supporting editorial caption
                              Text(
                                'AI-powered personal colour analysis grounded in inclusive skin science.',
                                style: GoogleFonts.inter(
                                  fontSize: isCompact ? 13 : 14.5,
                                  fontWeight: FontWeight.w400,
                                  height: 1.45,
                                  color: captionColor,
                                ),
                              )
                                  .animate()
                                  .fadeIn(
                                    duration: 550.ms,
                                    delay: 500.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .slideY(begin: 0.08, end: 0),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.md),

                          // Dynamic calibration loading HUD
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) {
                              return _StudioCalibrationHUD(
                                progress: _progressController.value,
                                reduceMotion: reduceMotion,
                                isDark: isDark,
                              );
                            },
                          )
                              .animate()
                              .fadeIn(
                                duration: 600.ms,
                                delay: 600.ms,
                                curve: Curves.easeOutCubic,
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Top brand bar with pristine alignment, theme-adaptive lockup, and accessible Skip button
class _TopBrandBar extends StatelessWidget {
  final VoidCallback onSkip;
  final bool isDark;

  const _TopBrandBar({
    required this.onSkip,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final brandColor = isDark ? Colors.white : const Color(0xFF1A1D1A);
    final logoBg = isDark
        ? AppColors.nightSurfaceRaised
        : Colors.white.withValues(alpha: 0.92);
    final logoBorder = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : const Color(0xFF1A1D1A).withValues(alpha: 0.12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Brand Identity Lockup
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: logoBg,
                border: Border.all(
                  color: logoBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/images/vistone_logo_clean.png',
                    excludeFromSemantics: true,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/icon/vistone_logo.png',
                      excludeFromSemantics: true,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'VISTONE AI',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.2,
                        color: brandColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.marigold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.marigold.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'STUDIO',
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark
                              ? AppColors.marigold
                              : const Color(0xFF996B00),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Skip button with min 48x48 tap target and full accessibility
        Semantics(
          container: true,
          button: true,
          label: 'Skip introduction and go to studio home',
          onTap: onSkip,
          excludeSemantics: true,
          child: _SkipButton(
            onTap: onSkip,
            isDark: isDark,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }
}

class _SkipButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _SkipButton({
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final fgColor = isDark ? Colors.white : const Color(0xFF0C251C);
    final bgColor = isDark
        ? (_isPressed
            ? Colors.white.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.10))
        : (_isPressed
            ? const Color(0xFF0C251C).withValues(alpha: 0.14)
            : const Color(0xFF0C251C).withValues(alpha: 0.07));
    final borderColor = _isFocused
        ? AppColors.marigold
        : (isDark
            ? Colors.white.withValues(alpha: 0.22)
            : const Color(0xFF0C251C).withValues(alpha: 0.22));

    return FocusableActionDetector(
      onShowFocusHighlight: (v) => setState(() => _isFocused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            HapticFeedback.lightImpact();
            widget.onTap();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          child: Center(
            child: AnimatedScale(
              scale: _isPressed ? 0.94 : 1.0,
              duration: AppMotion.micro,
              curve: Curves.easeOutCubic,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: borderColor,
                    width: _isFocused ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SKIP',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: fgColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      LucideIcons.arrowRight,
                      size: 13,
                      color: fgColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kinetic centerpiece combining the App Logo, Monk scale celestial ring,
/// rotating chromatic sweep, glass core, and orbiting satellite photons.
class _LuxeChromaticCenterpiece extends StatelessWidget {
  final double size;
  final Animation<double> orbitalAnimation;
  final Animation<double> ambientAnimation;
  final bool reduceMotion;
  final bool isDark;

  const _LuxeChromaticCenterpiece({
    required this.size,
    required this.orbitalAnimation,
    required this.ambientAnimation,
    required this.reduceMotion,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final auraSize = size * 1.12;
    final sweepSize = size * 0.88;
    final coreSize = size * 0.72;
    final logoSize = coreSize * 0.64;

    return SizedBox(
      width: size + 36,
      height: size + 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient radiant chromatic halo (breathing with subtle pulse)
          AnimatedBuilder(
            animation: ambientAnimation,
            builder: (context, _) {
              final scale = reduceMotion
                  ? 1.0
                  : 0.96 + (ambientAnimation.value * 0.08);
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: auraSize,
                  height: auraSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppColors.marigold.withValues(alpha: 0.25)
                            : const Color(0xFFD4AF37).withValues(alpha: 0.22),
                        blurRadius: 48,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: isDark
                            ? AppColors.sage.withValues(alpha: 0.22)
                            : const Color(0xFF7FA995).withValues(alpha: 0.18),
                        blurRadius: 36,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // The 10 Monk Skin Tone celestial calibration ring
          AnimatedBuilder(
            animation: orbitalAnimation,
            builder: (context, _) {
              final angle =
                  reduceMotion ? 0.0 : -orbitalAnimation.value * 2 * math.pi;
              return Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: _MonkScaleRingPainter(
                    colors: _kMonkScaleColors,
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),

          // Rotating Chromatic Spectral Ribbon
          AnimatedBuilder(
            animation: orbitalAnimation,
            builder: (context, _) {
              final angle =
                  reduceMotion ? 0.0 : orbitalAnimation.value * 2 * math.pi;
              return Transform.rotate(
                angle: angle,
                child: Container(
                  width: sweepSize,
                  height: sweepSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const SweepGradient(
                      colors: [
                        AppColors.clay,
                        AppColors.marigold,
                        AppColors.sage,
                        AppColors.forest,
                        AppColors.lilac,
                        AppColors.clay,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.clay.withValues(alpha: 0.22),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Frosted luxury glass bezel & core housing the App Logo
          Container(
            width: coreSize,
            height: coreSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? const Color(0xFF0C251C)
                  : Colors.white.withValues(alpha: 0.94),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.85)
                    : const Color(0xFFD4AF37).withValues(alpha: 0.70),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.50 : 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.marigold.withValues(alpha: 0.20),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    'assets/images/vistone_logo_clean.png',
                    excludeFromSemantics: true,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/icon/vistone_logo.png',
                      excludeFromSemantics: true,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Orbiting micro satellite photons (simulating real-time spectrum scanning)
          if (!reduceMotion)
            AnimatedBuilder(
              animation: orbitalAnimation,
              builder: (context, _) {
                final t = orbitalAnimation.value * 2 * math.pi;
                return SizedBox(
                  width: size + 24,
                  height: size + 24,
                  child: CustomPaint(
                    painter: _OrbitingParticlesPainter(
                      progressAngle: t,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1.0, 1.0),
          duration: 850.ms,
          curve: Curves.easeOutBack,
        );
  }
}

/// Dynamic real-time calibration progress HUD with animated steps & glowing spark
class _StudioCalibrationHUD extends StatelessWidget {
  final double progress;
  final bool reduceMotion;
  final bool isDark;

  const _StudioCalibrationHUD({
    required this.progress,
    required this.reduceMotion,
    required this.isDark,
  });

  String _getCalibrationPhase(double p) {
    if (p < 0.30) {
      return 'INITIALIZING SPECTRAL MATRIX';
    } else if (p < 0.65) {
      return 'CALIBRATING 10-TONE HARMONIES';
    } else if (p < 0.95) {
      return 'SYNTHESIZING PERSONAL STUDIO';
    } else {
      return 'STUDIO READY';
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).toInt();
    final phaseText = _getCalibrationPhase(progress);

    final statusText = isDark ? AppColors.nightText : const Color(0xFF1A1D1A);
    final accentText = isDark ? AppColors.sage : const Color(0xFF1E5645);
    final trackBg = isDark ? AppColors.nightLine : const Color(0xFFDFE6E1);
    final telemetryText =
        isDark ? AppColors.nightMuted : const Color(0xFF5D615F);

    return Semantics(
      container: true,
      label: 'Studio calibration status',
      value: '$percent percent, $phaseText',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top status indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: progress >= 0.95
                          ? AppColors.marigold
                          : accentText,
                      boxShadow: [
                        BoxShadow(
                          color: (progress >= 0.95
                                  ? AppColors.marigold
                                  : accentText)
                              .withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    phaseText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: statusText,
                    ),
                  ),
                ],
              ),
              Text(
                '$percent%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: accentText,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Glowing progress track with travelling head photon
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Track background with accessible contrast border
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: trackBg,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isDark
                        ? AppColors.nightMuted.withValues(alpha: 0.35)
                        : const Color(0xFFCAD4CD),
                    width: 0.7,
                  ),
                ),
              ),

              // Gradient Fill Bar
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? const [
                              AppColors.forest,
                              AppColors.sage,
                              AppColors.marigold,
                              AppColors.clay,
                            ]
                          : const [
                              Color(0xFF143B2F),
                              Color(0xFF4A7C59),
                              Color(0xFFD4AF37),
                              Color(0xFFC59B27),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              // Travelling head photon spark
              if (progress > 0.02 && !reduceMotion)
                Align(
                  alignment: Alignment(
                    (progress.clamp(0.0, 1.0) * 2) - 1,
                    0,
                  ),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.marigold.withValues(alpha: 0.85),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.clay.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom studio telemetry badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STUDIO ENGINE v2.4',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: telemetryText,
                ),
              ),
              Text(
                'MONK SCALE ML (MST 01-10)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: accentText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the 10 Monk Skin Tone celestial calibration pips
class _MonkScaleRingPainter extends CustomPainter {
  final List<Color> colors;
  final bool isDark;

  _MonkScaleRingPainter({
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Subtle dashed track ring
    final trackPaint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF133A2D))
          .withValues(alpha: isDark ? 0.10 : 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius, trackPaint);

    // 10 Monk Skin Tone calibration dots with subtle glow
    final int count = colors.length;
    for (int i = 0; i < count; i++) {
      final double theta = (2 * math.pi / count) * i;
      final dx = center.dx + radius * math.cos(theta);
      final dy = center.dy + radius * math.sin(theta);
      final dotOffset = Offset(dx, dy);

      // Outer glow
      final glowPaint = Paint()
        ..color = colors[i].withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(dotOffset, 4.0, glowPaint);

      // Core pip
      final pipPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotOffset, 2.8, pipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MonkScaleRingPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

/// Custom painter for floating micro-particles orbiting the chromatic center
class _OrbitingParticlesPainter extends CustomPainter {
  final double progressAngle;

  _OrbitingParticlesPainter({required this.progressAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Particle 1: Warm Marigold
    final r1 = (size.width / 2) - 4;
    final a1 = progressAngle;
    final p1 =
        Offset(center.dx + r1 * math.cos(a1), center.dy + r1 * math.sin(a1));
    _drawGlowParticle(canvas, p1, AppColors.marigold, 3.0);

    // Particle 2: Sage Green (counter-phase)
    final r2 = (size.width / 2) - 18;
    final a2 = -progressAngle * 1.3 + 1.2;
    final p2 =
        Offset(center.dx + r2 * math.cos(a2), center.dy + r2 * math.sin(a2));
    _drawGlowParticle(canvas, p2, AppColors.sage, 2.5);

    // Particle 3: Terracotta Clay (eccentric harmonic)
    final r3 = (size.width / 2) + 2;
    final a3 = progressAngle * 0.8 + 2.5;
    final p3 =
        Offset(center.dx + r3 * math.cos(a3), center.dy + r3 * math.sin(a3));
    _drawGlowParticle(canvas, p3, AppColors.clay, 3.2);
  }

  void _drawGlowParticle(
      Canvas canvas, Offset offset, Color color, double radius) {
    final haloPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(offset, radius * 1.8, haloPaint);

    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, radius, corePaint);
  }

  @override
  bool shouldRepaint(covariant _OrbitingParticlesPainter oldDelegate) =>
      oldDelegate.progressAngle != progressAngle;
}

/// Custom painter for floating golden embers and star dust rising from horizon
class _FloatingEmbersPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  _FloatingEmbersPainter({
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _kEmberParticles) {
      final t = (animationValue * p.speed + p.ySeed) % 1.0;
      final startY = size.height * 0.88;
      final travel = size.height * 0.85;
      final curY = startY - (t * travel);
      final curX = (p.x * size.width) +
          math.sin(t * 2 * math.pi * p.driftFreq) * p.driftAmp;

      final fade = math.sin(t * math.pi) * p.maxAlpha;
      if (fade <= 0.01) continue;

      final color = isDark ? p.darkColor : p.lightColor;

      // Soft glowing halo
      final haloPaint = Paint()
        ..color = color.withValues(alpha: fade * 0.45)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.radius * 2.2);
      canvas.drawCircle(Offset(curX, curY), p.radius * 2.0, haloPaint);

      // Bright ember core
      final corePaint = Paint()
        ..color = (isDark ? Colors.white : color).withValues(alpha: fade)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(curX, curY), p.radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingEmbersPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.isDark != isDark;
}

/// Custom painter for horizontal luminous lens flare beam in lower third
class _HorizonLightFlarePainter extends CustomPainter {
  final double pulseValue;
  final bool isDark;

  _HorizonLightFlarePainter({
    required this.pulseValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.74;
    final centerX = size.width * 0.5;
    final breathe = 0.92 + (pulseValue * 0.16);

    // 1. Wide horizontal warm beam
    final beamWidth = size.width * 0.85 * breathe;
    final beamHeight = 18.0 * breathe;
    final beamRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: beamWidth,
      height: beamHeight,
    );

    final beamPaint = Paint()
      ..shader = RadialGradient(
        colors: isDark
            ? [
                const Color(0xFFFFF3D6).withValues(alpha: 0.65),
                const Color(0xFFFFD166).withValues(alpha: 0.35),
                const Color(0xFF0C251C).withValues(alpha: 0.0),
              ]
            : [
                const Color(0xFFFFFAEE).withValues(alpha: 0.85),
                const Color(0xFFE5A93C).withValues(alpha: 0.40),
                const Color(0xFFFAF7F2).withValues(alpha: 0.0),
              ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(beamRect);

    canvas.drawOval(beamRect, beamPaint);

    // 2. Central luminous spark / core
    final coreRect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: 44.0 * breathe,
      height: 12.0 * breathe,
    );
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.95),
          (isDark ? const Color(0xFFFFD166) : const Color(0xFFD4AF37))
              .withValues(alpha: 0.50),
          Colors.transparent,
        ],
      ).createShader(coreRect);

    canvas.drawOval(coreRect, corePaint);
  }

  @override
  bool shouldRepaint(covariant _HorizonLightFlarePainter oldDelegate) =>
      oldDelegate.pulseValue != pulseValue || oldDelegate.isDark != isDark;
}

/// Custom painter for atmospheric dynamic breathing aurora glow fields
class _AuroraGlowPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _AuroraGlowPainter({
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isDark) {
      // Top right soft botanical glow
      final trCenter = Offset(
        size.width * 0.85 + math.sin(progress * 2 * math.pi) * 20,
        size.height * 0.15 + math.cos(progress * 2 * math.pi) * 15,
      );
      final trPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.forest.withValues(alpha: 0.35 + (progress * 0.08)),
            AppColors.forest.withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: trCenter, radius: size.width * 0.65));
      canvas.drawCircle(trCenter, size.width * 0.65, trPaint);

      // Bottom left warm terracotta clay warmth
      final blCenter = Offset(
        size.width * 0.15 + math.cos(progress * 2 * math.pi) * 20,
        size.height * 0.82 + math.sin(progress * 2 * math.pi) * 20,
      );
      final blPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.clay.withValues(alpha: 0.26 + (progress * 0.06)),
            AppColors.marigold.withValues(alpha: 0.10),
            AppColors.clay.withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: blCenter, radius: size.width * 0.70));
      canvas.drawCircle(blCenter, size.width * 0.70, blPaint);
    } else {
      // Light Mode: Morning sunlight & soft sage glow
      final trCenter = Offset(
        size.width * 0.85 + math.sin(progress * 2 * math.pi) * 15,
        size.height * 0.15 + math.cos(progress * 2 * math.pi) * 12,
      );
      final trPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0.14 + (progress * 0.04)),
            const Color(0xFFFAF7F2).withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: trCenter, radius: size.width * 0.60));
      canvas.drawCircle(trCenter, size.width * 0.60, trPaint);

      // Bottom left eucalyptus sage aura
      final blCenter = Offset(
        size.width * 0.15 + math.cos(progress * 2 * math.pi) * 15,
        size.height * 0.82 + math.sin(progress * 2 * math.pi) * 15,
      );
      final blPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF7FA995).withValues(alpha: 0.16 + (progress * 0.04)),
            const Color(0xFFFAF7F2).withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: blCenter, radius: size.width * 0.65));
      canvas.drawCircle(blCenter, size.width * 0.65, blPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraGlowPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}
