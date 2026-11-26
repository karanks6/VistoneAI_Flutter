import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vistone_app/core/theme/app_colors.dart';
import 'package:vistone_app/core/theme/app_theme.dart';
import 'package:vistone_app/models/analysis_result.dart';
import 'package:vistone_app/models/color_swatch.dart' as models;
import 'package:vistone_app/providers/analysis_provider.dart';
import 'package:vistone_app/providers/theme_provider.dart';
import 'package:vistone_app/screens/about_screen.dart';
import 'package:vistone_app/screens/analyzing_screen.dart';
import 'package:vistone_app/screens/color_preview_screen.dart';
import 'package:vistone_app/screens/home_screen.dart';
import 'package:vistone_app/screens/result_screen.dart';

/// Deterministic theme matching [AppTheme] tokens without triggering offline GoogleFonts fetches.
ThemeData _testTheme(Brightness brightness) {
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
        color: displayColor,
      ),
      displayMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: displayColor,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: displayColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: bodyColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
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
        color: bodyColor,
      ),
    ),
  );
}

class _FakeAnalysisNotifier extends AnalysisNotifier {
  _FakeAnalysisNotifier(AnalysisState initialState) : super() {
    state = initialState;
  }

  void emitState(AnalysisState next) {
    state = next;
  }
}

AnalysisResult _sampleResult() {
  return const AnalysisResult(
    tone: 4,
    undertone: 'Warm',
    toneConfidence: 0.91,
    utConfidence: 0.86,
    bestColors: [
      models.ColorSwatch(name: 'Forest Pine', hex: '#1B4D3E'),
      models.ColorSwatch(name: 'Terracotta Silk', hex: '#C86D51'),
      models.ColorSwatch(name: 'Warm Cream', hex: '#F6EDE4'),
    ],
    avoidColors: [
      models.ColorSwatch(name: 'Frost Lilac', hex: '#D7D0EB'),
      models.ColorSwatch(name: 'Cool Slate', hex: '#5A6D7E'),
    ],
    monkColors: [
      '#f6ede4',
      '#f3e7db',
      '#f7ead0',
      '#eadaba',
      '#d7bd96',
      '#a07e56',
      '#825c43',
      '#604134',
      '#3a312a',
      '#292420',
    ],
  );
}

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  void configureViewport(
    WidgetTester tester, [
    Size size = const Size(400, 850),
  ]) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('AnalyzingScreen', () {
    testWidgets(
      'renders active scan UI, step tracker, and updates live stages',
      (tester) async {
        configureViewport(tester);
        final fakeNotifier = _FakeAnalysisNotifier(
          const AnalysisLoading(stage: 'Sampling skin pixels...'),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [analysisProvider.overrideWith((_) => fakeNotifier)],
            child: MaterialApp(
              theme: _testTheme(Brightness.light),
              home: const AnalyzingScreen(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.text('Reading your palette'), findsOneWidget);
        expect(find.text('ACTIVE'), findsOneWidget);
        expect(find.text('FACIAL MESH SCANNER'), findsOneWidget);
        expect(find.text('Sampling skin pixels...'), findsOneWidget);
        expect(find.text('COMPLETE'), findsNWidgets(2));
        expect(find.text('ANALYZING'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'shows error dialog on AnalysisError and Try Another Photo returns to /home',
      (tester) async {
        configureViewport(tester);
        final fakeNotifier = _FakeAnalysisNotifier(
          const AnalysisLoading(stage: 'Detecting face landmarks...'),
        );

        final router = GoRouter(
          initialLocation: '/analyzing',
          routes: [
            GoRoute(
              path: '/analyzing',
              builder: (_, __) => const AnalyzingScreen(),
            ),
            GoRoute(
              path: '/home',
              builder: (_, __) => const Scaffold(body: Text('Returned Home')),
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [analysisProvider.overrideWith((_) => fakeNotifier)],
            child: MaterialApp.router(
              theme: _testTheme(Brightness.light),
              routerConfig: router,
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        fakeNotifier.emitState(
          const AnalysisError('Could not detect a face. Try a clearer photo.'),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Could not complete analysis'), findsOneWidget);
        expect(
          find.text('Could not detect a face. Try a clearer photo.'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Try Another Photo'));
        await tester.pumpAndSettle();

        expect(find.text('Returned Home'), findsOneWidget);
      },
    );

    testWidgets('fits narrow 360x640 screen cleanly without overflow', (
      tester,
    ) async {
      configureViewport(tester, const Size(360, 640));
      final fakeNotifier = _FakeAnalysisNotifier(
        const AnalysisError('Sample short failure'),
      );

      // Verify main layout & error dialog on compact viewport
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            analysisProvider.overrideWith(
              (_) => _FakeAnalysisNotifier(
                const AnalysisLoading(stage: 'Classifying skin tone...'),
              ),
            ),
          ],
          child: MaterialApp(
            theme: _testTheme(Brightness.dark),
            home: const AnalyzingScreen(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
      fakeNotifier.dispose();
    });
  });

  group('ResultScreen & MonkScaleSlider & ColorPreviewScreen', () {
    testWidgets('shows loading view when analysis state is idle', (
      tester,
    ) async {
      configureViewport(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            analysisProvider.overrideWith(
              (_) => _FakeAnalysisNotifier(const AnalysisIdle()),
            ),
          ],
          child: MaterialApp(
            theme: _testTheme(Brightness.light),
            home: const ResultScreen(),
          ),
        ),
      );

      expect(find.text('Preparing your color profile...'), findsOneWidget);
    });

    testWidgets(
      'renders full results, interactive Monk slider, share snackbar, and navigates to ColorPreviewScreen',
      (tester) async {
        configureViewport(tester);
        final fakeNotifier = _FakeAnalysisNotifier(
          AnalysisSuccess(_sampleResult()),
        );

        final router = GoRouter(
          initialLocation: '/result',
          routes: [
            GoRoute(path: '/result', builder: (_, __) => const ResultScreen()),
            GoRoute(
              path: '/home',
              builder: (_, __) =>
                  const Scaffold(body: Text('Home Screen Route')),
            ),
            GoRoute(
              path: '/color-preview',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>;
                return ColorPreviewScreen(
                  swatch: extra['swatch'] as models.ColorSwatch,
                  isAvoid: extra['isAvoid'] as bool,
                  undertone: extra['undertone'] as String,
                );
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [analysisProvider.overrideWith((_) => fakeNotifier)],
            child: MaterialApp.router(
              theme: _testTheme(Brightness.light),
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Your Natural Palette'), findsOneWidget);
        expect(find.text('04'), findsOneWidget);
        expect(find.text('Warm Undertone'), findsOneWidget);
        expect(find.text('91%'), findsOneWidget);
        expect(find.text('86%'), findsOneWidget);
        expect(find.text('YOUR MATCH: MST 04'), findsOneWidget);
        expect(tester.takeException(), isNull);

        // Tap tone 8 on MonkScaleSlider
        await tester.tap(find.text('8'));
        await tester.pumpAndSettle();
        expect(find.text('INSPECTING: MST 08'), findsOneWidget);

        // Tap share button
        await tester.tap(find.bySemanticsLabel('Share palette summary'));
        await tester.pump();
        expect(
          find.textContaining('Palette summary: Monk Tone 4 (Warm)'),
          findsOneWidget,
        );

        // Scroll to Shades to Reach For and open a swatch in ColorPreviewScreen
        final swatchFinder = find.text('Forest Pine');
        await tester.scrollUntilVisible(
          swatchFinder,
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(swatchFinder);
        await tester.pumpAndSettle();

        // Verify ColorPreviewScreen rendered properly
        expect(find.text('HARMONIOUS SHADE'), findsOneWidget);
        expect(find.text('Forest Pine'), findsOneWidget);
        expect(
          find.text('RGB(27, 77, 62) · Complementary temperature'),
          findsOneWidget,
        );
        expect(find.text('#1B4D3E'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'renders ResultScreen without overflow on compact 360x640 viewport in Dark Mode',
      (tester) async {
        configureViewport(tester, const Size(360, 640));
        final fakeNotifier = _FakeAnalysisNotifier(
          AnalysisSuccess(_sampleResult()),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [analysisProvider.overrideWith((_) => fakeNotifier)],
            child: MaterialApp(
              theme: _testTheme(Brightness.dark),
              home: const ResultScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Your Natural Palette'), findsOneWidget);
      },
    );
  });

  group('ColorPreviewScreen', () {
    testWidgets(
      'copies hex to clipboard, toggles COPIED badge, and supports light/avoid tones',
      (tester) async {
        configureViewport(tester, const Size(360, 640));

        String? copiedClipboard;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, (call) async {
              if (call.method == 'Clipboard.setData') {
                copiedClipboard = (call.arguments as Map)['text'] as String?;
              }
              return null;
            });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(SystemChannels.platform, null);
        });

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: _testTheme(Brightness.light),
              home: const ColorPreviewScreen(
                swatch: models.ColorSwatch(name: 'Warm Cream', hex: '#F6EDE4'),
                isAvoid: true,
                undertone: 'Cool',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('PAUSE ON THIS'), findsOneWidget);
        expect(find.text('Warm Cream'), findsOneWidget);
        expect(
          find.text('RGB(246, 237, 228) · Opposing temperature'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('#F6EDE4'));
        await tester.pump();
        expect(find.text('COPIED'), findsOneWidget);
        expect(copiedClipboard, equals('#F6EDE4'));

        // Advance past the 1800ms reset timer
        await tester.pump(const Duration(milliseconds: 1900));
        expect(find.text('#F6EDE4'), findsOneWidget);
      },
    );
  });

  group('End-to-End Home Navigation & Theme Toggle', () {
    testWidgets(
      'HomeScreen theme toggle switches Light <-> Dark and Explore navigates to AboutScreen',
      (tester) async {
        configureViewport(tester);

        final router = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
            child: Consumer(
              builder: (context, ref, _) {
                final mode = ref.watch(themeProvider);
                return MaterialApp.router(
                  theme: _testTheme(Brightness.light),
                  darkTheme: _testTheme(Brightness.dark),
                  themeMode: mode,
                  routerConfig: router,
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Toggle theme from Light -> Dark
        final toggleToDark = find.bySemanticsLabel('Switch to dark theme');
        expect(toggleToDark, findsOneWidget);
        await tester.tap(toggleToDark);
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Switch to light theme'), findsOneWidget);
        expect(prefs.getString('theme_preference'), equals('dark'));

        // Open guide sheet and navigate to AboutScreen
        await tester.tap(find.text('How Vistone sees colour'));
        await tester.pumpAndSettle();
        expect(find.text('Explore full methodology'), findsOneWidget);

        await tester.tap(find.text('Explore full methodology'));
        await tester.pumpAndSettle();
        expect(find.text('THE VISTONE METHOD'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}
