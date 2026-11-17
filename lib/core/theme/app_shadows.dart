import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.ink.withValues(alpha: 0.04),
          blurRadius: 18,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get cardActive => [
        BoxShadow(
          color: AppColors.ink.withValues(alpha: 0.08),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get raisedAction => [
        BoxShadow(
          color: AppColors.clay.withValues(alpha: 0.22),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}
