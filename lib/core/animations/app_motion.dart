import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  // Strict physical durations
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration ringScale = Duration(milliseconds: 180);
  static const Duration scrimFade = Duration(milliseconds: 200);
  static const Duration routeTransition = Duration(milliseconds: 250);
  static const Duration themeCrossfade = Duration(milliseconds: 300);
  static const Duration entrance = Duration(milliseconds: 350);
  static const Duration sheetSlide = Duration(milliseconds: 400);
  static const Duration entranceStagger = Duration(milliseconds: 50);
  static const Duration reducedMotion = Duration(milliseconds: 100);

  // Easing curve
  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeInOutCubic;
}
