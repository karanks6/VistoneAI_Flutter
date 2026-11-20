import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vistone_app/screens/splash_screen.dart';

void main() {
  Widget buildTestApp({
    bool disableAnimations = false,
    bool accessibleNavigation = false,
    double textScaleFactor = 1.0,
    Size size = const Size(400, 850),
  }) {
    final router = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(
            body: Text('Home Destination Screen'),
          ),
        ),
      ],
    );

    return MediaQuery(
      data: MediaQueryData(
        disableAnimations: disableAnimations,
        accessibleNavigation: accessibleNavigation,
        textScaler: TextScaler.linear(textScaleFactor),
        size: size,
      ),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets(
      'SplashScreen renders brand elements, headline, and calibration HUD',
      (WidgetTester tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(buildTestApp());
    // Initial entrance animation settles
    await tester.pump(const Duration(milliseconds: 500));

    // Verify brand text & badges
    expect(find.text('VISTONE AI'), findsOneWidget);
    expect(find.text('STUDIO'), findsOneWidget);
    expect(find.text('INCLUSIVE CHROMATIC SCIENCE'), findsOneWidget);
    expect(find.text('Find the shades\nthat feel like you.'), findsOneWidget);

    // Verify Skip button exists with semantics
    expect(find.text('SKIP'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label ==
                'Skip introduction and go to studio home' &&
            widget.properties.onTap != null,
      ),
      findsOneWidget,
    );

    // Verify calibration HUD elements
    expect(find.text('STUDIO ENGINE v2.4'), findsOneWidget);
    expect(find.text('MONK SCALE ML (MST 01-10)'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Tapping SKIP triggers navigation to /home',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pump(const Duration(milliseconds: 50));

    // Tap the Skip button
    final skipFinder = find.text('SKIP');
    expect(skipFinder, findsOneWidget);
    await tester.tap(skipFinder);
    await tester.pumpAndSettle();

    // Verify navigation landed on home screen
    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets(
      'SplashScreen auto-navigates to /home after calibration duration in normal mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pump(const Duration(milliseconds: 50));

    // Advance beyond the 2800ms timeline
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pumpAndSettle();

    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets('SplashScreen respects reduced motion accessibility',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(disableAnimations: true));
    await tester.pump();
    await tester.pumpAndSettle();

    // Under reduced motion, it should proceed directly to home without stalling
    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets(
      'SplashScreen under accessibleNavigation waits for user and allows manual skip',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp(accessibleNavigation: true));
    await tester.pump(const Duration(milliseconds: 50));

    // Even after 3 seconds, it does not abruptly navigate away from screen reader users
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.text('Find the shades\nthat feel like you.'), findsOneWidget);

    // User can activate Skip button manually
    final skipFinder = find.text('SKIP');
    await tester.tap(skipFinder);
    await tester.pumpAndSettle();

    expect(find.text('Home Destination Screen'), findsOneWidget);
  });

  testWidgets(
      'SplashScreen handles 2.0x high text scaling and compact screens without overflow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestApp(
        textScaleFactor: 2.0,
        size: const Size(360, 640),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Check that there is no RenderFlex overflow
    expect(tester.takeException(), isNull);
    expect(find.text('VISTONE AI'), findsOneWidget);
  });
}
