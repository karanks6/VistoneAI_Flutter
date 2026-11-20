import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/design_system.dart';

/// 10 Monk Skin Tone baseline references for the calibration ring
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

    // Ambient background subtle breathing (6s loop)
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    // Continuous orbital rotation (12s loop)
    _orbitalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 12000),
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
        // Under screen reader navigation (TalkBack / VoiceOver), do not abruptly auto-advance.
        // Allow the user to read at their own pace and explicitly tap Skip.
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
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Scaffold(
      backgroundColor: AppColors.night,
      body: AppPageBackdrop(
        dark: true,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Ethereal ambient light fields (smooth breathing aurora)
            if (!reduceMotion)
              AnimatedBuilder(
                animation: _ambientController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _AuroraGlowPainter(
                      progress: _ambientController.value,
                    ),
                  );
                },
              ),

            // Layer 2: Main interactive content wrapped in responsive layout
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textScaler = MediaQuery.textScalerOf(context);
                  final isHighScale = textScaler.scale(14) > 18;
                  final isCompact = constraints.maxHeight < 720;
                  final centerpieceSize =
                      (isCompact || isHighScale) ? 150.0 : 210.0;
                  final verticalPadding =
                      isCompact ? AppSpacing.sm : AppSpacing.xl;

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
                              onSkip: () {
                                HapticFeedback.lightImpact();
                                _proceed();
                              },
                            ),

                            // Centerpiece: Kinetic Chromatic Prism Aperture
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: Center(
                                child: _LuxeChromaticCenterpiece(
                                  size: centerpieceSize,
                                  orbitalAnimation: _orbitalController,
                                  ambientAnimation: _ambientController,
                                  reduceMotion: reduceMotion,
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
                                    color:
                                        AppColors.sage.withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.pill),
                                    border: Border.all(
                                      color: AppColors.sage
                                          .withValues(alpha: 0.22),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.sage,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        'INCLUSIVE CHROMATIC SCIENCE',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.6,
                                          color: AppColors.sage,
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
                                    fontSize: isCompact ? 34 : 42,
                                    fontWeight: FontWeight.w400,
                                    height: 1.08,
                                    letterSpacing: -0.6,
                                    color: AppColors.textInverse,
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
                                    color: AppColors.nightMuted,
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
      ),
    );
  }
}

/// Top brand bar with pristine alignment, high-contrast lockup and accessible Skip button
class _TopBrandBar extends StatelessWidget {
  final VoidCallback onSkip;

  const _TopBrandBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.nightSurfaceRaised,
                border: Border.all(
                  color: AppColors.textInverse.withValues(alpha: 0.16),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.clay.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/vistone_logo_clean.png',
                  excludeFromSemantics: true,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/icon/vistone_logo.png',
                    excludeFromSemantics: true,
                    fit: BoxFit.cover,
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
                        color: AppColors.textInverse,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.marigold.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.marigold.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'STUDIO',
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.marigold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Skip button with min 48x48 tap target, haptic feedback, TalkBack tap, and keyboard focus
        Semantics(
          container: true,
          button: true,
          label: 'Skip introduction and go to studio home',
          onTap: onSkip,
          excludeSemantics: true,
          child: _SkipButton(onTap: onSkip),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }
}

class _SkipButton extends StatefulWidget {
  final VoidCallback onTap;

  const _SkipButton({required this.onTap});

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
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
                  color: _isPressed
                      ? AppColors.textInverse.withValues(alpha: 0.18)
                      : AppColors.textInverse.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: _isFocused
                        ? AppColors.marigold
                        : AppColors.textInverse.withValues(alpha: 0.18),
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
                        color: AppColors.textInverse,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      LucideIcons.arrowRight,
                      size: 13,
                      color: AppColors.textInverse,
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

/// Kinetic centerpiece combining Monk scale celestial ring, rotating chromatic sweep,
/// glass core, and gentle orbiting satellite photons.
class _LuxeChromaticCenterpiece extends StatelessWidget {
  final double size;
  final Animation<double> orbitalAnimation;
  final Animation<double> ambientAnimation;
  final bool reduceMotion;

  const _LuxeChromaticCenterpiece({
    required this.size,
    required this.orbitalAnimation,
    required this.ambientAnimation,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final auraSize = size * 1.08;
    final sweepSize = size * 0.86;
    final coreSize = size * 0.70;
    final logoSize = coreSize * 0.62;

    return SizedBox(
      width: size + 30,
      height: size + 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient radiant chromatic halo
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
                        color: AppColors.clay.withValues(alpha: 0.28),
                        blurRadius: 46,
                        spreadRadius: 6,
                      ),
                      BoxShadow(
                        color: AppColors.sage.withValues(alpha: 0.22),
                        blurRadius: 36,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.marigold.withValues(alpha: 0.16),
                        blurRadius: 24,
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
                        blurRadius: 24,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Frosted luxury glass bezel & core
          Container(
            width: coreSize,
            height: coreSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.nightSurfaceRaised,
              border: Border.all(
                color: AppColors.textInverse.withValues(alpha: 0.85),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.night.withValues(alpha: 0.7),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.clay.withValues(alpha: 0.18),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
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

          // Orbiting micro satellite photons (simulating real-time spectrum scanning)
          if (!reduceMotion)
            AnimatedBuilder(
              animation: orbitalAnimation,
              builder: (context, _) {
                final t = orbitalAnimation.value * 2 * math.pi;
                return SizedBox(
                  width: size + 20,
                  height: size + 20,
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

  const _StudioCalibrationHUD({
    required this.progress,
    required this.reduceMotion,
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
                          : AppColors.sage,
                      boxShadow: [
                        BoxShadow(
                          color: (progress >= 0.95
                                  ? AppColors.marigold
                                  : AppColors.sage)
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
                      color: AppColors.nightText,
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
                  color: AppColors.sage,
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
                  color: AppColors.nightLine,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: AppColors.nightMuted.withValues(alpha: 0.35),
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
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.forest,
                        AppColors.sage,
                        AppColors.marigold,
                        AppColors.clay,
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
                      color: AppColors.textInverse,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.marigold.withValues(alpha: 0.8),
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
                  color: AppColors.nightMuted,
                ),
              ),
              Text(
                'MONK SCALE ML (MST 01-10)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.sage,
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

  _MonkScaleRingPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Subtle dashed track ring
    final trackPaint = Paint()
      ..color = AppColors.textInverse.withValues(alpha: 0.08)
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
  bool shouldRepaint(covariant _MonkScaleRingPainter oldDelegate) => false;
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

/// Custom painter for the atmospheric dynamic breathing aurora glow fields
class _AuroraGlowPainter extends CustomPainter {
  final double progress;

  _AuroraGlowPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
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
  }

  @override
  bool shouldRepaint(covariant _AuroraGlowPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
