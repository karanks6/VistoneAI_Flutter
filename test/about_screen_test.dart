import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vistone_app/core/theme/app_theme.dart';
import 'package:vistone_app/screens/about_screen.dart';

void main() {
  testWidgets('AboutScreen renders developer info, links, and app version',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AboutScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Scroll down to the Developer Card
    final developerNameFinder = find.text('Karan S Suvarna');
    await tester.scrollUntilVisible(
      developerNameFinder,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // 1. Developer name
    expect(developerNameFinder, findsOneWidget);

    // 2. Contact info (email)
    expect(find.text('suvarnakaran77@gmail.com'), findsOneWidget);

    // 3. GitHub account
    expect(find.text('github.com/karanks6'), findsOneWidget);

    // 4. Portfolio
    expect(find.text('aboutkaran.vercel.app'), findsOneWidget);

    // 5. Instagram id
    expect(find.text('instagram.com/_karan_suvarna_'), findsOneWidget);

    // 6. App version
    expect(find.text('v1.0.0+1'), findsOneWidget);
    expect(find.text('v1.0.0+1 (Build 1)'), findsOneWidget);
  });

  testWidgets('Tapping links in developer card executes without crashing',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AboutScreen(),
        ),
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

    // Tap portfolio link
    await tester.tap(portfolioFinder);
    await tester.pump(const Duration(milliseconds: 50));

    // Tap instagram link
    final instagramFinder = find.text('instagram.com/_karan_suvarna_');
    await tester.tap(instagramFinder);
    await tester.pump(const Duration(milliseconds: 50));

    // Tap github link
    final githubFinder = find.text('github.com/karanks6');
    await tester.tap(githubFinder);
    await tester.pump(const Duration(milliseconds: 50));

    // Tap email link
    final emailFinder = find.text('suvarnakaran77@gmail.com');
    await tester.tap(emailFinder);
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);
  });
}
