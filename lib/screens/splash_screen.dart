import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/design_system.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(milliseconds: 2800), _proceed);
  }

  void _proceed() {
    if (!mounted) return;
    _navigationTimer?.cancel();
    context.go('/home');
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageBackdrop(
        dark: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top brand bar with Skip action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.textInverse,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.clay.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon/vistone_logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'VISTONE AI',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.textInverse,
                                letterSpacing: 2.4,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _proceed();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.textInverse.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          border: Border.all(
                            color: AppColors.textInverse.withValues(alpha: 0.18),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SKIP',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textInverse,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              LucideIcons.arrowRight,
                              size: 13,
                              color: AppColors.textInverse,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

                const Spacer(flex: 2),

                // Centerpiece: Glowing organic palette halo
                Center(
                  child: const _LuxePaletteCenterpiece()
                      .animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.88, 0.88),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),

                const Spacer(flex: 2),

                // Editorial typography reveal
                Text(
                  'Find the shades\nthat feel like you.',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textInverse,
                        fontSize: 44,
                        height: 1.08,
                      ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 650.ms)
                    .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'AI-powered personal colour analysis grounded in inclusive skin science.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.nightMuted,
                        height: 1.45,
                      ),
                ).animate().fadeIn(delay: 500.ms, duration: 550.ms),

                const Spacer(),

                // Animated progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.nightLine,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.sage, AppColors.marigold, AppColors.clay],
                            ),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        )
                            .animate()
                            .scaleX(
                              begin: 0,
                              end: 1,
                              alignment: Alignment.centerLeft,
                              delay: 200.ms,
                              duration: 2500.ms,
                              curve: Curves.easeInOutCubic,
                            ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'YOUR PERSONAL STUDIO',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.nightMuted,
                                letterSpacing: 1.5,
                              ),
                        ),
                        Text(
                          'MONK SCALE ML',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.sage,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LuxePaletteCenterpiece extends StatelessWidget {
  const _LuxePaletteCenterpiece();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle pulse ring
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textInverse.withValues(alpha: 0.1),
                width: 1.2,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.96, 0.96),
                end: const Offset(1.06, 1.06),
                duration: 2600.ms,
                curve: Curves.easeInOutSine,
              ),

          // Glowing chromatic aura
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  AppColors.clay,
                  AppColors.marigold,
                  AppColors.sage,
                  AppColors.lilac,
                  AppColors.clay,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.clay.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: AppColors.sage.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 8000.ms),

          // Frosted white glass inner lens
          Container(
            width: 146,
            height: 146,
            decoration: BoxDecoration(
              color: AppColors.textInverse,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textInverse.withValues(alpha: 0.9),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.night.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/icon/vistone_logo.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
