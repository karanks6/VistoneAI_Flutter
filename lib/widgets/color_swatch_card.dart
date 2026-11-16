import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/color_swatch.dart' as models;
import 'design_system.dart';

class ColorSwatchCard extends StatefulWidget {
  final models.ColorSwatch swatch;
  final bool isAvoid;
  final VoidCallback? onTap;

  const ColorSwatchCard({
    super.key,
    required this.swatch,
    this.isAvoid = false,
    this.onTap,
  });

  @override
  State<ColorSwatchCard> createState() => _ColorSwatchCardState();
}

class _ColorSwatchCardState extends State<ColorSwatchCard> {
  bool _pressed = false;

  Color _color() {
    final hex = widget.swatch.hex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final foreground = color.computeLuminance() > 0.45 ? AppColors.ink : AppColors.textInverse;
    final tag = 'swatch-${widget.swatch.hex}-${widget.isAvoid}';

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.95 : 1.0,
        curve: Curves.easeOutCubic,
        child: Hero(
          tag: tag,
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            elevation: _pressed ? 1 : 3,
            shadowColor: color.withValues(alpha: 0.35),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(
                  color: foreground.withValues(alpha: 0.16),
                  width: 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.95),
                    color,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: foreground.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          widget.isAvoid ? 'PAUSE' : 'WEAR',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: foreground,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                      Icon(
                        widget.isAvoid ? LucideIcons.minusCircle : LucideIcons.arrowUpRight,
                        size: 16,
                        color: foreground,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    widget.swatch.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.swatch.hex.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: foreground.withValues(alpha: 0.82),
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Icon(
                        LucideIcons.sparkles,
                        size: 13,
                        color: foreground.withValues(alpha: 0.6),
                      ),
                    ],
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
