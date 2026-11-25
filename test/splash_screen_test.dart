import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vistone_app/core/theme/app_colors.dart';
import 'package:vistone_app/core/theme/app_theme.dart';
import 'package:vistone_app/screens/splash_screen.dart';

/// Builds test [ThemeData] matching [AppTheme] tokens without triggering async HTTP font fetches.
ThemeData _buildTestTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final displayColor = isDark ? AppColors.nightText : AppColors.ink;
  final bodyColor = isDark ? AppColors.nightMuted : AppColors.textSecondary;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: isDark ? AppColors.night : AppColors.canvas,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.sage : AppColors.forest,
      onPrimary: isDark ? AppColors.ink : AppColors.textInverse,
      secondary: AppColors.clay,
      onSecondary: AppColors.textInverse,
      error: AppColors.error,
      onError: AppColors.textInverse,
      surface: isDark ? AppColors.nightSurface : AppColors.surface,
      onSurface: displayColor,
    ),
    extensions: [isDark ? VistoneThemeTokens.dark : VistoneThemeTokens.light],
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w400,
        height: 1.08,
        letterSpacing: -0.6,
        color: displayColor,
      ),
      displayMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.4,
        color: displayColor,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.15,
        letterSpacing: -0.2,
        color: displayColor,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: displayColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: bodyColor,
      ),
      labelMedium: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: bodyColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: bodyColor,
      ),
    ),
  );
}

void main() {
  Widget buildTestApp(
    WidgetTester tester, {
    bool disableAnimations = false,
    bool accessibleNavigation = false,
    bool boldText = false,
    double textScaleFactor = 1.0,
    Size size = const Size(400, 850),
    ThemeData? themeOverride,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              const Scaffold(body: Text('Home Destination Screen')),
        ),
      ],
    );

    return MediaQuery(
      data: MediaQueryData(
        disableAnimations: disableAnimations,
        accessibleNavigation: accessibleNavigation,
        boldText: boldText,
        textScaler: TextScaler.linear(textScaleFactor),
        size: size,
      ),
      child: MaterialApp.router(
        theme: themeOverride ?? _buildTestTheme(Brightness.light),
        darkTheme: _buildTestTheme(Brightness.dark),
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }

  testWidgets(
    'SplashScreen renders editorial brand header, swatch fan, and meets Light Mode guidelines',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildTestApp(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1400));

      expect(find.text('VISTONE AI'), findsNWidgets(2));
      expect(find.text('Colour Studio'), findsOneWidget);
      expect(
        find.textContaining('Colour, read in\nyour best light.'),
        findsOneWidget,
      );
      expect(find.text('ON-DEVICE COLOUR STUDIO'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Verify top header & Skip are pinned near the top and footer near the bottom (850px viewport)
      expect(tester.getTopLeft(find.text('VISTONE AI').first).dy, lessThan(60));
      expect(tester.getTopLeft(find.text('Skip')).dy, lessThan(60));
      expect(
        tester.getBottomLeft(find.text('ON-DEVICE COLOUR STUDIO')).dy,
        greaterThan(790),
      );

      // Compiled SemanticsNode check for Skip button & label-in-name
      final skipSemantics = tester.getSemantics(
        find.bySemanticsLabel('Skip introduction and go to studio home'),
      );
      expect(
        skipSemantics.label,
        equals('Skip introduction and go to studio home'),
      );

      // Official Flutter accessibility guideline checks
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
    },
  );

  testWidgets(
    'SplashScreen meets contrast and accessibility guidelines in Dark Mode',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(buildTestApp(tester, themeMode: ThemeMode.dark));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1400));

      expect(find.text('VISTONE AI'), findsNWidgets(2));
      expect(find.text('Colour Studio'), findsOneWidget);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
    },
  );

  testWidgets('Tapping Skip triggers navigation to /home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp(tester));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets(
    'Keyboard Tab focus and Enter activation triggers Skip navigation',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Home Destination Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'SplashScreen auto-navigates to /home after editorial reveal duration',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildTestApp(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();

      expect(find.text('Home Destination Screen'), findsOneWidget);
    },
  );

  testWidgets('SplashScreen respects reduced motion accessibility', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp(tester, disableAnimations: true));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets(
    'SplashScreen under accessibleNavigation waits for user even with disableAnimations',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestApp(
          tester,
          accessibleNavigation: true,
          disableAnimations: true,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 3000));

      // Must NOT abruptly dismiss while screen reader is active
      expect(
        find.textContaining('Colour, read in\nyour best light.'),
        findsOneWidget,
      );

      final continueFinder = find.text('Continue');
      expect(continueFinder, findsOneWidget);

      // Label in Name check: Continue control's semantic label starts with "Continue"
      final continueSemantics = tester.getSemantics(
        find.bySemanticsLabel('Continue to studio home'),
      );
      expect(continueSemantics.label, equals('Continue to studio home'));

      await tester.tap(continueFinder);
      await tester.pumpAndSettle();

      expect(find.text('Home Destination Screen'), findsOneWidget);
      handle.dispose();
    },
  );

  testWidgets(
    'SplashScreen handles 2.0x scaling, boldText, and compact screen without overflow or ellipsis',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        buildTestApp(
          tester,
          textScaleFactor: 2.0,
          boldText: true,
          size: const Size(360, 640),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      expect(tester.takeException(), isNull);
      expect(find.text('VISTONE AI'), findsNWidgets(2));
      expect(find.text('ON-DEVICE COLOUR STUDIO'), findsOneWidget);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    },
  );

  testWidgets('SplashScreen adapts cleanly to wide tablet layouts (>= 600px)', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(buildTestApp(tester, size: const Size(900, 700)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));

    expect(tester.takeException(), isNull);
    expect(
      find.textContaining('Colour, read in\nyour best light.'),
      findsOneWidget,
    );

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets('SplashScreen renders legibly under default fallback ThemeData', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      buildTestApp(tester, themeOverride: ThemeData.light()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));

    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
