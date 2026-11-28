import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/design_system.dart';
import 'package:url_launcher/url_launcher.dart';

/// Canonical 10-point Harvard / Google Monk Skin Tone spectrum.
const List<({String code, String label, String hex, Color color})> _monkTones =
    [
      (
        code: 'MST 01',
        label: 'Porcelain Fair',
        hex: '#F6EDE4',
        color: Color(0xFFF6EDE4),
      ),
      (
        code: 'MST 02',
        label: 'Ivory Light',
        hex: '#F3E7DB',
        color: Color(0xFFF3E7DB),
      ),
      (
        code: 'MST 03',
        label: 'Warm Alabaster',
        hex: '#F7EAD0',
        color: Color(0xFFF7EAD0),
      ),
      (
        code: 'MST 04',
        label: 'Golden Beige',
        hex: '#EADABA',
        color: Color(0xFFEADABA),
      ),
      (
        code: 'MST 05',
        label: 'Medium Honey Tan',
        hex: '#D7BD96',
        color: Color(0xFFD7BD96),
      ),
      (
        code: 'MST 06',
        label: 'Olive Bronze',
        hex: '#A07E56',
        color: Color(0xFFA07E56),
      ),
      (
        code: 'MST 07',
        label: 'Rich Chestnut',
        hex: '#825C43',
        color: Color(0xFF825C43),
      ),
      (
        code: 'MST 08',
        label: 'Warm Umber',
        hex: '#604134',
        color: Color(0xFF604134),
      ),
      (
        code: 'MST 09',
        label: 'Deep Espresso',
        hex: '#3A312A',
        color: Color(0xFF3A312A),
      ),
      (
        code: 'MST 10',
        label: 'Rich Onyx',
        hex: '#292420',
        color: Color(0xFF292420),
      ),
    ];

/// Resolved design tokens matching Home Screen's Light Silk & Dark Botanical Night aesthetics.
@immutable
class _AboutStudioPalette {
  final bool isDark;
  final Color canvas;
  final Color heroInk;
  final Color bodyInk;
  final Color mutedInk;
  final Color accentForest;
  final Color goldAccent;
  final Color cardFill;
  final Color cardBorder;
  final Color cardShadow;
  final Color badgeFill;
  final Color badgeForeground;
  final Color bannerStart;
  final Color bannerEnd;
  final Color onBannerText;
  final Color onBannerMuted;
  final Color discOuter;
  final Color discMid;
  final Color discInner;
  final Color leafTint;
  final Color dividerColor;
  final Color swatchBorder;
  final Color focusRing;
  final Color fanStem;
  final Color fanHairline;
  final List<List<Color>> bladeStepPalettes;

  const _AboutStudioPalette({
    required this.isDark,
    required this.canvas,
    required this.heroInk,
    required this.bodyInk,
    required this.mutedInk,
    required this.accentForest,
    required this.goldAccent,
    required this.cardFill,
    required this.cardBorder,
    required this.cardShadow,
    required this.badgeFill,
    required this.badgeForeground,
    required this.bannerStart,
    required this.bannerEnd,
    required this.onBannerText,
    required this.onBannerMuted,
    required this.discOuter,
    required this.discMid,
    required this.discInner,
    required this.leafTint,
    required this.dividerColor,
    required this.swatchBorder,
    required this.focusRing,
    required this.fanStem,
    required this.fanHairline,
    required this.bladeStepPalettes,
  });

  factory _AboutStudioPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<VistoneThemeTokens>();
    final isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      return _AboutStudioPalette(
        isDark: true,
        canvas: tokens?.studioCanvas ?? AppColors.emeraldNight,
        heroInk: tokens?.studioInk ?? AppColors.nightText,
        bodyInk: theme.textTheme.bodyLarge?.color ?? AppColors.nightMuted,
        mutedInk: AppColors.sage,
        accentForest: tokens?.accentBotanical ?? AppColors.sage,
        goldAccent: tokens?.accentGold ?? AppColors.marigold,
        cardFill: tokens?.frostedCardFill ?? AppColors.emeraldNightCard,
        cardBorder:
            tokens?.frostedCardBorder ?? AppColors.emeraldNightCardBorder,
        cardShadow: Colors.black.withValues(alpha: 0.28),
        badgeFill: tokens?.mintBadgeFill ?? AppColors.sageBadgeDark,
        badgeForeground: tokens?.mintBadgeForeground ?? AppColors.sageSoft,
        bannerStart: tokens?.emeraldBannerStart ?? AppColors.emeraldBannerStart,
        bannerEnd: tokens?.emeraldBannerEnd ?? AppColors.emeraldBannerEnd,
        onBannerText: tokens?.onBannerText ?? AppColors.nightText,
        onBannerMuted: tokens?.onBannerMuted ?? AppColors.bannerMutedMint,
        discOuter: AppColors.forestDeep.withValues(alpha: 0.50),
        discMid: AppColors.forest.withValues(alpha: 0.34),
        discInner: AppColors.sage.withValues(alpha: 0.14),
        leafTint: AppColors.sage.withValues(alpha: 0.10),
        dividerColor: AppColors.nightLine,
        swatchBorder: AppColors.sageSoft.withValues(alpha: 0.68),
        focusRing: tokens?.accentGold ?? AppColors.marigold,
        fanStem: AppColors.nightText,
        fanHairline: AppColors.sage.withValues(alpha: 0.38),
        bladeStepPalettes: const [
          [Color(0xFFDCD6CC), Color(0xFFECE5DA), Color(0xFFF6EFE4)],
          [Color(0xFF496B5E), Color(0xFF6F8E81), Color(0xFFB8CBB6)],
          [Color(0xFF23424B), Color(0xFF365C68), Color(0xFF5D818E)],
        ],
      );
    }

    return _AboutStudioPalette(
      isDark: false,
      canvas: tokens?.studioCanvas ?? AppColors.silkCanvas,
      heroInk: tokens?.studioInk ?? AppColors.forestInk,
      bodyInk: AppColors.inkSoft,
      mutedInk: AppColors.forest,
      accentForest: tokens?.accentBotanical ?? AppColors.forest,
      goldAccent: AppColors.warning,
      cardFill: tokens?.frostedCardFill ?? AppColors.silkCard,
      cardBorder: tokens?.frostedCardBorder ?? AppColors.line,
      cardShadow: AppColors.ink.withValues(alpha: 0.06),
      badgeFill: tokens?.mintBadgeFill ?? AppColors.sageBadgeLight,
      badgeForeground: tokens?.mintBadgeForeground ?? AppColors.forestDeep,
      bannerStart: tokens?.emeraldBannerStart ?? AppColors.emeraldBannerStart,
      bannerEnd: tokens?.emeraldBannerEnd ?? AppColors.emeraldBannerEnd,
      onBannerText: tokens?.onBannerText ?? AppColors.textInverse,
      onBannerMuted: tokens?.onBannerMuted ?? AppColors.bannerMutedMint,
      discOuter: AppColors.sageSoft.withValues(alpha: 0.58),
      discMid: AppColors.sage.withValues(alpha: 0.32),
      discInner: AppColors.forest.withValues(alpha: 0.10),
      leafTint: AppColors.sage.withValues(alpha: 0.22),
      dividerColor: AppColors.line,
      swatchBorder: AppColors.inkSoft.withValues(alpha: 0.70),
      focusRing: AppColors.forestDeep,
      fanStem: AppColors.forestInk,
      fanHairline: AppColors.forest.withValues(alpha: 0.24),
      bladeStepPalettes: const [
        [Color(0xFFE7E2D9), Color(0xFFDDD3C7), Color(0xFFF6EFE4)],
        [Color(0xFF5D7068), Color(0xFF7D9087), Color(0xFFA0B1A7)],
        [Color(0xFF152934), Color(0xFF284352), Color(0xFF506775)],
      ],
    );
  }
}

/// Architectural About & Methodology screen styled natively after Vistone's Home studio.
class AboutScreen extends StatefulWidget {
  final Future<bool> Function(Uri url, {LaunchMode mode})? urlLauncher;

  const AboutScreen({super.key, this.urlLauncher});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final ScrollController _scrollController;
  bool _didStartMotion = false;
  int _selectedToneIndex = 4; // Highlights MST 05 by default
  int? _expandedMethodIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (!_didStartMotion) {
      _didStartMotion = true;
      if (reduceMotion) {
        _entranceController.value = 1.0;
      } else {
        _entranceController.forward();
      }
    } else if (reduceMotion && _entranceController.isAnimating) {
      _entranceController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateHome() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _AboutStudioPalette.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: palette.canvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated botanical atmosphere synchronized with entrance and gentle scroll parallax
          ExcludeSemantics(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _entranceController,
                _scrollController,
              ]),
              builder: (context, _) {
                final scrollOffset = _scrollController.hasClients
                    ? _scrollController.offset
                    : 0.0;
                return CustomPaint(
                  painter: _AboutAtmospherePainter(
                    palette: palette,
                    progress: reduceMotion ? 1.0 : _entranceController.value,
                    scrollOffset: reduceMotion ? 0.0 : scrollOffset,
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 680;
                final maxWidth = isWide ? 860.0 : 540.0;
                final horizontalPadding = isWide
                    ? AppSpacing.xxxl
                    : AppSpacing.xl;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            AppSpacing.md,
                            horizontalPadding,
                            AppSpacing.xxxl,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _AnimatedReveal(
                                animation: _entranceController,
                                start: 0.0,
                                end: 0.34,
                                slideY: 8,
                                reduceMotion: reduceMotion,
                                child: _AboutTopBar(
                                  palette: palette,
                                  onBack: _navigateHome,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: _AnimatedReveal(
                                        animation: _entranceController,
                                        start: 0.08,
                                        end: 0.52,
                                        slideY: 14,
                                        reduceMotion: reduceMotion,
                                        child: _AboutHeroHeadline(
                                          palette: palette,
                                          progress: _entranceController,
                                          reduceMotion: reduceMotion,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.xxl),
                                    Expanded(
                                      flex: 5,
                                      child: _AnimatedReveal(
                                        animation: _entranceController,
                                        start: 0.16,
                                        end: 0.64,
                                        slideY: 16,
                                        reduceMotion: reduceMotion,
                                        child: _AtelierShowcaseCard(
                                          palette: palette,
                                          progress: _entranceController,
                                          reduceMotion: reduceMotion,
                                          selectedToneIndex: _selectedToneIndex,
                                          onSelectTone: (idx) => setState(
                                            () => _selectedToneIndex = idx,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _AnimatedReveal(
                                  animation: _entranceController,
                                  start: 0.08,
                                  end: 0.52,
                                  slideY: 12,
                                  reduceMotion: reduceMotion,
                                  child: _AboutHeroHeadline(
                                    palette: palette,
                                    progress: _entranceController,
                                    reduceMotion: reduceMotion,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xxl),
                                _AnimatedReveal(
                                  animation: _entranceController,
                                  start: 0.18,
                                  end: 0.68,
                                  slideY: 16,
                                  reduceMotion: reduceMotion,
                                  child: _AtelierShowcaseCard(
                                    palette: palette,
                                    progress: _entranceController,
                                    reduceMotion: reduceMotion,
                                    selectedToneIndex: _selectedToneIndex,
                                    onSelectTone: (idx) => setState(
                                      () => _selectedToneIndex = idx,
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.section),
                              _AnimatedReveal(
                                animation: _entranceController,
                                start: 0.30,
                                end: 0.72,
                                slideY: 14,
                                reduceMotion: reduceMotion,
                                child: _SectionHeader(
                                  palette: palette,
                                  icon: LucideIcons.lightbulb,
                                  title: 'How Vistone reads tone',
                                  subtitle:
                                      'Three deterministic stages calibrating every palette.',
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _MethodSection(
                                palette: palette,
                                animation: _entranceController,
                                reduceMotion: reduceMotion,
                                expandedIndex: _expandedMethodIndex,
                                onToggleExpand: (idx) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _expandedMethodIndex =
                                        _expandedMethodIndex == idx
                                        ? null
                                        : idx;
                                  });
                                },
                              ),
                              const SizedBox(height: AppSpacing.section),
                              if (isWide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _AnimatedReveal(
                                        animation: _entranceController,
                                        start: 0.45,
                                        end: 0.90,
                                        slideY: 14,
                                        reduceMotion: reduceMotion,
                                        child: _PrivacyEmeraldCard(
                                          palette: palette,
                                          progress: _entranceController,
                                          reduceMotion: reduceMotion,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.lg),
                                    Expanded(
                                      child: _AnimatedReveal(
                                        animation: _entranceController,
                                        start: 0.52,
                                        end: 0.96,
                                        slideY: 14,
                                        reduceMotion: reduceMotion,
                                        child: _DeveloperAtelierCard(
                                          palette: palette,
                                          urlLauncher: widget.urlLauncher,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _AnimatedReveal(
                                  animation: _entranceController,
                                  start: 0.45,
                                  end: 0.90,
                                  slideY: 14,
                                  reduceMotion: reduceMotion,
                                  child: _PrivacyEmeraldCard(
                                    palette: palette,
                                    progress: _entranceController,
                                    reduceMotion: reduceMotion,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                _AnimatedReveal(
                                  animation: _entranceController,
                                  start: 0.54,
                                  end: 0.98,
                                  slideY: 14,
                                  reduceMotion: reduceMotion,
                                  child: _DeveloperAtelierCard(
                                    palette: palette,
                                    urlLauncher: widget.urlLauncher,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.section),
                              _AnimatedReveal(
                                animation: _entranceController,
                                start: 0.62,
                                end: 1.0,
                                slideY: 12,
                                reduceMotion: reduceMotion,
                                child: _AboutFooterSection(
                                  palette: palette,
                                  onStartAnalysis: () => context.go('/home'),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
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

/// Smooth staggered opacity & upward glide wrapper respecting reduced-motion accessibility.
class _AnimatedReveal extends StatelessWidget {
  final Animation<double> animation;
  final double start;
  final double end;
  final double slideY;
  final bool reduceMotion;
  final Widget child;

  const _AnimatedReveal({
    required this.animation,
    required this.start,
    required this.end,
    required this.slideY,
    required this.reduceMotion,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (reduceMotion) return child;

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final raw = ((animation.value - start) / (end - start)).clamp(0.0, 1.0);
        final eased = AppMotion.standard.transform(raw);
        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(0, (1.0 - eased) * slideY),
            child: child,
          ),
        );
      },
    );
  }
}

/// Top editorial navigation bar matching Home Screen's tracked VISTONE AI studio identity.
class _AboutTopBar extends StatelessWidget {
  final _AboutStudioPalette palette;
  final VoidCallback onBack;

  const _AboutTopBar({required this.palette, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scaledFontSize = MediaQuery.textScalerOf(context).scale(14);

    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldWrap = constraints.maxWidth < 340 || scaledFontSize > 16.0;

        final titleLockup = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'VISTONE AI',
              style: textTheme.labelMedium?.copyWith(
                color: palette.heroInk,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'THE VISTONE METHOD',
              style: textTheme.labelSmall?.copyWith(
                color: palette.mutedInk,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );

        final studioChip = DecoratedBox(
          decoration: BoxDecoration(
            color: palette.badgeFill,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(
              color: palette.accentForest.withValues(alpha: 0.22),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 6,
            ),
            child: Text(
              'Colour Studio',
              style: textTheme.bodySmall?.copyWith(
                color: palette.badgeForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

        if (shouldWrap) {
          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppIconButton(
                icon: LucideIcons.arrowLeft,
                semanticLabel: 'Return home',
                onTap: onBack,
              ),
              titleLockup,
              studioChip,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppIconButton(
              icon: LucideIcons.arrowLeft,
              semanticLabel: 'Return home',
              onTap: onBack,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: titleLockup),
            const SizedBox(width: AppSpacing.sm),
            Flexible(flex: 0, child: studioChip),
          ],
        );
      },
    );
  }
}

/// Home-aligned serif hero headline paired with the animated warm-gold arched underline.
class _AboutHeroHeadline extends StatelessWidget {
  final _AboutStudioPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;

  const _AboutHeroHeadline({
    required this.palette,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final boldText = MediaQuery.boldTextOf(context);
    final leadWeight = boldText ? FontWeight.w700 : FontWeight.w600;
    final emphasisWeight = boldText ? FontWeight.w800 : FontWeight.w700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Personal colour,\n',
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: leadWeight,
                    height: 1.08,
                    color: palette.heroInk,
                  ),
                ),
                TextSpan(
                  text: 'without the rules.',
                  style: textTheme.displayMedium?.copyWith(
                    fontWeight: emphasisWeight,
                    fontStyle: FontStyle.italic,
                    height: 1.08,
                    color: palette.heroInk,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        ExcludeSemantics(
          child: AnimatedBuilder(
            animation: progress,
            builder: (context, _) {
              final raw = reduceMotion
                  ? 1.0
                  : ((progress.value - 0.18) / 0.42).clamp(0.0, 1.0);
              final arcT = AppMotion.emphasized.transform(raw);
              return CustomPaint(
                size: const Size(156, 10),
                painter: _GoldBrushArcPainter(
                  color: palette.goldAccent,
                  progress: arcT,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Vistone was engineered to bridge computational color science and daily self-expression. We calibrate your unique skin reflectance and undertone to suggest colors that harmonize naturally with your complexion.',
          style: textTheme.bodyLarge?.copyWith(
            color: palette.bodyInk,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Home-inspired frosted card featuring an overlapping top circular V-Fan medallion
/// and an interactive 10-point Monk Skin Tone spectrum bar.
class _AtelierShowcaseCard extends StatelessWidget {
  final _AboutStudioPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;
  final int selectedToneIndex;
  final ValueChanged<int> onSelectTone;

  const _AtelierShowcaseCard({
    required this.palette,
    required this.progress,
    required this.reduceMotion,
    required this.selectedToneIndex,
    required this.onSelectTone,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final activeTone = _monkTones[selectedToneIndex];
    const double medallionSize = 72;

    return Padding(
      // Reserve top clearance so the overlapping circular emblem sits naturally inside layout bounds.
      padding: const EdgeInsets.only(top: medallionSize * 0.45),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: palette.cardFill,
              borderRadius: BorderRadius.circular(AppRadii.uploadCard),
              border: Border.all(color: palette.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: palette.cardShadow,
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.uploadCard),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: _CardCornerLeavesPainter(
                          color: palette.leafTint,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      medallionSize * 0.65,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: palette.badgeFill,
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 5,
                            ),
                            child: Text(
                              'COLOUR SCIENCE & INCLUSIVITY',
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall?.copyWith(
                                color: palette.badgeForeground,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Semantics(
                          container: true,
                          header: true,
                          child: Text(
                            'Colour, Considered.',
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              color: palette.heroInk,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Calibrated across all 10 Monk Skin Tone depths in CIELAB space.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            color: palette.bodyInk,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _InteractiveMonkSpectrumBar(
                          palette: palette,
                          progress: progress,
                          reduceMotion: reduceMotion,
                          selectedIndex: selectedToneIndex,
                          onSelect: onSelectTone,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _ToneStepButton(
                              palette: palette,
                              icon: LucideIcons.chevronLeft,
                              semanticLabel: 'Previous Monk tone',
                              enabled: selectedToneIndex > 0,
                              onTap: () => onSelectTone(selectedToneIndex - 1),
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: reduceMotion
                                    ? Duration.zero
                                    : AppMotion.routeTransition,
                                switchInCurve: AppMotion.standard,
                                child: Semantics(
                                  liveRegion: true,
                                  container: true,
                                  child: Row(
                                    key: ValueKey(activeTone.code),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ExcludeSemantics(
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: activeTone.color,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: palette.swatchBorder,
                                              width: 1.25,
                                            ),
                                          ),
                                          child: const SizedBox(
                                            width: 12,
                                            height: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Flexible(
                                        child: Text(
                                          '${activeTone.code} · ${activeTone.label} · ${activeTone.hex}',
                                          textAlign: TextAlign.center,
                                          style: textTheme.labelMedium
                                              ?.copyWith(
                                                color: palette.heroInk,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _ToneStepButton(
                              palette: palette,
                              icon: LucideIcons.chevronRight,
                              semanticLabel: 'Next Monk tone',
                              enabled:
                                  selectedToneIndex < _monkTones.length - 1,
                              onTap: () => onSelectTone(selectedToneIndex + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Anchored overlapping top-center circular V-Swatch Fan medallion (Home Screen signature)
          Positioned(
            top: -(medallionSize * 0.45),
            child: ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.badgeFill,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.cardFill, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: palette.cardShadow,
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: medallionSize,
                  height: medallionSize,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: progress,
                      builder: (context, _) {
                        return CustomPaint(
                          size: const Size(44, 42),
                          painter: _AboutSwatchFanPainter(
                            palette: palette,
                            progress: reduceMotion ? 1.0 : progress.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Accessible 48x48dp circular stepper button for stepping between MST tiers.
class _ToneStepButton extends StatelessWidget {
  final _AboutStudioPalette palette;
  final IconData icon;
  final String semanticLabel;
  final bool enabled;
  final VoidCallback onTap;

  const _ToneStepButton({
    required this.palette,
    required this.icon,
    required this.semanticLabel,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: enabled
                ? () {
                    HapticFeedback.selectionClick();
                    onTap();
                  }
                : null,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: enabled
                    ? palette.heroInk
                    : palette.swatchBorder.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single continuous interactive 10-tone spectrum scrubber with keyboard support and >= 48dp hit target.
class _InteractiveMonkSpectrumBar extends StatefulWidget {
  final _AboutStudioPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _InteractiveMonkSpectrumBar({
    required this.palette,
    required this.progress,
    required this.reduceMotion,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<_InteractiveMonkSpectrumBar> createState() =>
      _InteractiveMonkSpectrumBarState();
}

class _InteractiveMonkSpectrumBarState
    extends State<_InteractiveMonkSpectrumBar> {
  bool _isFocused = false;

  void _selectIndex(int index) {
    final clamped = index.clamp(0, _monkTones.length - 1);
    if (clamped != widget.selectedIndex) {
      HapticFeedback.selectionClick();
      widget.onSelect(clamped);
    }
  }

  void _pickAt(double localX, double width) {
    if (width <= 0) return;
    _selectIndex((localX / width * _monkTones.length).floor());
  }

  @override
  Widget build(BuildContext context) {
    final current = _monkTones[widget.selectedIndex];
    final p = widget.palette;

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;

        return FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowFocusHighlight: (focused) =>
              setState(() => _isFocused = focused),
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.arrowRight):
                const _StepToneIntent(1),
            const SingleActivator(LogicalKeyboardKey.arrowUp):
                const _StepToneIntent(1),
            const SingleActivator(LogicalKeyboardKey.arrowLeft):
                const _StepToneIntent(-1),
            const SingleActivator(LogicalKeyboardKey.arrowDown):
                const _StepToneIntent(-1),
            const SingleActivator(LogicalKeyboardKey.home):
                const _JumpToneIntent(0),
            const SingleActivator(LogicalKeyboardKey.end):
                const _JumpToneIntent(9),
          },
          actions: {
            _StepToneIntent: CallbackAction<_StepToneIntent>(
              onInvoke: (intent) {
                _selectIndex(widget.selectedIndex + intent.delta);
                return null;
              },
            ),
            _JumpToneIntent: CallbackAction<_JumpToneIntent>(
              onInvoke: (intent) {
                _selectIndex(intent.index);
                return null;
              },
            ),
          },
          child: Semantics(
            container: true,
            slider: true,
            focusable: true,
            focused: _isFocused,
            label: 'Monk Skin Tone 10-tier spectrum selector',
            value: '${current.code}, ${current.label}',
            increasedValue: widget.selectedIndex < _monkTones.length - 1
                ? _monkTones[widget.selectedIndex + 1].code
                : current.code,
            decreasedValue: widget.selectedIndex > 0
                ? _monkTones[widget.selectedIndex - 1].code
                : current.code,
            onIncrease: widget.selectedIndex < _monkTones.length - 1
                ? () => _selectIndex(widget.selectedIndex + 1)
                : null,
            onDecrease: widget.selectedIndex > 0
                ? () => _selectIndex(widget.selectedIndex - 1)
                : null,
            child: GestureDetector(
              key: const ValueKey('monk_spectrum_bar'),
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) => _pickAt(details.localPosition.dx, barWidth),
              onHorizontalDragUpdate: (details) =>
                  _pickAt(details.localPosition.dx, barWidth),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: _isFocused
                        ? Border.all(color: p.focusRing, width: 2.0)
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isFocused ? 4 : 0,
                    ),
                    child: AnimatedBuilder(
                      animation: widget.progress,
                      builder: (context, _) {
                        final raw = widget.reduceMotion
                            ? 1.0
                            : ((widget.progress.value - 0.24) / 0.56).clamp(
                                0.0,
                                1.0,
                              );
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(_monkTones.length, (i) {
                            final tone = _monkTones[i];
                            final isSelected = i == widget.selectedIndex;
                            final revealed =
                                raw >= (i / _monkTones.length) * 0.85;

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: i == _monkTones.length - 1 ? 0 : 4,
                                ),
                                child: AnimatedContainer(
                                  duration: widget.reduceMotion
                                      ? Duration.zero
                                      : AppMotion.ringScale,
                                  curve: AppMotion.standard,
                                  height: isSelected ? 24 : 15,
                                  decoration: BoxDecoration(
                                    color: revealed
                                        ? tone.color
                                        : tone.color.withValues(alpha: 0.30),
                                    borderRadius: BorderRadius.circular(
                                      AppRadii.pill,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? p.heroInk
                                          : p.swatchBorder,
                                      width: isSelected ? 2.5 : 1.0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: p.accentForest.withValues(
                                                alpha: 0.28,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StepToneIntent extends Intent {
  final int delta;
  const _StepToneIntent(this.delta);
}

class _JumpToneIntent extends Intent {
  final int index;
  const _JumpToneIntent(this.index);
}

/// Home-aligned section header featuring an icon + Playfair Display heading + subtitle.
class _SectionHeader extends StatelessWidget {
  final _AboutStudioPalette palette;
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.palette,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: palette.heroInk, size: 22),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Semantics(
                container: true,
                header: true,
                child: Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: palette.heroInk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: palette.bodyInk),
        ),
      ],
    );
  }
}

/// Three methodology pill-cards directly modeled on Home Screen's Preparation Guide tiles.
class _MethodSection extends StatelessWidget {
  final _AboutStudioPalette palette;
  final Animation<double> animation;
  final bool reduceMotion;
  final int? expandedIndex;
  final ValueChanged<int> onToggleExpand;

  const _MethodSection({
    required this.palette,
    required this.animation,
    required this.reduceMotion,
    required this.expandedIndex,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    const entries = [
      (
        icon: LucideIcons.scanFace,
        title: 'Harvard Monk Scale (MST)',
        body:
            'Developed by Dr. Ellis Monk to overcome limitations in legacy dermatology scales, categorizing human skin into 10 nuanced, equitable shades.',
        detail:
            'Calibrates lightness depth independently from hue bias across light, medium, and rich complexions.',
      ),
      (
        icon: LucideIcons.layers,
        title: 'Biometric Pixel Sampling',
        body:
            'We sample median skin pixels across forehead, cheek, and chin zones using Google ML Kit, discarding specular highlights and shadows.',
        detail:
            'Robust interquartile outlier filtering suppresses bright glare and deep cast shadows before classification.',
      ),
      (
        icon: LucideIcons.palette,
        title: 'Color Temperature Synthesis',
        body:
            'By assessing individual red/yellow melanin balance against your luminance tier, we curate shades that maximize your natural glow.',
        detail:
            'Maps depth and warm/cool/neutral balance directly to wearable seasonal palettes without guesswork.',
      ),
    ];

    return Column(
      children: List.generate(entries.length, (index) {
        final item = entries[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == entries.length - 1 ? 0 : AppSpacing.md,
          ),
          child: _AnimatedReveal(
            animation: animation,
            start: 0.34 + index * 0.08,
            end: (0.76 + index * 0.08).clamp(0.0, 1.0),
            slideY: 12,
            reduceMotion: reduceMotion,
            child: _MethodPillCard(
              palette: palette,
              stepNumber: '0${index + 1}',
              icon: item.icon,
              title: item.title,
              body: item.body,
              detail: item.detail,
              isExpanded: expandedIndex == index,
              reduceMotion: reduceMotion,
              onTap: () => onToggleExpand(index),
            ),
          ),
        );
      }),
    );
  }
}

class _MethodPillCard extends StatefulWidget {
  final _AboutStudioPalette palette;
  final String stepNumber;
  final IconData icon;
  final String title;
  final String body;
  final String detail;
  final bool isExpanded;
  final bool reduceMotion;
  final VoidCallback onTap;

  const _MethodPillCard({
    required this.palette,
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.body,
    required this.detail,
    required this.isExpanded,
    required this.reduceMotion,
    required this.onTap,
  });

  @override
  State<_MethodPillCard> createState() => _MethodPillCardState();
}

class _MethodPillCardState extends State<_MethodPillCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final p = widget.palette;

    final accessibleLabel =
        '${widget.title}. Step ${widget.stepNumber}. ${widget.body}${widget.isExpanded ? '. ${widget.detail}' : ''}';

    return Semantics(
      container: true,
      button: true,
      expanded: widget.isExpanded,
      excludeSemantics: true,
      label: accessibleLabel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: (_pressed && !widget.reduceMotion) ? 0.985 : 1.0,
        duration: widget.reduceMotion ? Duration.zero : AppMotion.micro,
        curve: AppMotion.standard,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: p.cardFill,
            borderRadius: BorderRadius.circular(AppRadii.uploadCard),
            border: Border.all(
              color: widget.isExpanded
                  ? p.accentForest.withValues(alpha: 0.55)
                  : p.cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: p.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.uploadCard),
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              borderRadius: BorderRadius.circular(AppRadii.uploadCard),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular sage-mint medallion mirroring Home Screen Preparation Guide icons
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: p.badgeFill,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Center(
                              child: Icon(
                                widget.icon,
                                color: p.badgeForeground,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: textTheme.titleMedium?.copyWith(
                                  color: p.heroInk,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.body,
                                style: textTheme.bodySmall?.copyWith(
                                  color: p.bodyInk,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.stepNumber,
                              style: textTheme.labelSmall?.copyWith(
                                color: p.mutedInk,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedRotation(
                              turns: widget.isExpanded ? 0.25 : 0.0,
                              duration: widget.reduceMotion
                                  ? Duration.zero
                                  : AppMotion.ringScale,
                              curve: AppMotion.standard,
                              child: Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: p.mutedInk,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: widget.reduceMotion
                          ? Duration.zero
                          : AppMotion.routeTransition,
                      curve: AppMotion.standard,
                      alignment: Alignment.topCenter,
                      child: widget.isExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.md,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: p.badgeFill.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(
                                    AppRadii.md,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        LucideIcons.sparkles,
                                        size: 14,
                                        color: p.badgeForeground,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          widget.detail,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: p.badgeForeground,
                                            fontWeight: FontWeight.w500,
                                            height: 1.38,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(width: double.infinity),
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

/// Deep emerald silk wave banner card mirroring Home Screen's "How Vistone sees colour" anchor card.
class _PrivacyEmeraldCard extends StatelessWidget {
  final _AboutStudioPalette palette;
  final Animation<double> progress;
  final bool reduceMotion;

  const _PrivacyEmeraldCard({
    required this.palette,
    required this.progress,
    required this.reduceMotion,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.bannerStart, palette.bannerEnd],
        ),
        borderRadius: BorderRadius.circular(AppRadii.uploadCard),
        border: Border.all(
          color: AppColors.sage.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.bannerStart.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.uploadCard),
        child: Stack(
          children: [
            Positioned.fill(
              child: ExcludeSemantics(
                child: AnimatedBuilder(
                  animation: progress,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _EmeraldWaveRibbonPainter(
                        progress: reduceMotion ? 1.0 : progress.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.shieldCheck,
                        color: AppColors.marigold,
                        size: 24,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        width: 1,
                        height: 22,
                        color: AppColors.textInverse.withValues(alpha: 0.24),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Semantics(
                          container: true,
                          header: true,
                          child: Text(
                            'Respectfully Private & Offline',
                            style: textTheme.titleLarge?.copyWith(
                              color: palette.onBannerText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'All facial detection, pixel classification, and color matching run completely offline inside the app sandbox. No image is uploaded, indexed, or shared with third parties.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: palette.onBannerMuted,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.textInverse.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: AppColors.textInverse.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.lock,
                            size: 13,
                            color: AppColors.marigold,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '100% ON-DEVICE SANDBOX',
                              style: textTheme.labelSmall?.copyWith(
                                color: palette.onBannerText,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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

/// Editorial Lead Architect & Developer card matching Home Screen's silk cards & interactive pill links.
class _DeveloperAtelierCard extends StatelessWidget {
  final _AboutStudioPalette palette;
  final Future<bool> Function(Uri url, {LaunchMode mode})? urlLauncher;

  const _DeveloperAtelierCard({required this.palette, this.urlLauncher});

  Future<void> _openUrl(BuildContext context, String url) async {
    await HapticFeedback.lightImpact();
    final uri = Uri.parse(url);
    final launcher = urlLauncher ?? launchUrl;
    bool launched = false;

    try {
      launched = await launcher(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }

    if (!launched) {
      try {
        launched = await launcher(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        launched = false;
      }
    }

    if (!launched && context.mounted) {
      final cleanText = url.startsWith('mailto:') ? url.substring(7) : url;
      await Clipboard.setData(ClipboardData(text: cleanText));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied link: $cleanText'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.cardFill,
        borderRadius: BorderRadius.circular(AppRadii.uploadCard),
        border: Border.all(color: palette.cardBorder),
        boxShadow: [
          BoxShadow(
            color: palette.cardShadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'LEAD ARCHITECT & DEVELOPER',
                    style: textTheme.labelSmall?.copyWith(
                      color: palette.mutedInk,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.badgeFill,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: palette.accentForest.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 4,
                    ),
                    child: Text(
                      'v1.0.0+1',
                      style: textTheme.labelSmall?.copyWith(
                        color: palette.badgeForeground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExcludeSemantics(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [palette.bannerStart, palette.bannerEnd],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.marigold.withValues(alpha: 0.65),
                        width: 1.5,
                      ),
                    ),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Center(
                        child: Text(
                          'KS',
                          style: textTheme.titleMedium?.copyWith(
                            color: palette.onBannerText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        container: true,
                        header: true,
                        child: Text(
                          'Karan S Suvarna',
                          style: textTheme.headlineMedium?.copyWith(
                            color: palette.heroInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Design & On-Device Vision Engineering',
                        style: textTheme.bodySmall?.copyWith(
                          color: palette.bodyInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _StudioLinkTile(
              palette: palette,
              icon: LucideIcons.mail,
              label: 'suvarnakaran77@gmail.com',
              semanticLabel: 'Send email to suvarnakaran77@gmail.com',
              onTap: () => _openUrl(context, 'mailto:suvarnakaran77@gmail.com'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StudioLinkTile(
              palette: palette,
              icon: LucideIcons.github,
              label: 'github.com/karanks6',
              semanticLabel: 'Visit GitHub profile karanks6',
              onTap: () => _openUrl(context, 'https://github.com/karanks6'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StudioLinkTile(
              palette: palette,
              icon: LucideIcons.globe,
              label: 'aboutkaran.vercel.app',
              semanticLabel: 'Visit portfolio website aboutkaran.vercel.app',
              onTap: () => _openUrl(context, 'https://aboutkaran.vercel.app/'),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StudioLinkTile(
              palette: palette,
              icon: LucideIcons.instagram,
              label: 'instagram.com/_karan_suvarna_',
              semanticLabel: 'Visit Instagram profile karan suvarna',
              onTap: () => _openUrl(
                context,
                'https://www.instagram.com/_karan_suvarna_?exln=dHo4NGF2aWcyNDNu',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Divider(height: 1, color: palette.dividerColor),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'App Version',
                    style: textTheme.labelSmall?.copyWith(
                      color: palette.bodyInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    'v1.0.0+1 (Build 1)',
                    textAlign: TextAlign.end,
                    style: textTheme.labelSmall?.copyWith(
                      color: palette.badgeForeground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tactile interactive link row meeting >= 48dp hit target height and studio contrast standards.
class _StudioLinkTile extends StatefulWidget {
  final _AboutStudioPalette palette;
  final IconData icon;
  final String label;
  final String semanticLabel;
  final VoidCallback onTap;

  const _StudioLinkTile({
    required this.palette,
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  State<_StudioLinkTile> createState() => _StudioLinkTileState();
}

class _StudioLinkTileState extends State<_StudioLinkTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final p = widget.palette;

    return Semantics(
      container: true,
      button: true,
      excludeSemantics: true,
      label: widget.semanticLabel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: (_pressed && !reduceMotion) ? 0.985 : 1.0,
        duration: reduceMotion ? Duration.zero : AppMotion.micro,
        curve: AppMotion.standard,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: p.canvas.withValues(alpha: p.isDark ? 0.55 : 0.65),
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(color: p.cardBorder),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              borderRadius: BorderRadius.circular(AppRadii.md),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: p.badgeFill,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Center(
                            child: Icon(
                              widget.icon,
                              size: 16,
                              color: p.badgeForeground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: textTheme.bodyMedium?.copyWith(
                            color: p.heroInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        LucideIcons.arrowUpRight,
                        size: 15,
                        color: p.mutedInk,
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

/// Primary CTA + Home-matched bottom status lockup.
class _AboutFooterSection extends StatelessWidget {
  final _AboutStudioPalette palette;
  final VoidCallback onStartAnalysis;

  const _AboutFooterSection({
    required this.palette,
    required this.onStartAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statusStyle = textTheme.labelSmall?.copyWith(
      color: palette.heroInk,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            label: 'Find my palette',
            icon: LucideIcons.camera,
            trailingIcon: LucideIcons.arrowRight,
            onPressed: onStartAnalysis,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Engineered to celebrate every skin tone with equity and elegance.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: palette.bodyInk),
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          container: true,
          label: 'Vistone AI, On-device colour studio',
          child: ExcludeSemantics(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.accentForest,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(width: 7, height: 7),
                ),
                Text('VISTONE AI', style: statusStyle),
                Text('·', style: statusStyle),
                Text('ON-DEVICE COLOUR STUDIO', style: statusStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws Home Screen's layered concentric botanical discs, subtle corner leaves, and gold diamond stars.
class _AboutAtmospherePainter extends CustomPainter {
  final _AboutStudioPalette palette;
  final double progress;
  final double scrollOffset;

  _AboutAtmospherePainter({
    required this.palette,
    required this.progress,
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final easeIn = AppMotion.standard.transform(
      (progress / 0.5).clamp(0.0, 1.0),
    );
    final parallaxY = -(scrollOffset * 0.12).clamp(-60.0, 60.0);

    // 1. Top-right concentric layered circles mirroring Home Screen backdrop
    final discOrigin = Offset(
      size.width * 0.94,
      size.height * 0.04 + parallaxY,
    );
    final baseRadius = math.min(size.width, size.height) * 0.54;

    canvas.drawCircle(
      discOrigin,
      baseRadius * 1.12 * (0.94 + 0.06 * easeIn),
      Paint()
        ..color = palette.discOuter.withValues(
          alpha: palette.discOuter.a * easeIn,
        ),
    );
    canvas.drawCircle(
      discOrigin + Offset(-baseRadius * 0.06, baseRadius * 0.06),
      baseRadius * 0.80 * (0.94 + 0.06 * easeIn),
      Paint()
        ..color = palette.discMid.withValues(alpha: palette.discMid.a * easeIn),
    );
    canvas.drawCircle(
      discOrigin + Offset(-baseRadius * 0.11, baseRadius * 0.11),
      baseRadius * 0.48 * (0.94 + 0.06 * easeIn),
      Paint()
        ..color = palette.discInner.withValues(
          alpha: palette.discInner.a * easeIn,
        ),
    );

    // 2. Subtle bottom-left eucalyptus leaves echoing Home Screen border foliage
    final leafPaint = Paint()
      ..color = palette.leafTint.withValues(alpha: palette.leafTint.a * easeIn)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _drawLeafCluster(
      canvas,
      paint: leafPaint,
      origin: Offset(-size.width * 0.04, size.height * 0.80 - parallaxY * 0.5),
      scale: math.min(size.width, size.height) / 420.0,
      rotation: 0.40,
    );

    // 3. 4-point editorial diamond sparkle accents
    final starT = Curves.easeOutBack.transform(
      ((progress - 0.35) / 0.4).clamp(0.0, 1.0),
    );
    if (starT > 0.01) {
      final starPaint = Paint()
        ..color = palette.goldAccent.withValues(
          alpha: 0.78 * starT.clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;
      _drawFourPointStar(
        canvas,
        Offset(size.width * 0.84, size.height * 0.19 + parallaxY * 0.6),
        6.0 * starT.clamp(0.0, 1.15),
        starPaint,
      );
      _drawFourPointStar(
        canvas,
        Offset(size.width * 0.78, size.height * 0.23 + parallaxY * 0.6),
        3.5 * starT.clamp(0.0, 1.15),
        starPaint,
      );
    }
  }

  void _drawLeafCluster(
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

    const leaves = [
      (dx: 0.0, dy: 0.0, rot: -0.25, len: 112.0),
      (dx: 28.0, dy: -36.0, rot: 0.18, len: 92.0),
      (dx: -12.0, dy: -66.0, rot: -0.45, len: 74.0),
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
  bool shouldRepaint(covariant _AboutAtmospherePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.scrollOffset != scrollOffset ||
      oldDelegate.palette != palette;
}

/// Subtle translucent corner leaves inside the frosted Atelier card.
class _CardCornerLeavesPainter extends CustomPainter {
  final Color color;

  _CardCornerLeavesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Top-left gentle leaf pair
    canvas.save();
    canvas.translate(-10, 48);
    canvas.rotate(0.65);
    _drawLeaf(canvas, paint, 82);
    canvas.translate(16, -24);
    canvas.rotate(0.32);
    _drawLeaf(canvas, paint, 62);
    canvas.restore();

    // Bottom-right gentle leaf pair
    canvas.save();
    canvas.translate(size.width + 8, size.height - 22);
    canvas.rotate(-2.4);
    _drawLeaf(canvas, paint, 90);
    canvas.translate(14, -24);
    canvas.rotate(0.28);
    _drawLeaf(canvas, paint, 68);
    canvas.restore();
  }

  void _drawLeaf(Canvas canvas, Paint paint, double len) {
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-len * 0.28, -len * 0.45, 0, -len)
      ..quadraticBezierTo(len * 0.28, -len * 0.45, 0, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CardCornerLeavesPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Flowing translucent emerald waves across the Deep Emerald banner card (mirrors Home bottom card).
class _EmeraldWaveRibbonPainter extends CustomPainter {
  final double progress;

  _EmeraldWaveRibbonPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final slide = (1.0 - AppMotion.standard.transform(progress)) * 28.0;

    final ribbon1 = Path()
      ..moveTo(size.width * 0.48 + slide, size.height)
      ..quadraticBezierTo(
        size.width * 0.64,
        size.height * 0.42,
        size.width * 0.96,
        size.height * 0.08,
      )
      ..lineTo(size.width, size.height * 0.16)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.56,
        size.width * 0.72 + slide,
        size.height,
      )
      ..close();

    canvas.drawPath(
      ribbon1,
      Paint()..color = AppColors.sage.withValues(alpha: 0.16),
    );

    final ribbon2 = Path()
      ..moveTo(size.width * 0.62 + slide, size.height)
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.54,
        size.width,
        size.height * 0.34,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      ribbon2,
      Paint()..color = AppColors.sage.withValues(alpha: 0.11),
    );
  }

  @override
  bool shouldRepaint(covariant _EmeraldWaveRibbonPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Compact vector Vistone V-Fan swatch medallion matching the Home Header brand emblem.
class _AboutSwatchFanPainter extends CustomPainter {
  final _AboutStudioPalette palette;
  final double progress;

  _AboutSwatchFanPainter({required this.palette, required this.progress});

  double _interval(double start, double end) {
    final t = ((progress - start) / (end - start)).clamp(0.0, 1.0);
    return Curves.easeOutQuart.transform(t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final pivot = Offset(w * 0.44, h * 0.85);
    final bladeRadius = h * 0.72;

    const double foldedAngle = 0.08;
    final blades = [
      (
        rad: 1.06,
        len: 0.82,
        t: _interval(0.10, 0.56),
        steps: palette.bladeStepPalettes[2],
      ),
      (
        rad: 0.66,
        len: 0.91,
        t: _interval(0.16, 0.64),
        steps: palette.bladeStepPalettes[1],
      ),
      (
        rad: 0.30,
        len: 1.00,
        t: _interval(0.22, 0.72),
        steps: palette.bladeStepPalettes[0],
      ),
    ];

    for (final blade in blades) {
      final angle = foldedAngle + (blade.rad - foldedAngle) * blade.t;
      _drawBlade(
        canvas,
        pivot: pivot,
        angle: angle,
        length: bladeRadius * blade.len,
        colors: blade.steps,
      );
    }

    // Left serif 'V' stem
    final stemPath = Path()
      ..moveTo(w * 0.12, h * 0.16)
      ..quadraticBezierTo(w * 0.10, h * 0.16, w * 0.10, h * 0.18)
      ..quadraticBezierTo(w * 0.10, h * 0.20, w * 0.14, h * 0.205)
      ..lineTo(pivot.dx - w * 0.02, pivot.dy - h * 0.01)
      ..lineTo(pivot.dx + w * 0.02, h * 0.56)
      ..lineTo(w * 0.34, h * 0.26)
      ..quadraticBezierTo(w * 0.33, h * 0.20, w * 0.37, h * 0.18)
      ..close();
    canvas.drawPath(stemPath, Paint()..color = palette.fanStem);

    // Subtle brass rivet at pivot
    canvas.drawCircle(pivot, h * 0.04, Paint()..color = palette.goldAccent);
  }

  void _drawBlade(
    Canvas canvas, {
    required Offset pivot,
    required double angle,
    required double length,
    required List<Color> colors,
  }) {
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(angle);

    final segments = [
      (startRatio: 0.14, endRatio: 0.42, color: colors[0]),
      (startRatio: 0.445, endRatio: 0.71, color: colors[1]),
      (startRatio: 0.735, endRatio: 1.00, color: colors[2]),
    ];
    final maxHalfW = length * 0.135;

    for (final seg in segments) {
      final yBot = -length * seg.startRatio;
      final yTop = -length * seg.endRatio;
      final wBot = maxHalfW * (0.24 + 0.76 * seg.startRatio);
      final wTop = maxHalfW * (0.24 + 0.76 * seg.endRatio);

      final path = Path()
        ..moveTo(-wBot, yBot)
        ..lineTo(wBot, yBot)
        ..lineTo(wTop, yTop)
        ..lineTo(-wTop, yTop)
        ..close();

      canvas.drawPath(path, Paint()..color = seg.color);
      canvas.drawPath(
        path,
        Paint()
          ..color = palette.fanHairline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AboutSwatchFanPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.palette != palette;
}

/// Draws the warm arched gold stroke beneath italic editorial typography.
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

    canvas.drawPath(
      extracted,
      Paint()
        ..color = color.withValues(alpha: 0.90)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.6,
    );
  }

  @override
  bool shouldRepaint(covariant _GoldBrushArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
