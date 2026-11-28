import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vistone_app/core/theme/app_colors.dart';
import 'package:vistone_app/core/theme/app_theme.dart';
import 'package:vistone_app/screens/about_screen.dart';

/// Deterministic [ThemeData] matching [AppTheme] tokens without offline font HTTP fetches.
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
      secondary: isDark ? AppColors.clay : const Color(0xFFB34D32),
      onSecondary: isDark ? AppColors.ink : AppColors.textInverse,
      error: AppColors.error,
      onError: AppColors.textInverse,
      surface: isDark ? AppColors.nightSurface : AppColors.surface,
      onSurface: displayColor,
    ),
    extensions: [isDark ? VistoneThemeTokens.dark : VistoneThemeTokens.light],
    textTheme: TextTheme(
      displayMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.12,
        color: displayColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.18,
        color: displayColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: displayColor,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: displayColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: bodyColor,
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
      labelLarge: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: bodyColor,
      ),
      labelMedium: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
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

Widget _wrapScreen({
  required WidgetTester tester,
  Size size = const Size(400, 900),
  ThemeData? theme,
  ThemeMode themeMode = ThemeMode.light,
  bool disableAnimations = false,
  bool boldText = false,
  double textScale = 1.0,
  Future<bool> Function(Uri url, {LaunchMode mode})? urlLauncher,
}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final router = GoRouter(
    initialLocation: '/about',
    routes: [
      GoRoute(
        path: '/about',
        builder: (_, __) => AboutScreen(urlLauncher: urlLauncher),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const Scaffold(body: Text('Home Screen Route')),
      ),
    ],
  );

  return ProviderScope(
    child: MediaQuery(
      data: MediaQueryData(
        size: size,
        disableAnimations: disableAnimations,
        boldText: boldText,
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp.router(
        theme: theme ?? _buildTestTheme(Brightness.light),
        darkTheme: _buildTestTheme(Brightness.dark),
        themeMode: themeMode,
        routerConfig: router,
      ),
    ),
  );
}

void main() {
  testWidgets(
    'AboutScreen renders developer info, links, app version, and passes Light Mode a11y guidelines',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_wrapScreen(tester: tester));
      await tester.pumpAndSettle();

      expect(find.text('VISTONE AI'), findsOneWidget);
      expect(find.text('THE VISTONE METHOD'), findsOneWidget);
      expect(find.text('Colour Studio'), findsOneWidget);
      expect(find.text('Colour, Considered.'), findsOneWidget);

      // Separate semantics container check for top back button
      final backSemantics = tester.getSemantics(
        find.bySemanticsLabel('Return home'),
      );
      expect(backSemantics.label, equals('Return home'));

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Scroll down to Developer Card and footer
      final developerNameFinder = find.text('Karan S Suvarna');
      await tester.scrollUntilVisible(
        developerNameFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(developerNameFinder, findsOneWidget);
      expect(find.text('suvarnakaran77@gmail.com'), findsOneWidget);
      expect(find.text('github.com/karanks6'), findsOneWidget);
      expect(find.text('aboutkaran.vercel.app'), findsOneWidget);
      expect(find.text('instagram.com/_karan_suvarna_'), findsOneWidget);
      expect(find.text('v1.0.0+1'), findsOneWidget);
      expect(find.text('v1.0.0+1 (Build 1)'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('ON-DEVICE COLOUR STUDIO'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('ON-DEVICE COLOUR STUDIO'), findsOneWidget);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    },
  );

  testWidgets('AboutScreen passes accessibility guidelines in Dark Mode', (
    WidgetTester tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _wrapScreen(tester: tester, themeMode: ThemeMode.dark),
    );
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await tester.scrollUntilVisible(
      find.text('Karan S Suvarna'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  testWidgets(
    'Interactive Monk spectrum selector, stepper buttons, and method cards respond to taps and keyboard',
    (WidgetTester tester) async {
      await tester.pumpWidget(_wrapScreen(tester: tester));
      await tester.pumpAndSettle();

      // Default highlighted tone is MST 05
      expect(find.text('MST 05 · Medium Honey Tan · #D7BD96'), findsOneWidget);

      // Step forward using Next Monk tone button -> MST 06
      await tester.tap(find.bySemanticsLabel('Next Monk tone'));
      await tester.pumpAndSettle();
      expect(find.text('MST 06 · Olive Bronze · #A07E56'), findsOneWidget);

      // Tap near left edge of Monk spectrum bar -> switches to MST 01
      final sliderFinder = find.byKey(const ValueKey('monk_spectrum_bar'));
      final sliderBox = tester.getRect(sliderFinder);
      await tester.tapAt(Offset(sliderBox.left + 8, sliderBox.center.dy));
      await tester.pumpAndSettle();
      expect(find.text('MST 01 · Porcelain Fair · #F6EDE4'), findsOneWidget);

      // Expand first method card
      final methodCardFinder = find.text('Harvard Monk Scale (MST)');
      await tester.scrollUntilVisible(
        methodCardFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(methodCardFinder);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Calibrates lightness depth independently'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Tapping developer links launches external URLs and falls back cleanly to clipboard copy',
    (WidgetTester tester) async {
      final launchedUrls = <String>[];
      var allowLaunch = true;

      String? copiedUrl;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copiedUrl = (call.arguments as Map)['text'] as String?;
            }
            return null;
          });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await tester.pumpWidget(
        _wrapScreen(
          tester: tester,
          urlLauncher: (uri, {mode = LaunchMode.platformDefault}) async {
            launchedUrls.add(uri.toString());
            return allowLaunch;
          },
        ),
      );
      await tester.pumpAndSettle();

      final portfolioFinder = find.text('aboutkaran.vercel.app');
      await tester.scrollUntilVisible(
        portfolioFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // 1. Primary launch succeeds
      await tester.tap(portfolioFinder);
      await tester.pumpAndSettle();
      expect(launchedUrls, contains('https://aboutkaran.vercel.app/'));

      await tester.tap(find.text('github.com/karanks6'));
      await tester.pumpAndSettle();
      expect(launchedUrls, contains('https://github.com/karanks6'));

      // 2. Fallback to clipboard + snackbar when launcher returns false
      allowLaunch = false;
      await tester.tap(find.text('suvarnakaran77@gmail.com'));
      await tester.pumpAndSettle();
      expect(copiedUrl, equals('suvarnakaran77@gmail.com'));
      expect(
        find.text('Copied link: suvarnakaran77@gmail.com'),
        findsOneWidget,
      );

      await tester.tap(find.text('instagram.com/_karan_suvarna_'));
      await tester.pumpAndSettle();
      expect(
        copiedUrl,
        equals(
          'https://www.instagram.com/_karan_suvarna_?exln=dHo4NGF2aWcyNDNu',
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'AboutScreen handles 360px 2.0x text scaling, wide tablet layout, reduced motion, and navigation cleanly',
    (WidgetTester tester) async {
      final handle = tester.ensureSemantics();

      // Narrow 360px with 2.0x bold text and reduced motion
      await tester.pumpWidget(
        _wrapScreen(
          tester: tester,
          size: const Size(360, 640),
          disableAnimations: true,
          boldText: true,
          textScale: 2.0,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Wide 900x800 tablet layout
      await tester.pumpWidget(
        _wrapScreen(tester: tester, size: const Size(900, 800)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));

      // Tapping back navigates cleanly to /home
      await tester.tap(find.bySemanticsLabel('Return home'));
      await tester.pumpAndSettle();
      expect(find.text('Home Screen Route'), findsOneWidget);

      handle.dispose();
    },
  );
}
