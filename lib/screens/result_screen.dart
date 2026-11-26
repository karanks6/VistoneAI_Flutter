import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/color_swatch_card.dart';
import '../widgets/design_system.dart';
import '../widgets/monk_scale_slider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisProvider);
    final image = ref.watch(selectedImageProvider);
    if (state is! AnalysisSuccess) {
      return const _ResultLoading();
    }
    final result = state.result;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _ResultHeader(
                          onBack: () => context.go('/home'),
                          onShare: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Palette summary: Monk Tone ${result.tone} (${result.undertone}) · ${result.bestColors.length} signature shades ready.',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _ResultMasterCard(
                              image: image,
                              tone: result.tone,
                              undertone: result.undertone,
                              monkColors: result.monkColors,
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                        const SizedBox(height: AppSpacing.lg),
                        _MetricsRow(
                          toneConfidence: result.toneConfidence,
                          undertoneConfidence: result.utConfidence,
                        ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05),
                        const SizedBox(height: AppSpacing.lg),
                        MonkScaleSlider(
                          monkColors: result.monkColors,
                          detectedTone: result.tone,
                        ).animate().fadeIn(delay: 220.ms).slideY(begin: 0.05),
                        const SizedBox(height: AppSpacing.section),
                        _UndertoneAdvisory(
                          undertone: result.undertone,
                        ).animate().fadeIn(delay: 280.ms),
                        const SizedBox(height: AppSpacing.section),
                        _SwatchesGroup(
                          title: 'Shades to Reach For',
                          subtitle:
                              'Wear near your face to brighten your natural complexion.',
                          label: 'SIGNATURE HARMONIES',
                          icon: LucideIcons.sparkles,
                          swatches: result.bestColors,
                          undertone: result.undertone,
                          isAvoid: false,
                        ),
                        const SizedBox(height: AppSpacing.section),
                        _SwatchesGroup(
                          title: 'Shades to Pause On',
                          subtitle:
                              'Can compete with your undertone. Wear as trousers or accessories instead.',
                          label: 'STYLE AWAY FROM FACE',
                          icon: LucideIcons.minusCircle,
                          swatches: result.avoidColors,
                          undertone: result.undertone,
                          isAvoid: true,
                        ),
                        const SizedBox(height: AppSpacing.section),
                        SizedBox(
                          width: double.infinity,
                          child: AppPrimaryButton(
                            label: 'Analyse another photo',
                            icon: LucideIcons.refreshCw,
                            onPressed: () {
                              ref.read(analysisProvider.notifier).reset();
                              context.go('/home');
                            },
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            'Your personal colouring is unique. Use this palette as your creative playground.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: dark
                                      ? AppColors.nightMuted
                                      : AppColors.textTertiary,
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

class _ResultLoading extends StatelessWidget {
  const _ResultLoading();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppPageBackdrop(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Preparing your color profile...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

class _ResultHeader extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onShare;

  const _ResultHeader({required this.onBack, required this.onShare});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      AppIconButton(
        icon: LucideIcons.arrowLeft,
        semanticLabel: 'Return home',
        onTap: onBack,
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR COLOUR PROFILE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Monk Skin Tone Calibration',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),
      AppIconButton(
        icon: LucideIcons.share2,
        semanticLabel: 'Share palette summary',
        onTap: onShare,
      ),
    ],
  );
}

class _ResultMasterCard extends StatelessWidget {
  final File? image;
  final int tone;
  final String undertone;
  final List<String> monkColors;

  const _ResultMasterCard({
    required this.image,
    required this.tone,
    required this.undertone,
    required this.monkColors,
  });

  Color _toneColor() {
    if (tone >= 1 && tone <= monkColors.length) {
      final hex = monkColors[tone - 1].replaceAll('#', '').padLeft(6, '0');
      return Color(int.parse('FF$hex', radix: 16));
    }
    return AppColors.marigold;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final toneColor = _toneColor();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: BorderRadius.circular(AppRadii.hero),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selfie crop with high-fashion gradient
          SizedBox(
            height: (screenHeight * 0.28).clamp(210.0, 320.0),
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null)
                  Image.file(image!, fit: BoxFit.cover)
                else
                  const ColoredBox(color: AppColors.sage),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.forestDeep.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.night.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: AppColors.textInverse.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.badgeCheck,
                          size: 14,
                          color: AppColors.marigold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ANALYSIS VERIFIED',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.textInverse,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Natural Palette',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: AppColors.textInverse,
                              fontSize: 28,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tone & undertone spotlight
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Tone chip
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: toneColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.textInverse.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: toneColor.withValues(alpha: 0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MST',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.night,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '$tone'.padLeft(2, '0'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.night,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '$undertone Undertone',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.textInverse,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            LucideIcons.sparkle,
                            size: 16,
                            color: AppColors.marigold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Harmonized with your biological light reflection and depth.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.nightMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final double toneConfidence;
  final double undertoneConfidence;

  const _MetricsRow({
    required this.toneConfidence,
    required this.undertoneConfidence,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
      borderColor: dark ? AppColors.nightLine : AppColors.line,
      child: Row(
        children: [
          _MetricItem(
            label: 'TONE ACCURACY',
            value: '${(toneConfidence.clamp(0, 1) * 100).round()}%',
            sub: 'Monk Scale Match',
          ),
          Container(
            width: 1,
            height: 40,
            color: dark ? AppColors.nightLine : AppColors.line,
          ),
          _MetricItem(
            label: 'UNDERTONE PURITY',
            value: '${(undertoneConfidence.clamp(0, 1) * 100).round()}%',
            sub: 'Melanin Hue Balance',
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          Text(
            sub,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _UndertoneAdvisory extends StatelessWidget {
  final String undertone;

  const _UndertoneAdvisory({required this.undertone});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: isDark
          ? AppColors.nightSurfaceRaised
          : AppColors.surfaceSage,
      borderColor: isDark
          ? AppColors.nightLine
          : AppColors.sage.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconContainer(
            icon: LucideIcons.palette,
            backgroundColor: isDark ? AppColors.nightLine : AppColors.forest,
            iconColor: isDark ? AppColors.sage : AppColors.textInverse,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What this means for styling',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your $undertone undertone harmonizes best with shades having similar color temperature. Tap any color swatch to enter the virtual draping studio.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwatchesGroup extends StatelessWidget {
  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final List swatches;
  final String undertone;
  final bool isAvoid;

  const _SwatchesGroup({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.icon,
    required this.swatches,
    required this.undertone,
    required this.isAvoid,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isAvoid
        ? AppColors.clay
        : Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: accentColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: accentColor,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 196,
          child: ListView.separated(
            padding: const EdgeInsets.only(right: 6),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: swatches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final swatch = swatches[index];
              return ColorSwatchCard(
                    swatch: swatch,
                    isAvoid: isAvoid,
                    onTap: () => context.push(
                      '/color-preview',
                      extra: {
                        'swatch': swatch,
                        'isAvoid': isAvoid,
                        'undertone': undertone,
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 60 * index))
                  .slideX(begin: 0.08);
            },
          ),
        ),
      ],
    );
  }
}
