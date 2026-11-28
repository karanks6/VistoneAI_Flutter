import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

class AppPrimaryButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerPressed(bool reduceMotion) {
    final active =
        widget.isEnabled && !widget.isLoading && widget.onPressed != null;
    if (!active) return;
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  void _handleTapDown(TapDownDetails details, bool reduceMotion) {
    if (widget.isEnabled && !widget.isLoading && !reduceMotion) {
      HapticFeedback.lightImpact();
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details, bool reduceMotion) {
    if (widget.isEnabled && !widget.isLoading) {
      if (!reduceMotion) {
        _controller.reverse();
      }
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel(bool reduceMotion) {
    if (widget.isEnabled && !widget.isLoading && !reduceMotion) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isEnabled && !widget.isLoading;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final focusColor = isDark ? AppColors.marigold : AppColors.ink;

    return FocusableActionDetector(
      enabled: active,
      mouseCursor: active ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: (focused) => setState(() => _isFocused = focused),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            _triggerPressed(reduceMotion);
            return null;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (_) {
            _triggerPressed(reduceMotion);
            return null;
          },
        ),
      },
      child: Semantics(
        container: true,
        button: true,
        enabled: active,
        focusable: active,
        focused: _isFocused,
        label: widget.label,
        onTap: active ? () => _triggerPressed(reduceMotion) : null,
        child: GestureDetector(
          onTapDown: active ? (d) => _handleTapDown(d, reduceMotion) : null,
          onTapUp: active ? (d) => _handleTapUp(d, reduceMotion) : null,
          onTapCancel: active ? () => _handleTapCancel(reduceMotion) : null,
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          child: ScaleTransition(
            scale: reduceMotion
                ? const AlwaysStoppedAnimation(1.0)
                : _scaleAnimation,
            child: AnimatedOpacity(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              opacity: active ? 1 : 0.45,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 52),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? const Color(0xFF133E32),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: _isFocused
                        ? Border.all(color: focusColor, width: 2.5)
                        : null,
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color:
                                  (widget.backgroundColor ??
                                          const Color(0xFF133E32))
                                      .withValues(alpha: 0.28),
                              blurRadius: 16,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textInverse,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: widget.trailingIcon != null
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (widget.icon != null) ...[
                                        Icon(
                                          widget.icon,
                                          color:
                                              widget.foregroundColor ??
                                              AppColors.textInverse,
                                          size: 19,
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                      Flexible(
                                        child: Text(
                                          widget.label,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color:
                                                    widget.foregroundColor ??
                                                    AppColors.textInverse,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.trailingIcon != null) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    widget.trailingIcon,
                                    color:
                                        widget.foregroundColor ??
                                        AppColors.textInverse,
                                    size: 19,
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
