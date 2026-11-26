import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analysisProvider);
    final image = ref.watch(selectedImageProvider);
    final stage = state is AnalysisLoading
        ? state.stage
        : 'Initiating neural analysis...';
    final stageIndex = _indexFor(stage);

    ref.listen<AnalysisState>(analysisProvider, (previous, next) {
      if (!mounted) return;
      if (next is AnalysisSuccess) {
        context.go('/result');
      } else if (next is AnalysisError) {
        _showError(next.message);
      }
    });

    return Scaffold(
      body: AppPageBackdrop(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  children: [
                    // Top header
                    Row(
                      children: [
                        AppIconButton(
                          icon: LucideIcons.arrowLeft,
                          semanticLabel: 'Cancel and return home',
                          onTap: () => context.go('/home'),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reading your palette',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Biometric skin tone & undertone engine',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSage,
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            border: Border.all(
                              color: AppColors.sage.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.forest,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.forestDeep,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Main scanning viewport
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _PortraitScannerView(
                                  controller: _scanController,
                                  image: image,
                                )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .scale(
                                  begin: const Offset(0.97, 0.97),
                                  curve: Curves.easeOutCubic,
                                ),
                            const SizedBox(height: 24),

                            // Stage title
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Column(
                                key: ValueKey(stage),
                                children: [
                                  Text(
                                    stage,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Mapping 468 facial landmark coordinates and sampling 10,000+ pixels.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 22),

                            // 4-step progress tracker
                            _ModernStepsTracker(activeIndex: stageIndex),
                            const SizedBox(height: 18),

                            // Privacy assurance
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.nightSurfaceRaised
                                    : AppColors.surfaceSage,
                                borderRadius: BorderRadius.circular(
                                  AppRadii.md,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    LucideIcons.lock,
                                    size: 16,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Offline processing: No biometric data or imagery leaves your device.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(height: 1.35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
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

  int _indexFor(String stage) {
    const stages = [
      'Detecting face landmarks...',
      'Correcting lighting...',
      'Sampling skin pixels...',
      'Classifying skin tone...',
    ];
    final idx = stages.indexOf(stage);
    return idx >= 0 ? idx : 0;
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        title: Row(
          children: [
            const Icon(
              LucideIcons.alertCircle,
              color: AppColors.clay,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Could not complete analysis',
                style: Theme.of(dialogContext).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: Theme.of(dialogContext).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go('/home');
            },
            child: const Text('Try Another Photo'),
          ),
        ],
      ),
    );
  }
}

class _PortraitScannerView extends StatelessWidget {
  final Animation<double> controller;
  final File? image;

  const _PortraitScannerView({required this.controller, required this.image});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.forestDeep,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.hero),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image.file(image!, fit: BoxFit.cover)
              else
                Container(
                  color: AppColors.surfaceSage,
                  child: const Icon(
                    LucideIcons.user,
                    size: 80,
                    color: AppColors.sage,
                  ),
                ),

              // Ambient scan vignette
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.night.withValues(alpha: 0.15),
                      AppColors.night.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),

              // Corner brackets
              const Positioned.fill(child: _ScanBrackets()),

              // Animated sweeping scan bar
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) => Align(
                  alignment: Alignment(0, -1.0 + controller.value * 2.0),
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.marigold,
                          AppColors.clay,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.marigold.withValues(alpha: 0.8),
                          blurRadius: 18,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Live badge
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.night.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(
                      color: AppColors.textInverse.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.marigold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'FACIAL MESH SCANNER',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textInverse,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanBrackets extends StatelessWidget {
  const _ScanBrackets();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: const [
          Align(
            alignment: Alignment.topLeft,
            child: _BracketCorner(rotation: 0),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _BracketCorner(rotation: 1),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _BracketCorner(rotation: 2),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _BracketCorner(rotation: 3),
          ),
        ],
      ),
    );
  }
}

class _BracketCorner extends StatelessWidget {
  final int rotation;

  const _BracketCorner({required this.rotation});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: rotation,
      child: Container(
        height: 24,
        width: 24,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.textInverse, width: 2.2),
            left: BorderSide(color: AppColors.textInverse, width: 2.2),
          ),
        ),
      ),
    );
  }
}

class _ModernStepsTracker extends StatelessWidget {
  final int activeIndex;

  const _ModernStepsTracker({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Face Landmark Mesh', 'Locating forehead, cheeks & chin'),
      ('Lighting Calibration', 'Normalizing ambient color casts'),
      ('Skin Tone Sampling', 'Extracting median CIELAB pixels'),
      ('Monk Palette Synthesis', 'Generating tailored harmony swatches'),
    ];

    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
      borderColor: dark ? AppColors.nightLine : AppColors.line,
      child: Column(
        children: List.generate(steps.length, (index) {
          final done = index < activeIndex;
          final active = index == activeIndex;
          final item = steps[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == steps.length - 1 ? 0 : 14,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.success
                        : active
                        ? AppColors.forest
                        : (dark
                              ? AppColors.nightSurface
                              : AppColors.surfaceMuted),
                    shape: BoxShape.circle,
                  ),
                  child: done
                      ? const Icon(
                          LucideIcons.check,
                          size: 14,
                          color: AppColors.textInverse,
                        )
                      : active
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.8,
                            color: AppColors.textInverse,
                          ),
                        )
                      : Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: active || done
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: active || done ? null : AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        item.$2,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (done)
                  Text(
                    'COMPLETE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  )
                else if (active)
                  Text(
                    'ANALYZING',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
