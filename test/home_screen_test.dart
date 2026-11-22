import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vistone_app/providers/theme_provider.dart';
import 'package:vistone_app/screens/home_screen.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Widget createHomeScreenTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MediaQuery(
        data: MediaQueryData(size: Size(400, 850)),
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
  }

  testWidgets('HomeScreen renders all text overlays and template elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(450, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createHomeScreenTestWidget());
    await tester.pumpAndSettle();

    // 1. Header brand
    expect(find.text('VISTONE AI'), findsOneWidget);
    expect(find.text('Colour Studio'), findsOneWidget);

    // 2. Hero Headline & Subtitle
    expect(find.textContaining('Dress in your'), findsOneWidget);
    expect(find.textContaining('best light.'), findsOneWidget);
    expect(
      find.textContaining(
        'A thoughtful read of your natural complexion',
      ),
      findsOneWidget,
    );

    // 3. Upload card text
    expect(find.text('Start with a simple selfie'), findsOneWidget);
    expect(
      find.textContaining('Natural light and your lovely, unedited face'),
      findsOneWidget,
    );
    expect(find.text('Choose a photo'), findsOneWidget);
    expect(
      find.text('Processed privately on this device'),
      findsOneWidget,
    );

    // 4. Preparation Guide
    expect(find.text('Preparation Guide'), findsOneWidget);
    expect(
      find.text('A clear selfie makes an accurate palette.'),
      findsOneWidget,
    );

    // 5. Guide Cards
    expect(find.text('Find gentle daylight'), findsOneWidget);
    expect(find.text('Keep your face clear'), findsOneWidget);
    expect(find.text('Skip beauty filters'), findsOneWidget);

    // 6. Bottom card & Footer
    expect(find.text('How Vistone sees colour'), findsOneWidget);
    expect(
      find.text('A guide to Monk Scale AI, undertone math & styling.'),
      findsOneWidget,
    );
    expect(
      find.text('VISTONE AI  •  ON-DEVICE INFERENCE ENGINE'),
      findsOneWidget,
    );
  });

  testWidgets('Tapping Choose a photo opens upload options bottom sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(450, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createHomeScreenTestWidget());
    await tester.pumpAndSettle();

    final chooseBtn = find.text('Choose a photo');
    expect(chooseBtn, findsOneWidget);
    await tester.tap(chooseBtn);
    await tester.pumpAndSettle();

    // Verify upload options bottom sheet appeared with camera and gallery options
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from library'), findsOneWidget);
  });

  testWidgets('Tapping How Vistone sees colour opens guide bottom sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(450, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createHomeScreenTestWidget());
    await tester.pumpAndSettle();

    final guideCard = find.text('How Vistone sees colour');
    expect(guideCard, findsOneWidget);
    await tester.tap(guideCard);
    await tester.pumpAndSettle();

    // Verify guide bottom sheet appeared
    expect(find.text('How Vistone Sees Colour'), findsOneWidget);
    expect(find.text('Explore full methodology'), findsOneWidget);
  });

  testWidgets('Tapping guide items opens specific tip dialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(450, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createHomeScreenTestWidget());
    await tester.pumpAndSettle();

    final daylightItem = find.text('Find gentle daylight');
    expect(daylightItem, findsOneWidget);
    await tester.tap(daylightItem);
    await tester.pumpAndSettle();

    // Verify tip sheet opened
    expect(find.text('Find Gentle Daylight'), findsOneWidget);
    expect(find.text('Understood'), findsOneWidget);
  });
}
