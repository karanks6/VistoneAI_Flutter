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

class _HomeScreenState extends ConsumerState<HomeScreen> {
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

  void _showTipDialog(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.forest.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.forest, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.nightText : AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.nightMuted
                          : AppColors.textSecondary,
                      height: 1.5,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'Understood',
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedImage = ref.watch(selectedImageProvider);

    // Canvas coordinate reference system: 853 x 1844
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0C1E1B) : const Color(0xFFFAF7F2),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              // Proportional coordinate scaling against the 853 x 1844 canvas
              final sx = width / 853.0;
              final sy = height / 1844.0;

              // Color tokens matching user typography specification:
              // Header brand & subtitle: Dark Charcoal/Black (#1A1D1A)
              final cBrand = isDark ? AppColors.nightText : const Color(0xFF1A1D1A);
              final cBrandSub = isDark ? AppColors.nightMuted : const Color(0xFF1A1D1A);
              // Hero & Section Title: Very Dark Forest Green (#0C251C)
              final cDark = isDark ? AppColors.nightText : const Color(0xFF0C251C);
              // Flash card titles: Dark Charcoal (#222523)
              final cCardTitle = isDark ? AppColors.nightText : const Color(0xFF222523);
              // Flash card subtitles: Medium Gray (#5D615F)
              final cCardSub = isDark ? AppColors.nightMuted : const Color(0xFF5D615F);
              // Subtitle/Body: Dark Gray/Charcoal (#424543)
              final cBody = isDark ? AppColors.nightMuted : const Color(0xFF424543);
              // Action card title: Dark Forest Green (#133A2D)
              final cCardHead = isDark ? AppColors.nightText : const Color(0xFF133A2D);
              // Action card body: Medium-Dark Gray (#555856)
              final cCardBody = isDark ? AppColors.nightMuted : const Color(0xFF555856);
              // Privacy note: Forest Green (#1E5645)
              final cPrivacy = isDark ? AppColors.sage : const Color(0xFF1E5645);
              // Button text: Solid White (#FFFFFF)
              final cButtonText = Colors.white;
              // Backward-compatible alias for selected image state
              final cGreen = cPrivacy;
              final cMuted = cCardSub;
              // Footer text & dot: Dark Forest Green (#133A2D)
              final cFooter = isDark ? const Color(0xFF9EABA4) : const Color(0xFF133A2D);
              final cFooterDot = isDark ? AppColors.sage : const Color(0xFF133A2D);

              return SizedBox.expand(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Base photographic artwork template spanning the full screen
                    Positioned.fill(
                      child: Image.asset(
                        isDark
                            ? 'assets/images/Dark Green Beauty App Interface.png'
                            : 'assets/images/Text-Free Sage Beauty App Interface.png',
                        fit: BoxFit.fill,
                      ),
                    ),

                    // 2. Top Header Brand Typography (App Name beside logo)
                    Positioned(
                      left: 126 * sx,
                      top: 116 * sy,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'VISTONE AI',
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.8,
                              color: cBrand,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Colour Studio',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.2,
                              color: cBrandSub,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Top-Right Theme Toggle Button (Over Moon Icon)
                    Positioned(
                      left: 686 * sx,
                      top: 92 * sy,
                      width: 60 * sx,
                      height: 60 * sy,
                      child: Semantics(
                        button: true,
                        label: isDark
                            ? 'Switch to light theme'
                            : 'Switch to dark theme',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                          child: isDark
                              ? Center(
                                  child: Container(
                                    width: 44 * sx,
                                    height: 44 * sx,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF0F221E),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      LucideIcons.sunMedium,
                                      color: Colors.white,
                                      size: 20 * sx,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),

                    // 4. Top-Right Help Button (Over '?' Icon)
                    Positioned(
                      left: 758 * sx,
                      top: 92 * sy,
                      width: 60 * sx,
                      height: 60 * sy,
                      child: Semantics(
                        button: true,
                        label: 'How Vistone sees colour guide',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showGuideBottomSheet(context),
                        ),
                      ),
                    ),

                    // 5. Hero Headline Typography ("Dress in your best light.")
                    Positioned(
                      left: 48 * sx,
                      top: 240 * sy,
                      width: 440 * sx,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Dress in your\n',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                                letterSpacing: -0.5,
                                color: cDark,
                              ),
                            ),
                            TextSpan(
                              text: 'best light.',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                height: 1.1,
                                letterSpacing: -0.5,
                                color: cDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 6. Hero Subtitle Typography
                    Positioned(
                      left: 48 * sx,
                      top: 406 * sy,
                      width: 430 * sx,
                      child: Text(
                        'A thoughtful read of your natural complexion, unlocking curated shades made to bring you forward.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.38,
                          color: cBody,
                        ),
                      ),
                    ),

                    // 7. Main Card Content Area (or Selected Image Preview)
                    if (selectedImage == null) ...[
                      // Unselected state: exact text & "Choose a photo" button matching template
                      Positioned(
                        left: 48 * sx,
                        right: 48 * sx,
                        top: 632 * sy,
                        child: Center(
                          child: Text(
                            'Start with a simple selfie',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: cCardHead,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 48 * sx,
                        right: 48 * sx,
                        top: 678 * sy,
                        child: Center(
                          child: Text(
                            'Natural light and your lovely, unedited face are all\nyou need for an accurate reading.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                              height: 1.32,
                              color: cCardBody,
                            ),
                          ),
                        ),
                      ),

                      // Interactive "Choose a photo" Button with camera icon
                      Positioned(
                        left: 105 * sx,
                        top: 746 * sy,
                        width: 642 * sx,
                        height: 84 * sy,
                        child: Semantics(
                          button: true,
                          label: 'Choose a photo from gallery or camera',
                          child: _AnimatedPillButton(
                            onTap: () => _showUploadOptions(context),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LucideIcons.camera,
                                      color: cButtonText,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Choose a photo',
                                      style: GoogleFonts.inter(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w500,
                                        color: cButtonText,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // "Processed privately on this device" note
                      Positioned(
                        left: 48 * sx,
                        right: 48 * sx,
                        top: 852 * sy,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.lock,
                                  color: cPrivacy,
                                  size: 13,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Processed privately on this device',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.2,
                                    color: cPrivacy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Selected Image State: Elegant preview overlay within the card
                      Positioned(
                        left: 55 * sx,
                        top: 545 * sy,
                        width: 743 * sx,
                        height: 385 * sy,
                        child: Container(
                          padding: EdgeInsets.all(16 * sx),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.nightSurface
                                : Colors.white.withValues(alpha: 0.96),
                            borderRadius: BorderRadius.circular(28 * sx),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(16 * sx),
                                      child: Image.file(
                                        selectedImage,
                                        width: 130 * sx,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 16 * sx),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: cGreen
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppRadii.pill),
                                            ),
                                            child: Text(
                                              'PHOTO READY',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.2,
                                                color: cGreen,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Ready for Monk Scale Analysis',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: cDark,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Skin pixel sampling and tone matrix calibrated.',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              color: cMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(
                                      height: 48 * sy,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF143B2F),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppRadii.pill),
                                          ),
                                        ),
                                        icon: const Icon(
                                          LucideIcons.sparkles,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Analyse Complexion',
                                          style: GoogleFonts.inter(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          ref
                                              .read(analysisProvider.notifier)
                                              .reset();
                                          context.push('/analyzing');
                                          ref
                                              .read(analysisProvider.notifier)
                                              .analyze(selectedImage);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 48 * sy,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: cDark,
                                          side: BorderSide(
                                            color: isDark
                                                ? AppColors.nightLine
                                                : const Color(0xFFDFE6E1),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppRadii.pill),
                                          ),
                                        ),
                                        onPressed: () =>
                                            _showUploadOptions(context),
                                        child: Text(
                                          'Change',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // 8. Preparation Guide Section Header
                    Positioned(
                      left: 48 * sx,
                      top: 940 * sy,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.lightbulb,
                            color: cDark,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Preparation Guide',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: cDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 48 * sx,
                      top: 1004 * sy,
                      child: Text(
                        'A clear selfie makes an accurate palette.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: cBody,
                        ),
                      ),
                    ),

                    // 9. Guide Card 1: Find gentle daylight
                    Positioned(
                      left: 48 * sx,
                      top: 1088 * sy,
                      width: 757 * sx,
                      child: Semantics(
                        button: true,
                        label: 'Guide: Find gentle daylight',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showTipDialog(
                            context,
                            title: 'Find Gentle Daylight',
                            description:
                                'Face a window with soft, natural morning or afternoon light. Direct sunlight creates harsh specular glare, while artificial yellow/blue bulbs shift skin undertones.',
                            icon: LucideIcons.sun,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4 * sy),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: (200 - 48) * sx),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Find gentle daylight',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          color: cCardTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Face a window with soft, natural morning or\nafternoon light. Avoid harsh overhead bulbs.',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                          color: cCardSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: (805 - 755) * sx),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 10. Guide Card 2: Keep your face clear
                    Positioned(
                      left: 48 * sx,
                      top: 1228 * sy,
                      width: 757 * sx,
                      child: Semantics(
                        button: true,
                        label: 'Guide: Keep your face clear',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showTipDialog(
                            context,
                            title: 'Keep Your Face Clear',
                            description:
                                'Tuck your hair behind your ears and remove hats, glasses, or heavy jewelry. Keep an unforced, neutral facial expression looking straight into the lens.',
                            icon: LucideIcons.scanFace,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4 * sy),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: (200 - 48) * sx),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Keep your face clear',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          color: cCardTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Remove hats or heavy accessories and look\ndirectly into the camera with an even expression.',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                          color: cCardSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: (805 - 755) * sx),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 11. Guide Card 3: Skip beauty filters
                    Positioned(
                      left: 48 * sx,
                      top: 1368 * sy,
                      width: 757 * sx,
                      child: Semantics(
                        button: true,
                        label: 'Guide: Skip beauty filters',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showTipDialog(
                            context,
                            title: 'Skip Beauty Filters',
                            description:
                                'Camera beautifiers, smoothing algorithms, and colour saturation filters distort your natural undertone math. An unedited photo guarantees precision recommendations.',
                            icon: LucideIcons.wand2,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4 * sy),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: (200 - 48) * sx),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Skip beauty filters',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                          color: cCardTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Use an unedited, natural photo so the skin\npixel sampler measures your genuine undertone.',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                          color: cCardSub,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: (805 - 755) * sx),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 12. Bottom Card: "How Vistone sees colour"
                    Positioned(
                      left: 48 * sx,
                      top: 1540 * sy,
                      width: 757 * sx,
                      child: Semantics(
                        button: true,
                        label: 'How Vistone sees colour guide',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showGuideBottomSheet(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10 * sy),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: (218 - 48) * sx),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'How Vistone sees colour',
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'A guide to Monk Scale AI, undertone math & styling.',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                          color: const Color(0xFFE2EBE5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: (805 - 740) * sx),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 13. Fixed Bottom Footer Status Line (Anchored slightly upper)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: math.max(26.0, MediaQuery.paddingOf(context).bottom + 14),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cFooterDot,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'VISTONE AI  •  ON-DEVICE INFERENCE ENGINE',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                  color: cFooter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
/// Tactile button with animated scale feedback
class _AnimatedPillButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPillButton({
    required this.child,
    required this.onTap,
  });

  @override
  State<_AnimatedPillButton> createState() => _AnimatedPillButtonState();
}

class _AnimatedPillButtonState extends State<_AnimatedPillButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppMotion.micro,
        curve: Curves.easeOutCubic,
        child: widget.child,
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
                  Expanded(
                    child: Text(
                      'How Vistone Sees Colour',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.nightText : AppColors.ink,
                      ),
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
