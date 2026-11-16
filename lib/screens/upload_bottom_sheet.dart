import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class UploadBottomSheet extends ConsumerWidget {
  const UploadBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    HapticFeedback.lightImpact();
    try {
      final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 95);
      if (pickedFile == null || !context.mounted) return;

      context.pop();
      final image = File(pickedFile.path);
      ref.read(selectedImageProvider.notifier).state = image;
      ref.read(analysisProvider.notifier).reset();
      context.push('/analyzing');
      ref.read(analysisProvider.notifier).analyze(image);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.nightSurfaceRaised : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
        border: Border(
          top: BorderSide(
            color: dark ? AppColors.nightLine : AppColors.line,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.5 : 0.12),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grab handle
              Center(
                child: Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: dark ? AppColors.nightLine : AppColors.lineStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Let’s see your\nnatural colouring.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      height: 1.15,
                    ),
              ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.08),

              const SizedBox(height: 8),

              Text(
                'Choose a clear, filter-free selfie. Our on-device neural network analyzes skin pixels to identify your Monk tone.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dark ? AppColors.nightMuted : AppColors.textSecondary,
                    ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 24),

              // Option 1: Camera
              _SourceOptionCard(
                icon: LucideIcons.camera,
                iconBg: AppColors.surfaceClay,
                iconColor: AppColors.clay,
                title: 'Take a photo',
                detail: 'Open camera with natural, soft front light',
                onTap: () => _pickImage(context, ref, ImageSource.camera),
              ).animate().fadeIn(delay: 160.ms).slideX(begin: 0.04),

              const SizedBox(height: 12),

              // Option 2: Gallery
              _SourceOptionCard(
                icon: LucideIcons.image,
                iconBg: AppColors.surfaceSage,
                iconColor: AppColors.forest,
                title: 'Choose from library',
                detail: 'Select a recent, unedited portrait',
                onTap: () => _pickImage(context, ref, ImageSource.gallery),
              ).animate().fadeIn(delay: 220.ms).slideX(begin: 0.04),

              const SizedBox(height: 24),

              // Privacy assurance strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: dark ? AppColors.nightSurface : AppColors.canvas,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  border: Border.all(
                    color: dark ? AppColors.nightLine : AppColors.line,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.shieldCheck,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '100% on-device privacy. Your image is never stored, tracked, or sent to a server.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              height: 1.35,
                            ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 280.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String detail;
  final VoidCallback onTap;

  const _SourceOptionCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      backgroundColor: dark ? AppColors.nightSurface : AppColors.surface,
      borderColor: dark ? AppColors.nightLine : AppColors.line,
      child: Row(
        children: [
          IconContainer(
            icon: icon,
            backgroundColor: iconBg,
            iconColor: iconColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.arrowUpRight,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
