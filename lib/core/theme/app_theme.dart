import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_radii.dart';

@immutable
class VistoneThemeTokens extends ThemeExtension<VistoneThemeTokens> {
  final Color cardBackground;
  final Color cardRaised;
  final Color cardBorder;
  final Color subtleBorder;
  final Color glassFill;
  final Color glassBorder;
  final Color accentTerracotta;
  final Color accentBotanical;
  final Color accentGold;
  final Color tagBackground;
  final Color tagText;
  final Color studioCanvas;
  final Color studioInk;
  final Color frostedCardFill;
  final Color frostedCardBorder;
  final Color mintBadgeFill;
  final Color mintBadgeForeground;
  final Color emeraldBannerStart;
  final Color emeraldBannerEnd;
  final Color onBannerText;
  final Color onBannerMuted;

  const VistoneThemeTokens({
    required this.cardBackground,
    required this.cardRaised,
    required this.cardBorder,
    required this.subtleBorder,
    required this.glassFill,
    required this.glassBorder,
    required this.accentTerracotta,
    required this.accentBotanical,
    required this.accentGold,
    required this.tagBackground,
    required this.tagText,
    required this.studioCanvas,
    required this.studioInk,
    required this.frostedCardFill,
    required this.frostedCardBorder,
    required this.mintBadgeFill,
    required this.mintBadgeForeground,
    required this.emeraldBannerStart,
    required this.emeraldBannerEnd,
    required this.onBannerText,
    required this.onBannerMuted,
  });

  @override
  VistoneThemeTokens copyWith({
    Color? cardBackground,
    Color? cardRaised,
    Color? cardBorder,
    Color? subtleBorder,
    Color? glassFill,
    Color? glassBorder,
    Color? accentTerracotta,
    Color? accentBotanical,
    Color? accentGold,
    Color? tagBackground,
    Color? tagText,
    Color? studioCanvas,
    Color? studioInk,
    Color? frostedCardFill,
    Color? frostedCardBorder,
    Color? mintBadgeFill,
    Color? mintBadgeForeground,
    Color? emeraldBannerStart,
    Color? emeraldBannerEnd,
    Color? onBannerText,
    Color? onBannerMuted,
  }) {
    return VistoneThemeTokens(
      cardBackground: cardBackground ?? this.cardBackground,
      cardRaised: cardRaised ?? this.cardRaised,
      cardBorder: cardBorder ?? this.cardBorder,
      subtleBorder: subtleBorder ?? this.subtleBorder,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      accentTerracotta: accentTerracotta ?? this.accentTerracotta,
      accentBotanical: accentBotanical ?? this.accentBotanical,
      accentGold: accentGold ?? this.accentGold,
      tagBackground: tagBackground ?? this.tagBackground,
      tagText: tagText ?? this.tagText,
      studioCanvas: studioCanvas ?? this.studioCanvas,
      studioInk: studioInk ?? this.studioInk,
      frostedCardFill: frostedCardFill ?? this.frostedCardFill,
      frostedCardBorder: frostedCardBorder ?? this.frostedCardBorder,
      mintBadgeFill: mintBadgeFill ?? this.mintBadgeFill,
      mintBadgeForeground: mintBadgeForeground ?? this.mintBadgeForeground,
      emeraldBannerStart: emeraldBannerStart ?? this.emeraldBannerStart,
      emeraldBannerEnd: emeraldBannerEnd ?? this.emeraldBannerEnd,
      onBannerText: onBannerText ?? this.onBannerText,
      onBannerMuted: onBannerMuted ?? this.onBannerMuted,
    );
  }

  @override
  VistoneThemeTokens lerp(ThemeExtension<VistoneThemeTokens>? other, double t) {
    if (other is! VistoneThemeTokens) return this;
    return VistoneThemeTokens(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardRaised: Color.lerp(cardRaised, other.cardRaised, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleBorder: Color.lerp(subtleBorder, other.subtleBorder, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      accentTerracotta: Color.lerp(
        accentTerracotta,
        other.accentTerracotta,
        t,
      )!,
      accentBotanical: Color.lerp(accentBotanical, other.accentBotanical, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      tagBackground: Color.lerp(tagBackground, other.tagBackground, t)!,
      tagText: Color.lerp(tagText, other.tagText, t)!,
      studioCanvas: Color.lerp(studioCanvas, other.studioCanvas, t)!,
      studioInk: Color.lerp(studioInk, other.studioInk, t)!,
      frostedCardFill: Color.lerp(frostedCardFill, other.frostedCardFill, t)!,
      frostedCardBorder: Color.lerp(
        frostedCardBorder,
        other.frostedCardBorder,
        t,
      )!,
      mintBadgeFill: Color.lerp(mintBadgeFill, other.mintBadgeFill, t)!,
      mintBadgeForeground: Color.lerp(
        mintBadgeForeground,
        other.mintBadgeForeground,
        t,
      )!,
      emeraldBannerStart: Color.lerp(
        emeraldBannerStart,
        other.emeraldBannerStart,
        t,
      )!,
      emeraldBannerEnd: Color.lerp(
        emeraldBannerEnd,
        other.emeraldBannerEnd,
        t,
      )!,
      onBannerText: Color.lerp(onBannerText, other.onBannerText, t)!,
      onBannerMuted: Color.lerp(onBannerMuted, other.onBannerMuted, t)!,
    );
  }

  static const light = VistoneThemeTokens(
    cardBackground: AppColors.surface,
    cardRaised: AppColors.surfaceWarm,
    cardBorder: AppColors.line,
    subtleBorder: AppColors.line,
    glassFill: Color(0xCCFFFEFA),
    glassBorder: Color(0x33E4E1D9),
    accentTerracotta: AppColors.clay,
    accentBotanical: AppColors.forest,
    accentGold: AppColors.warning,
    tagBackground: AppColors.surfaceSage,
    tagText: AppColors.forestDeep,
    studioCanvas: AppColors.silkCanvas,
    studioInk: AppColors.forestInk,
    frostedCardFill: AppColors.silkCard,
    frostedCardBorder: AppColors.line,
    mintBadgeFill: AppColors.sageBadgeLight,
    mintBadgeForeground: AppColors.forestDeep,
    emeraldBannerStart: AppColors.emeraldBannerStart,
    emeraldBannerEnd: AppColors.emeraldBannerEnd,
    onBannerText: AppColors.textInverse,
    onBannerMuted: AppColors.bannerMutedMint,
  );

  static const dark = VistoneThemeTokens(
    cardBackground: AppColors.nightSurface,
    cardRaised: AppColors.nightSurfaceRaised,
    cardBorder: AppColors.nightLine,
    subtleBorder: AppColors.nightLine,
    glassFill: Color(0xCC182522),
    glassBorder: Color(0x3334443E),
    accentTerracotta: AppColors.clay,
    accentBotanical: AppColors.sage,
    accentGold: AppColors.marigold,
    tagBackground: AppColors.nightSurfaceRaised,
    tagText: AppColors.sage,
    studioCanvas: AppColors.emeraldNight,
    studioInk: AppColors.nightText,
    frostedCardFill: AppColors.emeraldNightCard,
    frostedCardBorder: AppColors.emeraldNightCardBorder,
    mintBadgeFill: AppColors.sageBadgeDark,
    mintBadgeForeground: AppColors.sageSoft,
    emeraldBannerStart: AppColors.emeraldBannerStart,
    emeraldBannerEnd: AppColors.emeraldBannerEnd,
    onBannerText: AppColors.nightText,
    onBannerMuted: AppColors.bannerMutedMint,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final text = AppTypography.getTheme(
      isDark ? AppColors.nightText : AppColors.ink,
      isDark ? AppColors.nightMuted : AppColors.textSecondary,
    );
    final surface = isDark ? AppColors.nightSurface : AppColors.surface;
    final outline = isDark ? AppColors.nightLine : AppColors.line;
    final tokens = isDark ? VistoneThemeTokens.dark : VistoneThemeTokens.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? AppColors.night : AppColors.canvas,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: isDark ? AppColors.sage : AppColors.forest,
        onPrimary: isDark ? AppColors.ink : AppColors.textInverse,
        secondary: isDark ? AppColors.clay : const Color(0xFFB34D32),
        onSecondary: isDark ? AppColors.ink : AppColors.textInverse,
        error: AppColors.error,
        onError: AppColors.textInverse,
        surface: surface,
        onSurface: isDark ? AppColors.nightText : AppColors.ink,
      ),
      extensions: [tokens],
      textTheme: text,
      dividerColor: outline,
      splashFactory: InkSparkle.splashFactory,
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: outline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.nightSurfaceRaised : AppColors.ink,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: AppColors.textInverse,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sheet),
        ),
      ),
    );
  }
}
