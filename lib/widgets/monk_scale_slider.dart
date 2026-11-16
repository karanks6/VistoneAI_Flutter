import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'design_system.dart';

class MonkScaleSlider extends StatefulWidget {
  final List<String> monkColors;
  final int detectedTone;

  const MonkScaleSlider({
    super.key,
    required this.monkColors,
    required this.detectedTone,
  });

  @override
  State<MonkScaleSlider> createState() => _MonkScaleSliderState();
}

class _MonkScaleSliderState extends State<MonkScaleSlider> {
  late int _inspectedTone;

  @override
  void initState() {
    super.initState();
    _inspectedTone = widget.detectedTone;
  }

  Color _parseHex(String value) {
    final cleaned = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$cleaned', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final isSelectedDetected = _inspectedTone == widget.detectedTone;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: dark ? AppColors.nightSurfaceRaised : AppColors.surface,
      borderColor: dark ? AppColors.nightLine : AppColors.line,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.scale, size: 16, color: AppColors.clay),
                  const SizedBox(width: 8),
                  Text(
                    'MONK SKIN TONE SCALE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelectedDetected ? AppColors.surfaceClay : (dark ? AppColors.nightSurface : AppColors.surfaceMuted),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  border: Border.all(
                    color: isSelectedDetected ? AppColors.clay.withValues(alpha: 0.5) : (dark ? AppColors.nightLine : AppColors.line),
                  ),
                ),
                child: Text(
                  isSelectedDetected ? 'YOUR MATCH: MST ${_inspectedTone.toString().padLeft(2, '0')}' : 'INSPECTING: MST ${_inspectedTone.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelectedDetected ? AppColors.clay : AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '10-point inclusive skin spectrum developed for AI equity and color calibration.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: dark ? AppColors.nightMuted : AppColors.textTertiary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Scale bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.monkColors.length, (index) {
              final tone = index + 1;
              final isMatch = tone == widget.detectedTone;
              final isInspected = tone == _inspectedTone;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _inspectedTone = tone);
                    },
                    child: Column(
                      children: [
                        if (isMatch)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(
                              LucideIcons.chevronDown,
                              size: 13,
                              color: AppColors.clay,
                            ),
                          )
                        else
                          const SizedBox(height: 17),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          height: isInspected ? 52 : (isMatch ? 42 : 32),
                          decoration: BoxDecoration(
                            color: _parseHex(widget.monkColors[index]),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            border: isInspected
                                ? Border.all(color: AppColors.clay, width: 2.5)
                                : isMatch
                                    ? Border.all(color: AppColors.marigold, width: 2)
                                    : Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1),
                            boxShadow: isInspected
                                ? [
                                    BoxShadow(
                                      color: _parseHex(widget.monkColors[index]).withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 180),
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: isInspected
                                    ? AppColors.clay
                                    : (isMatch ? Theme.of(context).colorScheme.primary : AppColors.textTertiary),
                                fontWeight: isInspected || isMatch ? FontWeight.w800 : FontWeight.w600,
                              ),
                          child: Text('$tone'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
