import 'dart:async';
import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/color_swatch.dart' as models;
import '../providers/analysis_provider.dart';
import '../widgets/design_system.dart';

class ColorPreviewScreen extends ConsumerStatefulWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final String undertone;

  const ColorPreviewScreen({
    super.key,
    required this.swatch,
    required this.isAvoid,
    required this.undertone,
  });

  @override
  ConsumerState<ColorPreviewScreen> createState() => _ColorPreviewScreenState();
}

class _ColorPreviewScreenState extends ConsumerState<ColorPreviewScreen> {
  bool _copied = false;
  bool _showDrape = false;
  Timer? _copyResetTimer;

  Color get _color {
    final hex = widget.swatch.hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    super.dispose();
  }

  Future<void> _copyHex() async {
    await FlutterClipboard.copy(widget.swatch.hex.toUpperCase());
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _copied = true);
    _copyResetTimer?.cancel();
    _copyResetTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final isLight = color.computeLuminance() > 0.44;
    final fg = isLight ? AppColors.ink : AppColors.textInverse;
    final mutedFg = fg.withValues(alpha: 0.72);
    final userImage = ref.watch(selectedImageProvider);
    final tag = 'swatch-${widget.swatch.hex}-${widget.isAvoid}';

    final r = (color.r * 255.0).round() & 0xff;
    final g = (color.g * 255.0).round() & 0xff;
    final b = (color.b * 255.0).round() & 0xff;

    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 700;
            final sculptureSize = isCompact ? 156.0 : 200.0;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 620,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Navigation Bar
                        Row(
                          children: [
                            AppIconButton(
                              icon: LucideIcons.arrowLeft,
                              semanticLabel: 'Back to palette results',
                              onTap: () => context.pop(),
                              inverted: true,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  if (userImage != null)
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setState(
                                          () => _showDrape = !_showDrape,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: fg.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(
                                            AppRadii.pill,
                                          ),
                                          border: Border.all(
                                            color: fg.withValues(alpha: 0.2),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _showDrape
                                                  ? LucideIcons.palette
                                                  : LucideIcons.userCheck,
                                              size: 14,
                                              color: fg,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              _showDrape
                                                  ? 'SWATCH VIEW'
                                                  : 'VIRTUAL DRAPE',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: fg,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 1.1,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: fg.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(
                                        AppRadii.pill,
                                      ),
                                    ),
                                    child: Text(
                                      widget.isAvoid
                                          ? 'PAUSE ON THIS'
                                          : 'HARMONIOUS SHADE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: fg,
                                            letterSpacing: 1.1,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Centerpiece: Hero Swatch or Virtual Drape
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: isCompact ? 16 : 24,
                          ),
                          child: Center(
                            child: Hero(
                              tag: tag,
                              child: Material(
                                color: Colors.transparent,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 320),
                                  child: _showDrape && userImage != null
                                      ? _VirtualDrapePortrait(
                                          image: userImage,
                                          color: color,
                                          foreground: fg,
                                          size: sculptureSize,
                                        )
                                      : _ColorSculpture(
                                          color: color,
                                          foreground: fg,
                                          size: sculptureSize,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bottom Color Details Card + Footer
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(
                                    color: isLight
                                        ? Colors.white.withValues(alpha: 0.90)
                                        : Colors.black.withValues(alpha: 0.40),
                                    borderRadius: BorderRadius.circular(
                                      AppRadii.hero,
                                    ),
                                    border: Border.all(
                                      color: fg.withValues(alpha: 0.14),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.swatch.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                        color: fg,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 26,
                                                      ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  'RGB($r, $g, $b) · ${widget.isAvoid ? 'Opposing temperature' : 'Complementary temperature'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: mutedFg,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          // Quick copy button
                                          GestureDetector(
                                            onTap: _copyHex,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _copied
                                                    ? AppColors.success
                                                    : fg.withValues(
                                                        alpha: 0.15,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppRadii.pill,
                                                    ),
                                                border: Border.all(
                                                  color: _copied
                                                      ? AppColors.success
                                                      : fg.withValues(
                                                          alpha: 0.22,
                                                        ),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _copied
                                                        ? LucideIcons.check
                                                        : LucideIcons.copy,
                                                    size: 15,
                                                    color: _copied
                                                        ? AppColors.textInverse
                                                        : fg,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _copied
                                                        ? 'COPIED'
                                                        : widget.swatch.hex
                                                              .toUpperCase(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                          color: _copied
                                                              ? AppColors
                                                                    .textInverse
                                                              : fg,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1.0,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        widget.isAvoid
                                            ? 'This tone can compete with the natural ${widget.undertone.toLowerCase()} balance of your complexion when worn directly against the face. Recommend styling it as skirts, pants, belts, shoes, or leather goods.'
                                            : 'This shade complements the natural ${widget.undertone.toLowerCase()} radiance of your skin tone. Ideal for shirts, blouses, knitwear, jackets, eyewear, and makeup accents.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: fg.withValues(alpha: 0.9),
                                              height: 1.45,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 150.ms, duration: 400.ms)
                                .slideY(begin: 0.08),
                            const SizedBox(height: 14),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 1.5,
                                      color: mutedFg,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'VISTONE AI COLOUR THEORY',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: mutedFg,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'TAP TO COPY CODE',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: mutedFg,
                                        letterSpacing: 1.0,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ColorSculpture extends StatelessWidget {
  final Color color;
  final Color foreground;
  final double size;

  const _ColorSculpture({
    required this.color,
    required this.foreground,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.95,
            height: size * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: foreground.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: size * 0.70,
            height: size * 0.70,
            decoration: BoxDecoration(
              color: foreground.withValues(alpha: 0.16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size * 0.35),
                topRight: Radius.circular(size * 0.35),
                bottomLeft: Radius.circular(size * 0.10),
                bottomRight: Radius.circular(size * 0.35),
              ),
            ),
          ),
          Container(
            width: size * 0.27,
            height: size * 0.27,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VirtualDrapePortrait extends StatelessWidget {
  final File image;
  final Color color;
  final Color foreground;
  final double size;

  const _VirtualDrapePortrait({
    required this.image,
    required this.color,
    required this.foreground,
    this.size = 210,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: foreground.withValues(alpha: 0.4), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(child: Image.file(image, fit: BoxFit.cover)),
    );
  }
}
