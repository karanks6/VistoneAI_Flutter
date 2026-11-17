import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// A restrained, reusable wash of colour that stops the app background from
/// feeling like a stack of isolated cards.
class AppPageBackdrop extends StatelessWidget {
  final Widget child;
  final bool dark;

  const AppPageBackdrop({super.key, required this.child, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final isDark = dark || Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: isDark ? AppColors.night : const Color(0xFFFAF7F2)),
        // Top right gentle botanical sage ambience
        Positioned(
          top: -80,
          right: -60,
          child: _BlurredDisc(
            color: isDark ? AppColors.forest.withValues(alpha: 0.3) : const Color(0xFFE5EFE7),
            size: 320,
          ),
        ),
        // Middle right subtle flowing sage ribbon
        if (!isDark)
          Positioned(
            top: 420,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.75,
                child: Image.asset(
                  'assets/images/bg_wave_right_clean.png',
                  width: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class _BlurredDisc extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurredDisc({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 7,
      child: Container(
        width: size,
        height: size * .72,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .46),
          borderRadius: BorderRadius.circular(size),
        ),
      ),
    );
  }
}

class AppIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool inverted;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.semanticLabel,
    this.inverted = false,
  });

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = widget.inverted
        ? AppColors.textInverse.withValues(alpha: .15)
        : (isDark ? AppColors.nightSurfaceRaised : AppColors.surface);
    final foreground = widget.inverted
        ? AppColors.textInverse
        : (isDark ? AppColors.nightText : AppColors.ink);
    final border = widget.inverted
        ? Border.all(
            color: AppColors.textInverse.withValues(alpha: .18),
            width: 1,
          )
        : Border.all(
            color: isDark ? AppColors.nightLine : AppColors.line,
            width: 1,
          );

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        scale: _pressed ? 0.90 : 1.0,
        curve: Curves.easeOutCubic,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              onTapDown: (_) => setState(() => _pressed = true),
              onTapCancel: () => setState(() => _pressed = false),
              onTapUp: (_) => setState(() => _pressed = false),
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(widget.icon, size: 20, color: foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
