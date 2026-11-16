import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../widgets/design_system.dart';
import 'upload_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                        _HomeTopBar(
                          dark: dark,
                          onThemeTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                          onGuideTap: () => context.push('/about'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _HomeHero(theme: theme),
                        const SizedBox(height: AppSpacing.xxl),
                        _StudioScannerCard(onTap: () => _showUploadOptions(context))
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 500.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                        const SizedBox(height: AppSpacing.section),
                        _SamplePaletteStrip(
                          onSampleTap: (name) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Tip: Take your selfie to unlock your personalized $name match.'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.section),
                        const _SectionHeader(
                          eyebrow: 'PREPARATION GUIDE',
                          title: 'A clear selfie makes an\naccurate palette.',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const _PreparationCards(),
                        const SizedBox(height: AppSpacing.section),
                        _MethodGuideBanner(onTap: () => context.push('/about')),
                        const SizedBox(height: AppSpacing.xxl),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'VISTONE AI · ON-DEVICE INFERENCE ENGINE',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
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

class _HomeTopBar extends StatelessWidget {
  final bool dark;
  final VoidCallback onThemeTap;
  final VoidCallback onGuideTap;

  const _HomeTopBar({
    required this.dark,
    required this.onThemeTap,
    required this.onGuideTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Brand logo & title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textInverse,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.clay.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: dark ? AppColors.nightLine : AppColors.line,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icon/vistone_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VISTONE AI',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  'Colour Studio',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                        height: 1.2,
                      ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        // Actions
        AppIconButton(
          icon: dark ? LucideIcons.sun : LucideIcons.moon,
          semanticLabel: dark ? 'Switch to light theme' : 'Switch to dark theme',
          onTap: onThemeTap,
        ),
        const SizedBox(width: 8),
        AppIconButton(
          icon: LucideIcons.helpCircle,
          semanticLabel: 'Learn about Vistone method',
          onTap: onGuideTap,
        ),
      ],
    ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.06, end: 0);
  }
}

class _HomeHero extends StatelessWidget {
  final ThemeData theme;

  const _HomeHero({required this.theme});

  @override
  Widget build(BuildContext context) {
    final dark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: dark ? AppColors.nightSurfaceRaised : AppColors.surfaceSage,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            border: Border.all(
              color: dark ? AppColors.nightLine : AppColors.sage.withValues(alpha: 0.5),
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
                  color: AppColors.clay,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'PERSONAL COLOUR ANALYSIS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: dark ? AppColors.sage : AppColors.forest,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 14),
        Text(
          'Dress in your\nbest light.',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 44,
            height: 1.05,
          ),
        ).animate().fadeIn(delay: 120.ms, duration: 550.ms).slideY(begin: 0.1),
        const SizedBox(height: AppSpacing.md),
        Text(
          'A thoughtful read of your natural complexion, unlocking curated shades made to bring you forward.',
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 240.ms, duration: 450.ms),
      ],
    );
  }
}

class _StudioScannerCard extends StatelessWidget {
  final VoidCallback onTap;

  const _StudioScannerCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
      borderColor: dark ? AppColors.nightLine : AppColors.line,
      boxShadow: [
        BoxShadow(
          color: dark ? Colors.black.withValues(alpha: 0.4) : AppColors.forest.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        children: [
          // Centered glowing scanner icon
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.clay.withValues(alpha: 0.12),
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1.08, 1.08),
                    duration: 1800.ms,
                  ),
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceClay,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.scanFace,
                  color: AppColors.clay,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Start with a simple selfie',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Natural light and your lovely, unedited face are all you need for an accurate reading.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? AppColors.nightMuted : AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              label: 'Choose a photo',
              icon: LucideIcons.camera,
              onPressed: onTap,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                size: 14,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                'PROCESSED PRIVATELY ON THIS DEVICE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 1.1,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SamplePaletteStrip extends StatelessWidget {
  final ValueChanged<String> onSampleTap;

  const _SamplePaletteStrip({required this.onSampleTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final samples = [
      (
        'Warm Autumn',
        'Terracotta & Olive',
        [AppColors.clay, const Color(0xFF5B6943), AppColors.marigold],
      ),
      (
        'Cool Winter',
        'Berry & Emerald',
        [const Color(0xFF1E4D43), const Color(0xFF7F284D), AppColors.lilac],
      ),
      (
        'Soft Summer',
        'Sage & Rose',
        [AppColors.sage, const Color(0xFFD3A29D), const Color(0xFF8CA5B8)],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SAMPLE PALETTES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.4,
                  ),
            ),
            Text(
              '36 HARMONIES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: samples.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final sample = samples[index];
              return AppCard(
                onTap: () => onSampleTap(sample.$1),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                radius: AppRadii.md,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sample.$1,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sample.$2,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Row(
                      children: sample.$3
                          .map(
                            (c) => Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.textInverse.withValues(alpha: 0.6),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;

  const _SectionHeader({required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                height: 1.15,
              ),
        ),
      ],
    );
  }
}

class _PreparationCards extends StatelessWidget {
  const _PreparationCards();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const tips = [
      (
        LucideIcons.sunMedium,
        'Find gentle daylight',
        'Face a window with soft, natural morning or afternoon light. Avoid harsh overhead bulbs.',
      ),
      (
        LucideIcons.focus,
        'Keep your face clear',
        'Remove hats or heavy accessories and look directly into the camera with an even expression.',
      ),
      (
        LucideIcons.sparkle,
        'Skip beauty filters',
        'Use an unedited, natural photo so the skin pixel sampler measures your genuine undertone.',
      ),
    ];

    return Column(
      children: List.generate(tips.length, (index) {
        final tip = tips[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == tips.length - 1 ? 0 : 12),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconContainer(
                  icon: tip.$1,
                  backgroundColor: isDark ? AppColors.nightSurfaceRaised : AppColors.surfaceSage,
                  iconColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.$2,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.$3,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '0${index + 1}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 300 + (index * 80))).slideX(begin: 0.04);
      }),
    );
  }
}

class _MethodGuideBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _MethodGuideBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.forestDeep,
      borderColor: AppColors.forest,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.textInverse.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.bookOpen,
              color: AppColors.marigold,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How Vistone sees colour',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  'A guide to Monk Scale AI, undertone math & styling.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.nightMuted,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            LucideIcons.arrowUpRight,
            color: AppColors.textInverse,
            size: 22,
          ),
        ],
      ),
    );
  }
}
