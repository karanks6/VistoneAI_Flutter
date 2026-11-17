import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import 'upload_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Play entrance once on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final reduceMotion =
            MediaQuery.maybeOf(context)?.disableAnimations ?? false;
        if (reduceMotion) {
          _entranceController.value = 1.0;
        } else {
          _entranceController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _showUploadOptions(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  void _showGuideBottomSheet(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _GuideBottomSheet(),
    );
  }

  void _previewPalette(
    BuildContext context,
    String name,
    String subtitle,
    List<Color> dots,
  ) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _PalettePreviewSheet(name: name, subtitle: subtitle, colors: dots),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedImage = ref.watch(selectedImageProvider);

    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        // 0: Header
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 0,
                          child: _HomeHeader(
                            isDark: isDark,
                            onThemeTap: () =>
                                ref.read(themeProvider.notifier).toggleTheme(),
                            onHelpTap: () => _showGuideBottomSheet(context),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 1: Hero (with model portrait on top right)
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 1,
                          child: const _HomeHero(),
                        ),

                        const SizedBox(height: 24),

                        // 2: Upload Card
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 2,
                          child: _UploadCard(
                            image: selectedImage,
                            onCardTap: () => _showUploadOptions(context),
                            onAnalyseTap: () {
                              if (selectedImage != null) {
                                ref.read(analysisProvider.notifier).reset();
                                context.push('/analyzing');
                                ref
                                    .read(analysisProvider.notifier)
                                    .analyze(selectedImage);
                              } else {
                                _showUploadOptions(context);
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        // 3: Sample Palettes
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 3,
                          child: _SamplePalettesSection(
                            onPaletteTap: (name, sub, dots) =>
                                _previewPalette(context, name, sub, dots),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // 4: Preparation Guide
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 4,
                          child: const _PreparationGuideSection(),
                        ),

                        const SizedBox(height: 24),

                        // 5: Info Card
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 5,
                          child: _InfoCard(
                            onTap: () => _showGuideBottomSheet(context),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // 6: Footer
                        _StaggeredEntrance(
                          controller: _entranceController,
                          index: 6,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E6B4F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'VISTONE AI · ON-DEVICE INFERENCE ENGINE',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                        color: isDark ? AppColors.nightMuted : const Color(0xFF7C8C84),
                                        letterSpacing: 1.4,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAGGERED ENTRANCE HELPER
// ─────────────────────────────────────────────────────────────────────────────
class _StaggeredEntrance extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Widget child;

  const _StaggeredEntrance({
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const totalDurationMs = 700.0;
    const itemDurationMs = 350.0;
    const staggerMs = 50.0;

    final start = (index * staggerMs) / totalDurationMs;
    final end = math.min(1.0, start + (itemDurationMs / totalDurationMs));

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );

    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, staticChild) {
        if (reduceMotion) {
          return Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: staticChild,
          );
        }
        return Opacity(
          opacity: animation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 12.0 * (1.0 - animation.value)),
            child: staticChild,
          ),
        );
      },
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER (FACETED LOGO + VISTONE AI / COLOUR STUDIO, THEME TOGGLE, HELP BUTTON)
// ─────────────────────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeTap;
  final VoidCallback onHelpTap;

  const _HomeHeader({
    required this.isDark,
    required this.onThemeTap,
    required this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand lockup
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/vistone_v_logo_transparent.png',
              width: 32,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VISTONE AI',
                  style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isDark ? AppColors.nightText : const Color(0xFF152922),
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Colour Studio',
                  style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.nightMuted : const Color(0xFF5A6B63),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ],
        ),

        // Right actions (40dp circular touch targets)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIconButton(
              semanticLabel: isDark
                  ? 'Switch to light theme'
                  : 'Switch to dark theme',
              onTap: onThemeTap,
              child: AnimatedSwitcher(
                duration: AppMotion.themeCrossfade,
                child: Icon(
                  isDark ? LucideIcons.sunMedium : LucideIcons.moon,
                  key: ValueKey<bool>(isDark),
                  size: 18,
                  color: isDark ? AppColors.marigold : const Color(0xFF152922),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _CircleIconButton(
              semanticLabel: 'How Vistone sees colour guide',
              onTap: onHelpTap,
              child: Icon(
                LucideIcons.helpCircle,
                size: 18,
                color: isDark ? AppColors.nightText : const Color(0xFF152922),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String semanticLabel;

  const _CircleIconButton({
    required this.child,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedScale(
          duration: AppMotion.micro,
          scale: _pressed ? 0.94 : 1.0,
          curve: Curves.easeOutCubic,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.nightSurface : Colors.white.withValues(alpha: 0.85),
              border: Border.all(
                color: isDark ? AppColors.nightLine : const Color(0xFFDFE6E1),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO SECTION (MODEL PORTRAIT PINNED TOP-RIGHT, LEFT-ALIGNED EDITORIAL TEXT)
// ─────────────────────────────────────────────────────────────────────────────
class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final imageWidth = (screenWidth * 0.52).clamp(170.0, 230.0);
        final textMaxWidth = screenWidth - (imageWidth * 0.72);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Top right hero model illustration
            if (!isDark)
              Positioned(
                top: -36,
                right: -20,
                width: imageWidth,
                child: IgnorePointer(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        'assets/images/hero_portrait_final.png',
                        fit: BoxFit.contain,
                      ),
                      // Golden 4-point sparkle stars
                      const Positioned(
                        top: 40,
                        left: -8,
                        child: _GoldenSparkle(size: 15),
                      ),
                      const Positioned(
                        top: 75,
                        right: 8,
                        child: _GoldenSparkle(size: 11),
                      ),
                    ],
                  ),
                ),
              ),

            // Left content column
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: textMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Eyebrow badge with green dot
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.nightSurfaceRaised : const Color(0xFFE5EFE7),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: isDark ? AppColors.nightLine : const Color(0xFFD6E5D9),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E6B4F),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'PERSONAL COLOUR ANALYSIS',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                                  color: isDark ? AppColors.sage : const Color(0xFF2E6B4F),
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Headline: Playfair Display serif
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 37,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: -0.5,
                        color: isDark ? AppColors.nightText : const Color(0xFF162D24),
                      ),
                      children: [
                        const TextSpan(text: 'Dress in your\n'),
                        TextSpan(
                          text: 'best light.',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 37,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            height: 1.1,
                            letterSpacing: -0.5,
                            color: isDark ? const Color(0xFF8DCFB8) : const Color(0xFF1E5844),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Subtitle
                  Text(
                    'A thoughtful read of your natural complexion, unlocking curated shades made to bring you forward.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.nightMuted : const Color(0xFF53635B),
                          height: 1.45,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UPLOAD CARD (WHITE CARD, CAMERA SCAN BADGE, FOREST CTA BUTTON)
// ─────────────────────────────────────────────────────────────────────────────
class _UploadCard extends StatefulWidget {
  final File? image;
  final VoidCallback onCardTap;
  final VoidCallback onAnalyseTap;

  const _UploadCard({
    required this.image,
    required this.onCardTap,
    required this.onAnalyseTap,
  });

  @override
  State<_UploadCard> createState() => _UploadCardState();
}

class _UploadCardState extends State<_UploadCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasImage = widget.image != null;

    return Semantics(
      button: true,
      label: hasImage
          ? 'Analyse selected selfie'
          : 'Choose a photo for color analysis',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (hasImage) {
            widget.onAnalyseTap();
          } else {
            widget.onCardTap();
          }
        },
        child: AnimatedScale(
          duration: AppMotion.micro,
          scale: _pressed ? 0.985 : 1.0,
          curve: Curves.easeOutCubic,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightSurface : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? AppColors.nightLine : const Color(0xFFEEF2ED),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.28)
                      : const Color(0xFF133E32).withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon / Image Thumbnail with smooth transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: hasImage
                      ? Container(
                          key: const ValueKey('has_image'),
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF133E32), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF133E32).withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.file(widget.image!, fit: BoxFit.cover),
                          ),
                        )
                      : const _ScanCameraBadge(size: 64),
                ),

                const SizedBox(height: 18),

                // Title
                Text(
                  hasImage
                      ? 'Selfie ready for analysis'
                      : 'Start with a simple selfie',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.5,
                        color: isDark ? AppColors.nightText : const Color(0xFF122D24),
                      ),
                ),

                const SizedBox(height: 6),

                // Subtitle
                Text(
                  hasImage
                      ? 'Tap analyse to evaluate skin tone and undertone harmony.'
                      : 'Natural light and your lovely, unedited face are all you need for an accurate reading.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.nightMuted : const Color(0xFF607068),
                        fontSize: 13,
                        height: 1.4,
                      ),
                ),

                const SizedBox(height: 20),

                // Full-width forest CTA button with camera left and chevron right
                SizedBox(
                  width: double.infinity,
                  child: AppPrimaryButton(
                    label: hasImage ? 'Analyse my palette' : 'Choose a photo',
                    icon: hasImage ? LucideIcons.sparkles : LucideIcons.camera,
                    trailingIcon: LucideIcons.chevronRight,
                    backgroundColor: const Color(0xFF133E32),
                    onPressed: hasImage
                        ? widget.onAnalyseTap
                        : widget.onCardTap,
                  ),
                ),

                const SizedBox(height: 14),

                // Shield reassurance
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.lock,
                      size: 13,
                      color: isDark ? AppColors.nightMuted : const Color(0xFF708078),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Processed privately on this device',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                              color: isDark ? AppColors.nightMuted : const Color(0xFF708078),
                              letterSpacing: 0.2,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAMPLE PALETTES SECTION (FABRIC THUMBNAILS, COLOR SWATCH DOTS)
// ─────────────────────────────────────────────────────────────────────────────
class _SamplePalettesSection extends StatelessWidget {
  final void Function(String name, String sub, List<Color> dots) onPaletteTap;

  const _SamplePalettesSection({required this.onPaletteTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const autumnDots = [
      Color(0xFFD45D3B), // Terracotta
      Color(0xFF53663C), // Olive
      Color(0xFFD89E3F), // Ochre
    ];

    const winterDots = [
      Color(0xFF7D2644), // Deep Berry
      Color(0xFF1B5E50), // Emerald
      Color(0xFF123631), // Deep Navy
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ColorWheelIcon(
                    size: 16,
                    color: isDark ? AppColors.nightText : const Color(0xFF162E25),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'SAMPLE PALETTES',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark ? AppColors.nightText : const Color(0xFF162E25),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onPaletteTap('Warm Autumn', 'Terracotta & Olive', autumnDots),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '36 Harmonies',
                    style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark ? AppColors.nightMuted : const Color(0xFF5A6B63),
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    LucideIcons.arrowRight,
                    size: 13,
                    color: isDark ? AppColors.nightMuted : const Color(0xFF5A6B63),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Two cards side by side
        Row(
          children: [
            Expanded(
              child: _SamplePaletteCard(
                name: 'Warm Autumn',
                subtitle: 'Terracotta & Olive',
                imagePath: 'assets/images/warm_autumn_thumb.png',
                dots: autumnDots,
                onTap: () => onPaletteTap(
                  'Warm Autumn',
                  'Terracotta & Olive',
                  autumnDots,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SamplePaletteCard(
                name: 'Cool Winter',
                subtitle: 'Berry & Emerald',
                imagePath: 'assets/images/cool_winter_thumb.png',
                dots: winterDots,
                onTap: () =>
                    onPaletteTap('Cool Winter', 'Berry & Emerald', winterDots),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SamplePaletteCard extends StatefulWidget {
  final String name;
  final String subtitle;
  final String imagePath;
  final List<Color> dots;
  final VoidCallback onTap;

  const _SamplePaletteCard({
    required this.name,
    required this.subtitle,
    required this.imagePath,
    required this.dots,
    required this.onTap,
  });

  @override
  State<_SamplePaletteCard> createState() => _SamplePaletteCardState();
}

class _SamplePaletteCardState extends State<_SamplePaletteCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '${widget.name} palette preview',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          duration: AppMotion.micro,
          scale: _pressed ? 0.98 : 1.0,
          curve: Curves.easeOutCubic,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.nightSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.nightLine : const Color(0xFFEEF2ED),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withValues(alpha: 0.15) : const Color(0x08000000),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.imagePath,
                    width: 44,
                    height: 38,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.nightText : const Color(0xFF162E25),
                            ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: isDark ? AppColors.nightMuted : const Color(0xFF72827A),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.dots
                      .map(
                        (color) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PREPARATION GUIDE SECTION (GOLDEN UNDERLINE, 3 STEP CARDS WITH CHEVRONS)
// ─────────────────────────────────────────────────────────────────────────────
class _PreparationGuideSection extends StatelessWidget {
  const _PreparationGuideSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const steps = [
      (
        LucideIcons.sunMedium,
        'Find gentle daylight',
        'Face a window with soft, natural morning or afternoon light. Avoid harsh overhead bulbs.',
      ),
      (
        LucideIcons.scanFace,
        'Keep your face clear',
        'Remove hats or heavy accessories and look directly into the camera with an even expression.',
      ),
      (
        LucideIcons.wand2,
        'Skip beauty filters',
        'Use an unedited, natural photo so the skin pixel sampler measures your genuine undertone.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.lightbulb,
              size: 16,
              color: isDark ? AppColors.nightText : const Color(0xFF162E25),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'PREPARATION GUIDE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.nightText : const Color(0xFF162E25),
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Title with curved golden underline arc
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A clear selfie makes an',
              style: GoogleFonts.playfairDisplay(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.15,
                color: isDark ? AppColors.nightText : const Color(0xFF162D24),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'accurate palette.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
                    color: isDark ? AppColors.nightText : const Color(0xFF162D24),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 105,
                  height: 10,
                  child: CustomPaint(
                    painter: _GoldenUnderlinePainter(
                      color: const Color(0xFFDFAB56),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 18),

        // 3 Cards with right chevron
        Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.nightSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.nightLine : const Color(0xFFEEF2ED),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withValues(alpha: 0.15) : const Color(0x08000000),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.nightSurfaceRaised : const Color(0xFFE6F0E7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.$1,
                        size: 20,
                        color: isDark ? AppColors.sage : const Color(0xFF1A382E),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.$2,
                            style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDark ? AppColors.nightText : const Color(0xFF162D24),
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            step.$3,
                            style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark ? AppColors.nightMuted : const Color(0xFF66756D),
                                  height: 1.35,
                                  fontSize: 11.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: isDark ? AppColors.nightMuted : const Color(0xFF8E9E96),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO CARD (FOREST GREEN, SILK TEXTURE OVERLAY, GOLDEN BOOK ICON)
// ─────────────────────────────────────────────────────────────────────────────
class _InfoCard extends StatefulWidget {
  final VoidCallback onTap;

  const _InfoCard({required this.onTap});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Read how Vistone sees colour',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          duration: AppMotion.micro,
          scale: _pressed ? 0.98 : 1.0,
          curve: Curves.easeOutCubic,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF103B2F),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF103B2F).withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Silk fabric texture overlay on the right
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        'assets/images/info_card_silk_clean.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Foreground content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0x24ECCB7E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x38ECCB7E),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.bookOpen,
                          color: Color(0xFFECCB7E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How Vistone sees colour',
                              style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'A guide to Monk Scale AI, undertone math & styling.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFFA5C4B4),
                                    fontSize: 11.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.chevronRight,
                            color: Colors.white,
                            size: 19,
                          ),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GUIDE BOTTOM SHEET WITH DRAG HANDLE
// ─────────────────────────────────────────────────────────────────────────────
class _GuideBottomSheet extends StatelessWidget {
  const _GuideBottomSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.nightLine : AppColors.line,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.nightLine : AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.forest.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.bookOpen,
                      size: 18,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'How Vistone Sees Colour',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.nightText : AppColors.ink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                'Personal colour is grounded in biological light reflectance. Rather than rigid seasonal rules, Vistone calculates your skin tone using three objective metrics:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.nightMuted
                      : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 16),

              const _GuidePoint(
                number: '01',
                title: 'Harvard Monk Skin Tone Scale (MST 1–10)',
                description:
                    'An inclusive 10-tier skin spectrum that supersedes legacy 6-tone Fitzpatrick charts.',
              ),
              const SizedBox(height: 10),
              const _GuidePoint(
                number: '02',
                title: 'CIELAB Undertone Sampling',
                description:
                    'We isolate skin pixels across cheeks and forehead, filtering out highlights and shadows.',
              ),
              const SizedBox(height: 10),
              const _GuidePoint(
                number: '03',
                title: '100% On-Device Neural Processing',
                description:
                    'Your photo is analyzed entirely in memory and never stored or uploaded anywhere.',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'Explore full methodology',
                  icon: LucideIcons.arrowRight,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/about');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidePoint extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuidePoint({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.clay,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.nightMuted
                      : AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PALETTE PREVIEW BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _PalettePreviewSheet extends StatelessWidget {
  final String name;
  final String subtitle;
  final List<Color> colors;

  const _PalettePreviewSheet({
    required this.name,
    required this.subtitle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightSurface : AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.sheet),
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.nightLine : AppColors.line,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 42,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.nightLine : AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.nightText : AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$subtitle Harmony',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.nightMuted
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: colors
                    .map(
                      (c) => Expanded(
                        child: Container(
                          height: 72,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.nightLine
                                  : AppColors.line,
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: c.computeLuminance() > 0.45
                                      ? AppColors.ink
                                      : AppColors.textInverse,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'This palette balances undertone warmth with medium contrast to illuminate your natural eye and hair shades.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.nightMuted
                      : AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'Done',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM PAINTERS & GRAPHIC ELEMENTS
// ─────────────────────────────────────────────────────────────────────────────
class _GoldenUnderlinePainter extends CustomPainter {
  final Color color;

  const _GoldenUnderlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.1,
      size.width,
      size.height * 0.2,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GoldenUnderlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ScanCameraBadge extends StatelessWidget {
  final double size;

  const _ScanCameraBadge({this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE2EFE4),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCCE0D0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1224564D),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CustomPaint(
            painter: const _CornerBracketPainter(color: Color(0xFF133E32)),
            child: const Center(
              child: Icon(
                LucideIcons.camera,
                size: 18,
                color: Color(0xFF133E32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;

  const _CornerBracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    const arm = 6.0;

    // Top-left
    canvas.drawLine(const Offset(0, arm), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(arm, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - arm, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, arm), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - arm), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(arm, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - arm, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - arm), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) => oldDelegate.color != color;
}

class _GoldenSparkle extends StatelessWidget {
  final double size;

  const _GoldenSparkle({this.size = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CustomPaint(
        painter: _FourPointStarPainter(color: Color(0xFFDFAC57)),
      ),
    );
  }
}

class _FourPointStarPainter extends CustomPainter {
  final Color color;

  const _FourPointStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path();
    path.moveTo(cx, 0);
    path.quadraticBezierTo(cx, cy, size.width, cy);
    path.quadraticBezierTo(cx, cy, cx, size.height);
    path.quadraticBezierTo(cx, cy, 0, cy);
    path.quadraticBezierTo(cx, cy, cx, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FourPointStarPainter oldDelegate) => oldDelegate.color != color;
}

class _ColorWheelIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _ColorWheelIcon({
    this.size = 17,
    this.color = const Color(0xFF162E25),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ColorWheelPainter(color: color),
      ),
    );
  }
}

class _ColorWheelPainter extends CustomPainter {
  final Color color;

  const _ColorWheelPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer circle
    canvas.drawCircle(Offset(cx, cy), r - 1, paint);

    // 5 radial notches
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * math.pi / 5) - math.pi / 2;
      final px = cx + (r * 0.45) * math.cos(angle);
      final py = cy + (r * 0.45) * math.sin(angle);
      canvas.drawCircle(Offset(px, py), 1.3, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ColorWheelPainter oldDelegate) => oldDelegate.color != color;
}
