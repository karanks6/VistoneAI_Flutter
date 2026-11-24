import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/design_system.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        Row(
                          children: [
                            AppIconButton(
                              icon: LucideIcons.arrowLeft,
                              semanticLabel: 'Return home',
                              onTap: () => context.pop(),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              'THE VISTONE METHOD',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    letterSpacing: 1.4,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 300.ms),
                        const SizedBox(height: 24),
                        const _GuideHero().animate().fadeIn(duration: 450.ms).slideY(begin: 0.08),
                        const SizedBox(height: AppSpacing.section),
                        Text(
                          'Personal colour,\nwithout the rules.',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                height: 1.12,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vistone was engineered to bridge computational color science and daily self-expression. We calibrate your unique skin reflectance and undertone to suggest colors that harmonize naturally with your complexion.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.section),
                        const _MethodList(),
                        const SizedBox(height: AppSpacing.section),
                        const _PrivacyTechnologyCard(),
                        const SizedBox(height: AppSpacing.md),
                        const _DeveloperCard(),
                        const SizedBox(height: AppSpacing.section),
                        SizedBox(
                          width: double.infinity,
                          child: AppPrimaryButton(
                            label: 'Find my palette',
                            icon: LucideIcons.camera,
                            onPressed: () => context.go('/home'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            'Engineered to celebrate every skin tone with equity and elegance.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textTertiary,
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

class _GuideHero extends StatelessWidget {
  const _GuideHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.forestDeep,
        borderRadius: BorderRadius.circular(AppRadii.hero),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -50,
            child: _HeroDisc(size: 190, color: AppColors.marigold.withValues(alpha: 0.85)),
          ),
          Positioned(
            left: -50,
            bottom: -60,
            child: _HeroDisc(size: 180, color: AppColors.clay.withValues(alpha: 0.8)),
          ),
          Positioned(
            right: 50,
            bottom: 20,
            child: _HeroDisc(size: 80, color: AppColors.sage.withValues(alpha: 0.9)),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.textInverse.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: AppColors.textInverse.withValues(alpha: 0.2)),
              ),
              child: Text(
                'COLOUR SCIENCE & INCLUSIVITY',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textInverse,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const VistoneMark(size: 52, inverted: true),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Colour,\nConsidered.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.textInverse,
                          fontSize: 28,
                          height: 1.05,
                        ),
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

class _HeroDisc extends StatelessWidget {
  final double size;
  final Color color;

  const _HeroDisc({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

class _MethodList extends StatelessWidget {
  const _MethodList();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    const entries = [
      (
        LucideIcons.scanFace,
        'Harvard Monk Scale (MST)',
        'Developed by Dr. Ellis Monk to overcome limitations in legacy dermatology scales, categorizing human skin into 10 nuanced, equitable shades.',
      ),
      (
        LucideIcons.layers,
        'Biometric Pixel Sampling',
        'We sample median skin pixels across forehead, cheek, and chin zones using Google ML Kit, discarding specular highlights and shadows.',
      ),
      (
        LucideIcons.palette,
        'Color Temperature Synthesis',
        'By assessing individual red/yellow melanin balance against your luminance tier, we curate shades that maximize your natural glow.',
      ),
    ];

    return Column(
      children: List.generate(entries.length, (index) {
        final item = entries[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == entries.length - 1 ? 0 : 12),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
            borderColor: dark ? AppColors.nightLine : AppColors.line,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconContainer(
                  icon: item.$1,
                  backgroundColor: dark ? AppColors.nightSurface : AppColors.surfaceClay,
                  iconColor: AppColors.clay,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.$3,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
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
        ).animate().fadeIn(delay: Duration(milliseconds: 140 + index * 80)).slideX(begin: 0.04);
      }),
    );
  }
}

class _PrivacyTechnologyCard extends StatelessWidget {
  const _PrivacyTechnologyCard();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surfaceSage,
      borderColor: dark ? AppColors.nightLine : AppColors.sage.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shieldCheck, color: AppColors.success, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Respectfully Private & Offline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'All facial detection, pixel classification, and color matching run completely offline inside the app sandbox. No image is uploaded, indexed, or shared with third parties.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  const _DeveloperCard();

  Future<void> _openUrl(String url) async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
    required String semanticLabel,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: () => _openUrl(url),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.clay),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                LucideIcons.arrowUpRight,
                size: 14,
                color: AppColors.clay.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surfaceClay,
      borderColor: dark ? AppColors.nightLine : AppColors.claySoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'LEAD ARCHITECT & DEVELOPER',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.clay.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: AppColors.clay.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  'v1.0.0+1',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.clay,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Karan S Suvarna',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          _buildLinkRow(
            context,
            icon: LucideIcons.mail,
            label: 'suvarnakaran77@gmail.com',
            url: 'mailto:suvarnakaran77@gmail.com',
            semanticLabel: 'Send email to suvarnakaran77@gmail.com',
          ),
          const SizedBox(height: 4),
          _buildLinkRow(
            context,
            icon: LucideIcons.github,
            label: 'github.com/karanks6',
            url: 'https://github.com/karanks6',
            semanticLabel: 'Visit GitHub profile karanks6',
          ),
          const SizedBox(height: 4),
          _buildLinkRow(
            context,
            icon: LucideIcons.globe,
            label: 'aboutkaran.vercel.app',
            url: 'https://aboutkaran.vercel.app/',
            semanticLabel: 'Visit portfolio website aboutkaran.vercel.app',
          ),
          const SizedBox(height: 4),
          _buildLinkRow(
            context,
            icon: LucideIcons.instagram,
            label: 'instagram.com/_karan_suvarna_',
            url: 'https://www.instagram.com/_karan_suvarna_?exln=dHo4NGF2aWcyNDNu',
            semanticLabel: 'Visit Instagram profile _karan_suvarna_',
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: dark ? AppColors.nightLine : AppColors.claySoft,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'App Version',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                'v1.0.0+1 (Build 1)',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.clay,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
