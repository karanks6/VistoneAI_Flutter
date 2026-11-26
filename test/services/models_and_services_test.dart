import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vistone_app/models/analysis_result.dart';
import 'package:vistone_app/models/color_swatch.dart' as models;
import 'package:vistone_app/providers/analysis_provider.dart';
import 'package:vistone_app/providers/theme_provider.dart';
import 'package:vistone_app/services/color_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Models', () {
    test(
      'ColorSwatch.fromJson parses valid JSON and uses defaults on null',
      () {
        final valid = models.ColorSwatch.fromJson({
          'name': 'Olive Silk',
          'hex': '#6E7F5E',
        });
        expect(valid.name, equals('Olive Silk'));
        expect(valid.hex, equals('#6E7F5E'));

        final fallback = models.ColorSwatch.fromJson({});
        expect(fallback.name, equals(''));
        expect(fallback.hex, equals('#000000'));
      },
    );

    test(
      'AnalysisResult computes emojis, confidence tiers, and parses JSON',
      () {
        final warmResult = AnalysisResult.fromJson({
          'tone': 4,
          'undertone': 'Warm',
          'tone_confidence': 0.88,
          'ut_confidence': 0.85,
          'best_colors': [
            {'name': 'Terracotta', 'hex': '#D66B4D'},
          ],
          'avoid_colors': [
            {'name': 'Icy Cyan', 'hex': '#9CEAEF'},
          ],
          'monk_colors': ['#f6ede4', '#f3e7db'],
        });

        expect(warmResult.tone, equals(4));
        expect(warmResult.undertoneEmoji, equals('🔥'));
        expect(warmResult.isHighConfidence, isTrue);
        expect(warmResult.isMediumConfidence, isFalse);
        expect(warmResult.bestColors.single.name, equals('Terracotta'));
        expect(warmResult.avoidColors.single.hex, equals('#9CEAEF'));

        const cool = AnalysisResult(
          tone: 2,
          undertone: 'Cool',
          toneConfidence: 0.60,
          utConfidence: 0.80,
          bestColors: [],
          avoidColors: [],
          monkColors: [],
        );
        expect(cool.undertoneEmoji, equals('❄️'));
        expect(cool.isHighConfidence, isFalse);
        expect(cool.isMediumConfidence, isTrue);

        const neutral = AnalysisResult(
          tone: 6,
          undertone: 'Neutral',
          toneConfidence: 0.30,
          utConfidence: 0.80,
          bestColors: [],
          avoidColors: [],
          monkColors: [],
        );
        expect(neutral.undertoneEmoji, equals('🌿'));
        expect(neutral.isHighConfidence, isFalse);
        expect(neutral.isMediumConfidence, isFalse);
      },
    );
  });

  group('ColorDatabase', () {
    test(
      'loads real JSON asset and returns 6 best + 6 avoid swatches for all 30 Monk combinations',
      () async {
        await colorDatabase.load();

        final hexPattern = RegExp(r'^#[0-9A-Fa-f]{6}$');
        for (var tone = 1; tone <= 10; tone++) {
          for (final undertone in ['warm', 'cool', 'neutral']) {
            final recs = colorDatabase.getRecommendations(tone, undertone);
            final best = recs['best'] ?? [];
            final avoid = recs['avoid'] ?? [];

            expect(
              best.length,
              equals(6),
              reason:
                  'Expected 6 best colors for tone=$tone undertone=$undertone',
            );
            expect(
              avoid.length,
              equals(6),
              reason:
                  'Expected 6 avoid colors for tone=$tone undertone=$undertone',
            );

            for (final swatch in [...best, ...avoid]) {
              expect(swatch.name.trim(), isNotEmpty);
              expect(hexPattern.hasMatch(swatch.hex), isTrue);
            }
          }
        }
      },
    );

    test(
      'handles uppercase undertones and falls back cleanly on unknown values',
      () async {
        await colorDatabase.load();

        final upper = colorDatabase.getRecommendations(3, 'WARM');
        expect(upper['best'], hasLength(6));

        final unknownUt = colorDatabase.getRecommendations(3, 'OliveUnknown');
        expect(unknownUt['best'], hasLength(6));

        final invalidTone = colorDatabase.getRecommendations(99, 'warm');
        expect(invalidTone['best'], isEmpty);
        expect(invalidTone['avoid'], isEmpty);
      },
    );
  });

  group('ThemeNotifier', () {
    test(
      'defaults to light, restores saved preference, toggles, and persists',
      () async {
        SharedPreferences.setMockInitialValues({});
        var prefs = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container.dispose);

        expect(container.read(themeProvider), equals(ThemeMode.light));

        await container.read(themeProvider.notifier).toggleTheme();
        expect(container.read(themeProvider), equals(ThemeMode.dark));
        expect(prefs.getString('theme_preference'), equals('dark'));

        await container.read(themeProvider.notifier).toggleTheme();
        expect(container.read(themeProvider), equals(ThemeMode.light));
        expect(prefs.getString('theme_preference'), equals('light'));

        await container.read(themeProvider.notifier).setMode(ThemeMode.dark);
        expect(container.read(themeProvider), equals(ThemeMode.dark));

        // Verify fresh container reads persisted preference
        final container2 = ProviderContainer(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        );
        addTearDown(container2.dispose);
        expect(container2.read(themeProvider), equals(ThemeMode.dark));
      },
    );
  });

  group('AnalysisNotifier', () {
    test(
      'starts idle, transitions through loading stages, handles errors, and resets',
      () async {
        final notifier = AnalysisNotifier();
        addTearDown(notifier.dispose);

        expect(notifier.state, isA<AnalysisIdle>());

        // Trigger analysis on a non-existent file to verify stage progression + error catch
        final future = notifier.analyze(File('non_existent_selfie_test.jpg'));
        expect(notifier.state, isA<AnalysisLoading>());
        await future;

        expect(notifier.state, isA<AnalysisError>());
        expect((notifier.state as AnalysisError).message, isNotEmpty);

        notifier.reset();
        expect(notifier.state, isA<AnalysisIdle>());
      },
    );
  });
}
