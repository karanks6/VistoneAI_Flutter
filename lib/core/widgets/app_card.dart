import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';

class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = AppRadii.lg,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ?? Theme.of(context).cardTheme.color ?? AppColors.surface;
    final border = widget.borderColor ?? (isDark ? AppColors.nightLine : AppColors.line);
    final shadow = widget.boxShadow ?? AppShadows.card;

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(color: border, width: 1),
        boxShadow: _pressed ? AppShadows.cardActive : shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap != null
              ? () {
                  HapticFeedback.selectionClick();
                  widget.onTap!();
                }
              : null,
          onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: widget.onTap != null ? () => setState(() => _pressed = false) : null,
          onTapUp: widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
          borderRadius: BorderRadius.circular(widget.radius),
          splashColor: AppColors.clay.withValues(alpha: 0.08),
          highlightColor: AppColors.clay.withValues(alpha: 0.04),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.onTap == null) return content;

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.98 : 1.0,
      curve: Curves.easeOutCubic,
      child: content,
    );
  }
}
