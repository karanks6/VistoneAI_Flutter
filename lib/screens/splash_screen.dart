import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/color_database.dart';
import '../widgets/design_system.dart';

/// Authentic 10-point Monk Skin Tone scale matching [AnalysisService] anchors.
const List<Color> _monkSkinToneColors = [
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

/// Cohesive light & dark splash surface and ink tokens derived from [ThemeData].
@immutable
class _SplashPalette {
  final Color canvas;
  final Color primaryInk;
  final Color bodyInk;
  final Color mutedInk;
  final Color accentInk;
  final Color goldAccent;
  final Color discOuter;
  final Color discMid;
  final Color discInner;
  final Color botanicalTint;
  final Color controlFill;
  final Color controlPressedFill;
  final Color controlBorder;
  final Color focusRing;
  final Color fanStem;
  final Color fanHairline;
  final List<List<Color>> bladeStepPalettes;

  const _SplashPalette({
    required this.canvas,
    required this.primaryInk,
    required this.bodyInk,
    required this.mutedInk,
    required this.accentInk,
    required this.goldAccent,
    required this.discOuter,
    required this.discMid,
    required this.discInner,
    required this.botanicalTint,
    required this.controlFill,
    required this.controlPressedFill,
    required this.controlBorder,
    required this.focusRing,
    required this.fanStem,
    required this.fanHairline,
    required this.bladeStepPalettes,
  });

  factory _SplashPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = theme.extension<VistoneThemeTokens>();
    final isDark = theme.brightness == Brightness.dark;
    final highContrast = MediaQuery.highContrastOf(context);

    if (isDark) {
      return _SplashPalette(
        canvas: tokens != null
            ? theme.scaffoldBackgroundColor
            : AppColors.night,
        primaryInk: AppColors.nightText,
        bodyInk: AppColors.nightMuted,
        mutedInk: AppColors.sage,
        accentInk: tokens?.accentBotanical ?? AppColors.sage,
        goldAccent: tokens?.accentGold ?? AppColors.marigold,
        discOuter: AppColors.forestDeep.withValues(alpha: 0.44),
        discMid: AppColors.forest.withValues(alpha: 0.32),
        discInner: AppColors.sage.withValues(alpha: 0.12),
        botanicalTint: AppColors.forest.withValues(alpha: 0.22),
        controlFill: AppColors.nightSurfaceRaised.withValues(alpha: 0.94),
        controlPressedFill: AppColors.forestDeep,
        controlBorder: highContrast
            ? AppColors.nightText
            : AppColors.sage.withValues(alpha: 0.55),
        focusRing: tokens?.accentGold ?? AppColors.marigold,
        fanStem: AppColors.nightText,
        fanHairline: AppColors.sage.withValues(alpha: 0.34),
        bladeStepPalettes: const [
          [Color(0xFFDCD6CC), Color(0xFFECE5DA), Color(0xFFF6EFE4)],
          [Color(0xFF496B5E), Color(0xFF6F8E81), Color(0xFFB8CBB6)],
          [Color(0xFF23424B), Color(0xFF365C68), Color(0xFF5D818E)],
        ],
      );
    }

    return _SplashPalette(
      canvas: tokens != null ? theme.scaffoldBackgroundColor : AppColors.canvas,
      primaryInk: AppColors.forestDeep,
      bodyInk: AppColors.inkSoft,
      mutedInk: tokens != null ? scheme.primary : AppColors.forest,
      accentInk: tokens?.accentBotanical ?? AppColors.forest,
      goldAccent: AppColors.warning,
      discOuter: AppColors.sageSoft.withValues(alpha: 0.54),
      discMid: AppColors.sage.withValues(alpha: 0.30),
      discInner: AppColors.forest.withValues(alpha: 0.10),
      botanicalTint: AppColors.sage.withValues(alpha: 0.24),
      controlFill: AppColors.surface.withValues(alpha: 0.95),
      controlPressedFill: AppColors.surfaceSage,
      controlBorder: highContrast
          ? AppColors.forestDeep
          : AppColors.forest.withValues(alpha: 0.48),
      focusRing: AppColors.forestDeep,
      fanStem: AppColors.ink,
      fanHairline: AppColors.forest.withValues(alpha: 0.22),
      bladeStepPalettes: const [
        [Color(0xFFE7E2D9), Color(0xFFDDD3C7), Color(0xFFF6EFE4)],
        [Color(0xFF5D7068), Color(0xFF7D9087), Color(0xFFA0B1A7)],
        [Color(0xFF152934), Color(0xFF284352), Color(0xFF506775)],
      ],
    );
  }
}

/// Editorial opening screen mirroring the Vistone Colour Studio home aesthetic.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _timelineController;
  late final AnimationController _ambientController;
  bool _hasProceeded = false;
  bool _didWarmup = false;
  bool _didConfigureInitialMotion = false;

  @override
  void initState() {
    super.initState();

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );

    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _timelineController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        final accessible = MediaQuery.accessibleNavigationOf(context);
        if (!accessible) {
          _proceed();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final accessibleNavigation = MediaQuery.accessibleNavigationOf(context);

    if (!_didWarmup) {
      _didWarmup = true;
      _warmupStudioResources();
    }

    // Reactive motion & accessibility guard: accessibleNavigation always pauses auto-advance.
    if (reduceMotion && _ambientController.isAnimating) {
      _ambientController.stop();
    }

    if (!_didConfigureInitialMotion) {
      _didConfigureInitialMotion = true;
      if (accessibleNavigation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _timelineController.value = 1.0;
        });
      } else if (reduceMotion) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _timelineController.value = 1.0;
          _proceed();
        });
      } else {
        _ambientController.repeat(reverse: true);
        _timelineController.forward();
      }
    } else if (accessibleNavigation && _timelineController.isAnimating) {
      _timelineController.stop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _timelineController.value = 1.0;
      });
    } else if (reduceMotion && _timelineController.isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _timelineController.value = 1.0;
      });
    }
  }

  Future<void> _warmupStudioResources() async {
    colorDatabase.load();
    if (!mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final homeBackdrop = isDark
        ? 'assets/images/Dark Green Beauty App Interface.png'
        : 'assets/images/Text-Free Sage Beauty App Interface.png';
    try {
      await precacheImage(
        AssetImage(homeBackdrop),
        context,
        onError: (_, __) {},
      );
    } catch (_) {
      // Safe no-op in headless widget tests.
    }
  }

  void _proceed() {
    if (!mounted || _hasProceeded) return;
    _hasProceeded = true;
    context.go('/home');
  }

  @override
  void dispose() {
    _timelineController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _SplashPalette.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final accessibleNavigation = MediaQuery.accessibleNavigationOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(14);
    final isHighScale = textScale > 19.0;

    return Scaffold(
      backgroundColor: palette.canvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative background discs, leaf contours, and crisp star sparkles
          ExcludeSemantics(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _timelineController,
                _ambientController,
              ]),
              builder: (context, _) {
                return CustomPaint(
                  painter: _StudioAtmospherePainter(
                    palette: palette,
                    introProgress: _timelineController.value,
                    breathValue: reduceMotion ? 0.5 : _ambientController.value,
                  ),
                );
              },
            ),
          ),

          // Foreground editorial composition
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                final isCompact = constraints.maxHeight < 700;
                final maxContentWidth = isWide ? 920.0 : 520.0;
                final horizontalPad = isWide ? AppSpacing.xxxl : AppSpacing.xxl;
                final verticalPad = (isCompact || isHighScale)
                    ? AppSpacing.md
                    : AppSpacing.xl;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxContentWidth,
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPad,
                          vertical: verticalPad,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _TopStudioHeader(
                              palette: palette,
                              isReadyForManualEntry: accessibleNavigation,
                              reduceMotion: reduceMotion,
                              isHighScale: isHighScale,
                              onSkip: _proceed,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isCompact
                                    ? AppSpacing.lg
                                    : AppSpacing.xxl,
                              ),
                              child: isWide
                                  ? _WideEditorialStage(
                                      palette: palette,
                                      constraints: constraints,
                                      isHighScale: isHighScale,
                                      progress: _timelineController,
                                      reduceMotion: reduceMotion,
                                    )
                                  : _CompactEditorialStage(
                                      palette: palette,
                                      constraints: constraints,
                                      isCompact: isCompact,
                                      isHighScale: isHighScale,
                                      progress: _timelineController,
                                      reduceMotion: reduceMotion,
                                    ),
                            ),
                            _StudioFooterMark(palette: palette),
                          ],
                        ),
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

/// Top header aligned cleanly with the Home Screen wordmark and accessible Skip control.
class _TopStudioHeader extends StatelessWidget {
  final _SplashPalette palette;
  final bool isReadyForManualEntry;
  final bool reduceMotion;
  final bool isHighScale;
  final VoidCallback onSkip;

  const _TopStudioHeader({
    required this.palette,
    required this.isReadyForManualEntry,
    required this.reduceMotion,
    required this.isHighScale,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final buttonLabel = isReadyForManualEntry ? 'Continue' : 'Skip';

    final brandLockup = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'VISTONE AI',
          style: textTheme.titleSmall?.copyWith(
            color: palette.primaryInk,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Colour Studio',
          style: textTheme.bodySmall?.copyWith(
            color: palette.bodyInk,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );

    final skipControl = _SkipIntroButton(
      palette: palette,
      label: buttonLabel,
      reduceMotion: reduceMotion,
      onTap: onSkip,
    );

    // At very large scale factors, allow graceful wrap so no header text ever truncates.
    if (isHighScale) {
      return Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: [brandLockup, skipControl],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: brandLockup),
        const SizedBox(width: AppSpacing.md),
        skipControl,
      ],
    );
  }
}

/// Tactile, keyboard-focusable Skip/Continue control meeting WCAG AA contrast and 48x48dp hit target.
class _SkipIntroButton extends StatefulWidget {
  final _SplashPalette palette;
  final String label;
  final bool reduceMotion;
  final VoidCallback onTap;

  const _SkipIntroButton({
    required this.palette,
    required this.label,
    required this.reduceMotion,
    required this.onTap,
  });

  @override
  State<_SkipIntroButton> createState() => _SkipIntroButtonState();
}

class _SkipIntroButtonState extends State<_SkipIntroButton> {
  bool _isPressed = false;
  bool _isFocused = false;

  void _triggerTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final highContrast = MediaQuery.highContrastOf(context);
    final scaledArrowSize = MediaQuery.textScalerOf(
      context,
    ).scale(14).clamp(14.0, 22.0);
    final p = widget.palette;
    final accessibleName = widget.label == 'Continue'
        ? 'Continue to studio home'
        : 'Skip introduction and go to studio home';

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (focused) => setState(() => _isFocused = focused),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _triggerTap();
            return null;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (_) {
            _triggerTap();
            return null;
          },
        ),
      },
      child: Semantics(
        container: true,
        button: true,
        enabled: true,
        focusable: true,
        focused: _isFocused,
        label: accessibleName,
        onTap: _triggerTap,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: _triggerTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Center(
              child: AnimatedScale(
                scale: (_isPressed && !widget.reduceMotion) ? 0.95 : 1.0,
                duration: widget.reduceMotion ? Duration.zero : AppMotion.micro,
                curve: AppMotion.standard,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _isPressed ? p.controlPressedFill : p.controlFill,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: _isFocused ? p.focusRing : p.controlBorder,
                      width: _isFocused ? 2.5 : (highContrast ? 1.5 : 1.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Text(
                          widget.label,
                          style: textTheme.labelMedium?.copyWith(
                            color: p.primaryInk,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ExcludeSemantics(
                        child: Icon(
                          LucideIcons.arrowRight,
                          size: scaledArrowSize,
                          color: p.primaryInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vertical editorial layout for phones (< 600px width).
class _CompactEditorialStage extends StatelessWidget {
  final _SplashPalette palette;
  final BoxConstraints constraints;
  final bool isCompact;
  final bool isHighScale;
  final Animation<double> progress;
  final bool reduceMotion;

  const _CompactEditorialStage({
    required this.palette,
    required this.constraints,
    required this.isCompact,
    required this.isHighScale,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final baseFanSize = (constraints.maxHeight * 0.27).clamp(140.0, 210.0);
    final fanSize = isHighScale ? math.min(baseFanSize, 136.0) : baseFanSize;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ExcludeSemantics(
            child: _VistoneSwatchFanSculpture(
              size: fanSize,
              palette: palette,
              progress: progress,
              reduceMotion: reduceMotion,
            ),
          ),
        ),
        SizedBox(height: isCompact ? AppSpacing.xl : AppSpacing.xxxl),
        _EditorialHeadlineBlock(
          palette: palette,
          isCompact: isCompact,
          progress: progress,
          reduceMotion: reduceMotion,
        ),
        SizedBox(height: isCompact ? AppSpacing.lg : AppSpacing.xxl),
        _MonkToneProgressionBar(
          palette: palette,
          progress: progress,
          reduceMotion: reduceMotion,
        ),
      ],
    );
  }
}

/// Two-column magazine editorial layout for wide viewports (>= 600px width).
class _WideEditorialStage extends StatelessWidget {
  final _SplashPalette palette;
  final BoxConstraints constraints;
  final bool isHighScale;
  final Animation<double> progress;
  final bool reduceMotion;

  const _WideEditorialStage({
    required this.palette,
    required this.constraints,
    required this.isHighScale,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final rawSize = (constraints.maxHeight * 0.42).clamp(170.0, 260.0);
    final fanSize = isHighScale ? math.min(rawSize, 165.0) : rawSize;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _EditorialHeadlineBlock(
                palette: palette,
                isCompact: false,
                progress: progress,
                reduceMotion: reduceMotion,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _MonkToneProgressionBar(
                palette: palette,
                progress: progress,
                reduceMotion: reduceMotion,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xxxl),
        Expanded(
          flex: 5,
          child: Center(
            child: ExcludeSemantics(
              child: _VistoneSwatchFanSculpture(
                size: fanSize,
                palette: palette,
                progress: progress,
                reduceMotion: reduceMotion,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bespoke animated architectural V-Fan studio centerpiece unfolding 3 segmented swatch blades.
class _VistoneSwatchFanSculpture extends StatelessWidget {
  final double size;
  final _SplashPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;

  const _VistoneSwatchFanSculpture({
    required this.size,
    required this.palette,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final raw = reduceMotion ? 1.0 : progress.value;
        final stemT = Curves.easeOutCubic.transform(
          (raw / 0.34).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, (1.0 - stemT) * 14.0),
          child: CustomPaint(
            size: Size(size * 1.06, size),
            painter: _SwatchFanPainter(palette: palette, timelineProgress: raw),
          ),
        );
      },
    );
  }
}

/// Precision vector rendering of the iconic Vistone V serif stem and unfolding 3-step swatch fan.
class _SwatchFanPainter extends CustomPainter {
  final _SplashPalette palette;
  final double timelineProgress;

  _SwatchFanPainter({required this.palette, required this.timelineProgress});

  double _interval(double start, double end) {
    final t = ((timelineProgress - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutQuart.transform(t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pivot = Offset(w * 0.44, h * 0.85);
    final bladeRadius = h * 0.72;

    // 1. Subtle architectural quadrant drafting hairline behind the fan
    final arcProgress = _interval(0.24, 0.68);
    if (arcProgress > 0.01) {
      final arcRect = Rect.fromCircle(center: pivot, radius: h * 0.78);
      final arcPaint = Paint()
        ..color = palette.fanHairline.withValues(alpha: 0.9 * arcProgress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      const startAngle = -math.pi * 0.46;
      const maxSweep = math.pi * 0.42;
      canvas.drawArc(
        arcRect,
        startAngle,
        maxSweep * arcProgress,
        false,
        arcPaint,
      );
    }

    // 2. Sculpted solid bottom-right anchor wedge
    final anchorT = _interval(0.08, 0.42);
    if (anchorT > 0.01) {
      _drawBaseWedge(canvas, pivot, bladeRadius * 0.48, anchorT);
    }

    // 3. Unfolding 3 segmented swatch blades (dark mineral -> sage -> silk cream)
    const double foldedAngle = 0.08;
    final bladeConfigs = [
      (
        targetRad: 1.08,
        lengthFactor: 0.82,
        t: _interval(0.14, 0.54),
        steps: palette.bladeStepPalettes[2],
      ),
      (
        targetRad: 0.68,
        lengthFactor: 0.91,
        t: _interval(0.20, 0.62),
        steps: palette.bladeStepPalettes[1],
      ),
      (
        targetRad: 0.31,
        lengthFactor: 1.0,
        t: _interval(0.26, 0.70),
        steps: palette.bladeStepPalettes[0],
      ),
    ];

    for (final blade in bladeConfigs) {
      final angle = foldedAngle + (blade.targetRad - foldedAngle) * blade.t;
      _drawSegmentedBlade(
        canvas,
        pivot: pivot,
        angleFromVertical: angle,
        length: bladeRadius * blade.lengthFactor,
        colors: blade.steps,
        opacity: (0.4 + 0.6 * blade.t).clamp(0.0, 1.0),
      );
    }

    // 4. Sculpted architectural serif 'V' left stem
    _drawSerifLeftStem(canvas, w, h, pivot);

    // 5. Refined brass/gold studio rivet pin at fan vertex
    final pinScale = _interval(0.16, 0.48);
    if (pinScale > 0.01) {
      final pinPaint = Paint()
        ..color = palette.goldAccent.withValues(alpha: pinScale)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pivot, h * 0.024 * pinScale, pinPaint);
    }
  }

  void _drawSerifLeftStem(Canvas canvas, double w, double h, Offset pivot) {
    final stemPaint = Paint()
      ..color = palette.fanStem
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(w * 0.11, h * 0.15)
      ..quadraticBezierTo(w * 0.09, h * 0.15, w * 0.09, h * 0.168)
      ..quadraticBezierTo(w * 0.09, h * 0.186, w * 0.125, h * 0.19)
      ..quadraticBezierTo(w * 0.175, h * 0.205, w * 0.205, h * 0.275)
      ..lineTo(pivot.dx - w * 0.025, pivot.dy - h * 0.012)
      ..lineTo(pivot.dx + w * 0.018, h * 0.56)
      ..lineTo(w * 0.345, h * 0.265)
      ..quadraticBezierTo(w * 0.33, h * 0.20, w * 0.37, h * 0.185)
      ..quadraticBezierTo(w * 0.388, h * 0.18, w * 0.388, h * 0.165)
      ..quadraticBezierTo(w * 0.388, h * 0.15, w * 0.365, h * 0.15)
      ..close();

    canvas.drawPath(path, stemPaint);
  }

  void _drawBaseWedge(
    Canvas canvas,
    Offset pivot,
    double length,
    double revealT,
  ) {
    final paint = Paint()
      ..color = palette.fanStem.withValues(alpha: revealT)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final tipWidth = length * 0.28;
    final startX = pivot.dx + length * 0.14;
    final endX = pivot.dx + length * (0.28 + 0.72 * revealT);
    final baseY = pivot.dy + length * 0.04;

    final path = Path()
      ..moveTo(startX, baseY)
      ..lineTo(endX - 6, baseY)
      ..quadraticBezierTo(endX, baseY, endX, baseY - 6)
      ..lineTo(endX, baseY - tipWidth + 6)
      ..quadraticBezierTo(
        endX,
        baseY - tipWidth,
        endX - 6,
        baseY - tipWidth * 0.94,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawSegmentedBlade(
    Canvas canvas, {
    required Offset pivot,
    required double angleFromVertical,
    required double length,
    required List<Color> colors,
    required double opacity,
  }) {
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(angleFromVertical);

    final segments = [
      (startRatio: 0.14, endRatio: 0.42, color: colors[0]),
      (startRatio: 0.445, endRatio: 0.71, color: colors[1]),
      (startRatio: 0.735, endRatio: 1.00, color: colors[2]),
    ];

    final maxHalfWidth = length * 0.118;
    final gapRadius = length * 0.022;

    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final yBot = -length * seg.startRatio;
      final yTop = -length * seg.endRatio;
      final halfWBot = maxHalfWidth * (0.22 + 0.78 * seg.startRatio);
      final halfWTop = maxHalfWidth * (0.22 + 0.78 * seg.endRatio);
      final r = (i == segments.length - 1) ? gapRadius * 1.8 : gapRadius * 0.9;

      final segPath = Path()
        ..moveTo(-halfWBot + r * 0.4, yBot)
        ..lineTo(halfWBot - r * 0.4, yBot)
        ..quadraticBezierTo(halfWBot, yBot, halfWBot, yBot - r * 0.4)
        ..lineTo(halfWTop, yTop + r)
        ..quadraticBezierTo(halfWTop, yTop, halfWTop - r, yTop)
        ..lineTo(-halfWTop + r, yTop)
        ..quadraticBezierTo(-halfWTop, yTop, -halfWTop, yTop + r)
        ..lineTo(-halfWBot, yBot - r * 0.4)
        ..quadraticBezierTo(-halfWBot, yBot, -halfWBot + r * 0.4, yBot)
        ..close();

      final fillPaint = Paint()
        ..color = seg.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(segPath, fillPaint);

      final borderPaint = Paint()
        ..color = palette.fanHairline.withValues(alpha: 0.65 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75;
      canvas.drawPath(segPath, borderPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SwatchFanPainter oldDelegate) =>
      oldDelegate.timelineProgress != timelineProgress ||
      oldDelegate.palette != palette;
}

/// Editorial serif headline kept at full WCAG contrast, paired with signature gold brush arc.
class _EditorialHeadlineBlock extends StatelessWidget {
  final _SplashPalette palette;
  final bool isCompact;
  final Animation<double> progress;
  final bool reduceMotion;

  const _EditorialHeadlineBlock({
    required this.palette,
    required this.isCompact,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final boldText = MediaQuery.boldTextOf(context);
    final baseDisplay = isCompact
        ? textTheme.displaySmall
        : textTheme.displayMedium;
    final leadWeight = boldText ? FontWeight.w800 : FontWeight.w600;
    final emphasisWeight = boldText ? FontWeight.w900 : FontWeight.w700;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final raw = reduceMotion ? 1.0 : progress.value;
        final liftT = Curves.easeOutCubic.transform(
          (raw / 0.40).clamp(0.0, 1.0),
        );
        final arcT = Curves.easeInOutCubic.transform(
          ((raw - 0.36) / 0.36).clamp(0.0, 1.0),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, (1.0 - liftT) * 10.0),
              child: Semantics(
                header: true,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Colour, read in\n',
                        style: baseDisplay?.copyWith(
                          fontWeight: leadWeight,
                          color: palette.primaryInk,
                        ),
                      ),
                      TextSpan(
                        text: 'your best light.',
                        style: baseDisplay?.copyWith(
                          fontWeight: emphasisWeight,
                          fontStyle: FontStyle.italic,
                          color: palette.primaryInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            ExcludeSemantics(
              child: CustomPaint(
                size: Size(isCompact ? 132 : 164, 10),
                painter: _GoldBrushArcPainter(
                  color: palette.goldAccent,
                  progress: arcT,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            child!,
          ],
        );
      },
      child: Text(
        'A quiet study of natural undertone and balanced harmonies — curated privately on this device.',
        style: textTheme.bodyMedium?.copyWith(color: palette.bodyInk),
      ),
    );
  }
}

/// Draws the warm tapered arched brush stroke beneath italicized serif typography.
class _GoldBrushArcPainter extends CustomPainter {
  final Color color;
  final double progress;

  _GoldBrushArcPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.01) return;

    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.05,
        size.width,
        size.height * 0.56,
      );

    final metric = path.computeMetrics().first;
    final extracted = metric.extractPath(0, metric.length * progress);

    final paint = Paint()
      ..color = color.withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6;

    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant _GoldBrushArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Minimalist horizontal 10-tone Monk Skin Tone capsule strip replacing generic spinners.
class _MonkToneProgressionBar extends StatelessWidget {
  final _SplashPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;

  const _MonkToneProgressionBar({
    required this.palette,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final sweep = reduceMotion
            ? 1.0
            : ((progress.value - 0.06) / 0.88).clamp(0.0, 1.0);
        final isReady = sweep >= 0.96;
        final statusLabel = isReady
            ? 'Studio ready'
            : 'Preparing your colour studio';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Row(
                children: List.generate(_monkSkinToneColors.length, (i) {
                  final isLit = sweep > (i / _monkSkinToneColors.length);
                  final toneColor = _monkSkinToneColors[i];

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: i == _monkSkinToneColors.length - 1 ? 0 : 4,
                      ),
                      child: AnimatedContainer(
                        duration: reduceMotion
                            ? Duration.zero
                            : AppMotion.micro,
                        height: isLit ? 12 : 8,
                        decoration: BoxDecoration(
                          color: isLit
                              ? toneColor
                              : toneColor.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          border: Border.all(
                            color: palette.fanHairline.withValues(
                              alpha: isLit ? 0.55 : 0.25,
                            ),
                            width: 0.75,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              liveRegion: isReady,
              child: Text(
                statusLabel,
                style: textTheme.bodySmall?.copyWith(
                  color: palette.mutedInk,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Editorial bottom footer lockup matching the Home Screen rhythm without ellipsis clipping.
class _StudioFooterMark extends StatelessWidget {
  final _SplashPalette palette;

  const _StudioFooterMark({required this.palette});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.labelSmall?.copyWith(
      color: palette.primaryInk,
      letterSpacing: 1.4,
      fontWeight: FontWeight.w600,
    );

    return Semantics(
      label: 'Vistone AI, On-device colour studio',
      child: Center(
        child: ExcludeSemantics(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accentInk,
                ),
              ),
              Text('VISTONE AI', style: labelStyle),
              Text('·', style: labelStyle),
              Text('ON-DEVICE COLOUR STUDIO', style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws crisp vector concentric discs, subtle botanical foliage, and editorial stars matching Home Screen.
class _StudioAtmospherePainter extends CustomPainter {
  final _SplashPalette palette;
  final double introProgress;
  final double breathValue;

  _StudioAtmospherePainter({
    required this.palette,
    required this.introProgress,
    required this.breathValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final easeIn = Curves.easeOutCubic.transform(
      (introProgress / 0.45).clamp(0.0, 1.0),
    );
    final breathe = (breathValue - 0.5) * 8.0;

    // 1. Top-right layered concentric sage/pine discs matching Home Screen artwork
    final discOrigin = Offset(size.width * 0.94, size.height * 0.04);
    final baseRadius = math.min(size.width, size.height) * 0.56;

    final discPaint1 = Paint()
      ..color = palette.discOuter.withValues(
        alpha: palette.discOuter.a * easeIn,
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(discOrigin, (baseRadius * 1.15) + breathe, discPaint1);

    final discPaint2 = Paint()
      ..color = palette.discMid.withValues(alpha: palette.discMid.a * easeIn)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      discOrigin + Offset(-baseRadius * 0.06, baseRadius * 0.06),
      (baseRadius * 0.82) + breathe * 0.7,
      discPaint2,
    );

    final discPaint3 = Paint()
      ..color = palette.discInner.withValues(
        alpha: palette.discInner.a * easeIn,
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      discOrigin + Offset(-baseRadius * 0.11, baseRadius * 0.11),
      (baseRadius * 0.50) + breathe * 0.4,
      discPaint3,
    );

    // 2. Subtle quiet botanical eucalyptus leaves framing bottom-left diagonal
    final leafPaint = Paint()
      ..color = palette.botanicalTint.withValues(
        alpha: palette.botanicalTint.a * easeIn,
      )
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _drawEucalyptusSilhouette(
      canvas,
      paint: leafPaint,
      origin: Offset(-size.width * 0.04, size.height * 0.74),
      scale: math.min(size.width, size.height) / 420.0,
      rotation: 0.42 + (breathValue - 0.5) * 0.02,
    );

    // 3. Crisp 4-point editorial diamond sparkle stars
    final starT = Curves.easeOut.transform(
      ((introProgress - 0.35) / 0.35).clamp(0.0, 1.0),
    );
    if (starT > 0.01) {
      final starAlpha = 0.65 + (0.30 * math.sin(breathValue * math.pi));
      final starPaint = Paint()
        ..color = palette.goldAccent.withValues(alpha: starAlpha * starT)
        ..style = PaintingStyle.fill;

      _drawFourPointStar(
        canvas,
        Offset(size.width * 0.78, size.height * 0.25),
        6.5,
        starPaint,
      );
      _drawFourPointStar(
        canvas,
        Offset(size.width * 0.73, size.height * 0.29),
        3.8,
        starPaint,
      );
      _drawFourPointStar(
        canvas,
        Offset(size.width * 0.20, size.height * 0.37),
        4.2,
        starPaint,
      );
    }
  }

  void _drawEucalyptusSilhouette(
    Canvas canvas, {
    required Paint paint,
    required Offset origin,
    required double scale,
    required double rotation,
  }) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(rotation);
    canvas.scale(scale);

    final leaves = [
      (dx: 0.0, dy: 0.0, rot: -0.25, len: 110.0),
      (dx: 28.0, dy: -36.0, rot: 0.18, len: 92.0),
      (dx: -12.0, dy: -64.0, rot: -0.45, len: 76.0),
    ];

    for (final l in leaves) {
      canvas.save();
      canvas.translate(l.dx, l.dy);
      canvas.rotate(l.rot);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(-l.len * 0.28, -l.len * 0.45, 0, -l.len)
        ..quadraticBezierTo(l.len * 0.28, -l.len * 0.45, 0, 0)
        ..close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    canvas.restore();
  }

  void _drawFourPointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..quadraticBezierTo(center.dx, center.dy, center.dx + radius, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + radius)
      ..quadraticBezierTo(center.dx, center.dy, center.dx - radius, center.dy)
      ..quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - radius)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StudioAtmospherePainter oldDelegate) =>
      oldDelegate.introProgress != introProgress ||
      oldDelegate.breathValue != breathValue ||
      oldDelegate.palette != palette;
}
