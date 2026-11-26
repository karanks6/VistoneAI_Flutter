import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:vistone_app/engine/color_math.dart';
import 'package:vistone_app/engine/face_regions.dart';
import 'package:vistone_app/engine/skin_classifier.dart';

/// Builds a synthetic 468-point MediaPipe facial mesh centered in a [width]x[height] image.
List<IntPoint> _buildSyntheticFaceMesh({int width = 300, int height = 300}) {
  // Base all 468 points at face center (150, 150) first
  final points = List<IntPoint>.filled(468, IntPoint(width ~/ 2, height ~/ 2));

  // Helper to assign polygon vertices smoothly
  void setPoly(List<int> indices, List<IntPoint> coords) {
    for (var i = 0; i < indices.length && i < coords.length; i++) {
      points[indices[i]] = coords[i];
    }
  }

  // Left cheek polygon indices: [234, 93, 132, 116, 117, 118, 119, 120, 121, 128]
  setPoly(
    [234, 93, 132, 116, 117, 118, 119, 120, 121, 128],
    const [
      IntPoint(70, 145),
      IntPoint(75, 175),
      IntPoint(95, 195),
      IntPoint(125, 190),
      IntPoint(130, 165),
      IntPoint(125, 145),
      IntPoint(110, 140),
      IntPoint(95, 140),
      IntPoint(85, 142),
      IntPoint(75, 144),
    ],
  );

  // Right cheek polygon indices: [454, 323, 361, 345, 346, 347, 348, 349, 350, 357]
  setPoly(
    [454, 323, 361, 345, 346, 347, 348, 349, 350, 357],
    const [
      IntPoint(170, 145),
      IntPoint(175, 175),
      IntPoint(195, 195),
      IntPoint(225, 190),
      IntPoint(230, 165),
      IntPoint(225, 145),
      IntPoint(210, 140),
      IntPoint(195, 140),
      IntPoint(185, 142),
      IntPoint(175, 144),
    ],
  );

  // Forehead polygon indices: [10, 338, 297, 332, 284, 251, 389]
  setPoly(
    [10, 338, 297, 332, 284, 251, 389],
    const [
      IntPoint(110, 45),
      IntPoint(150, 40),
      IntPoint(190, 45),
      IntPoint(205, 75),
      IntPoint(190, 95),
      IntPoint(150, 100),
      IntPoint(100, 75),
    ],
  );

  // Nose polygon indices: [6, 197, 195, 5, 4, 45, 220, 218, 237, 1]
  setPoly(
    [6, 197, 195, 5, 4, 45, 220, 218, 237, 1],
    const [
      IntPoint(140, 110),
      IntPoint(160, 110),
      IntPoint(168, 145),
      IntPoint(165, 175),
      IntPoint(155, 185),
      IntPoint(145, 185),
      IntPoint(135, 175),
      IntPoint(132, 145),
      IntPoint(136, 125),
      IntPoint(150, 160),
    ],
  );

  // Left eye indices (far above cheeks so it doesn't mask them)
  setPoly(
    [33, 7, 163, 144, 145, 153, 154, 155, 133, 173],
    const [
      IntPoint(95, 112),
      IntPoint(105, 108),
      IntPoint(120, 112),
      IntPoint(115, 120),
      IntPoint(100, 120),
      IntPoint(98, 115),
      IntPoint(108, 110),
      IntPoint(118, 114),
      IntPoint(112, 118),
      IntPoint(102, 118),
    ],
  );

  // Right eye indices
  setPoly(
    [263, 249, 390, 373, 374, 380, 381, 382, 362, 398],
    const [
      IntPoint(180, 112),
      IntPoint(190, 108),
      IntPoint(205, 112),
      IntPoint(200, 120),
      IntPoint(185, 120),
      IntPoint(183, 115),
      IntPoint(193, 110),
      IntPoint(203, 114),
      IntPoint(197, 118),
      IntPoint(187, 118),
    ],
  );

  // Mouth indices cleanly below cheeks
  setPoly(
    [61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291, 308],
    const [
      IntPoint(125, 225),
      IntPoint(140, 220),
      IntPoint(160, 220),
      IntPoint(175, 225),
      IntPoint(175, 240),
      IntPoint(160, 245),
      IntPoint(140, 245),
      IntPoint(125, 240),
      IntPoint(130, 232),
      IntPoint(150, 230),
      IntPoint(170, 232),
      IntPoint(150, 238),
    ],
  );

  return points;
}

img.Image _solidFaceImage({
  int width = 300,
  int height = 300,
  required int r,
  required int g,
  required int b,
}) {
  final image = img.Image(width: width, height: height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      // Tiny deterministic 1-2 unit variation so variance filters stay realistic
      final jitter = ((x + y) % 3) - 1;
      image.setPixelRgb(
        x,
        y,
        (r + jitter).clamp(0, 255),
        (g + jitter).clamp(0, 255),
        (b + jitter).clamp(0, 255),
      );
    }
  }
  return image;
}

void main() {
  group('color_math', () {
    test(
      'rgbToLab converts black, white, neutral gray, and primary red accurately',
      () {
        final black = rgbToLab(0, 0, 0);
        expect(black.l, closeTo(0.0, 0.01));

        final white = rgbToLab(1, 1, 1);
        expect(white.l, closeTo(100.0, 0.05));
        expect(white.a.abs(), lessThan(0.5));
        expect(white.b.abs(), lessThan(0.5));

        final gray = rgbToLab(0.5, 0.5, 0.5);
        expect(gray.l, inInclusiveRange(50.0, 56.0));
        expect(gray.a.abs(), lessThan(0.5));
        expect(gray.b.abs(), lessThan(0.5));

        final red = rgbToLab(1, 0, 0);
        expect(red.a, greaterThan(70.0));
      },
    );

    test(
      'deltaE2000 satisfies identity, symmetry, and perceptual ordering',
      () {
        const c1 = LabColor(50.0, 2.6772, -79.7751);
        const c2 = LabColor(50.0, 0.0, -82.7485);
        const cFar = LabColor(85.0, 35.0, 40.0);

        expect(deltaE2000(c1, c1), closeTo(0.0, 1e-6));
        expect(deltaE2000(c1, c2), closeTo(deltaE2000(c2, c1), 1e-9));
        // Standard Sharma et al. CIEDE2000 test pair #1 (~2.0425)
        expect(deltaE2000(c1, c2), closeTo(2.0425, 0.01));
        expect(deltaE2000(c1, cFar), greaterThan(deltaE2000(c1, c2)));
      },
    );

    test('rgbToYCrCb returns clamped 0-255 values matching OpenCV formula', () {
      final black = rgbToYCrCb(0, 0, 0);
      expect(black, equals([0, 128, 128]));

      final white = rgbToYCrCb(255, 255, 255);
      expect(white, equals([255, 128, 128]));

      // Typical warm skin falls cleanly in skin YCrCb bounds
      final skin = rgbToYCrCb(215, 165, 130);
      expect(skin[0], inInclusiveRange(150, 200));
      expect(skin[1], inInclusiveRange(133, 175));
      expect(skin[2], inInclusiveRange(77, 130));
    });

    test(
      'rgbToHsvOpenCV maps R/G/B into OpenCV ranges H(0..179), S(0..255), V(0..255)',
      () {
        final red = rgbToHsvOpenCV(255, 0, 0);
        expect(red, equals([0, 255, 255]));

        final green = rgbToHsvOpenCV(0, 255, 0);
        expect(green[0], equals(60));
        expect(green[1], equals(255));

        final blue = rgbToHsvOpenCV(0, 0, 255);
        expect(blue[0], equals(120));
        expect(blue[1], equals(255));

        final gray = rgbToHsvOpenCV(128, 128, 128);
        expect(gray[1], equals(0));
        expect(gray[2], equals(128));
      },
    );
  });

  group('face_regions', () {
    test(
      'FaceRegion boundingBox and contains handle empty and square polygons',
      () {
        final empty = FaceRegion([]);
        expect(empty.boundingBox.width, equals(0));
        expect(empty.contains(5, 5), isFalse);

        final square = FaceRegion(const [
          IntPoint(10, 10),
          IntPoint(50, 10),
          IntPoint(50, 50),
          IntPoint(10, 50),
        ]);
        expect(square.boundingBox.left, equals(10));
        expect(square.boundingBox.right, equals(50));
        expect(square.contains(30, 30), isTrue);
        expect(square.contains(5, 30), isFalse);
        expect(square.contains(60, 60), isFalse);
      },
    );

    test('offsetPolygon dilates, erodes, and guards against inversion', () {
      final square = FaceRegion(const [
        IntPoint(100, 100),
        IntPoint(140, 100),
        IntPoint(140, 140),
        IntPoint(100, 140),
      ]);

      final dilated = offsetPolygon(square, 10.0);
      expect(dilated.boundingBox.width, greaterThan(square.boundingBox.width));

      final eroded = offsetPolygon(square, -5.0);
      expect(eroded.boundingBox.width, lessThan(square.boundingBox.width));

      // Extreme negative offset clamps scaleFactor >= 0.1 without crashing
      final extremeErode = offsetPolygon(square, -500.0);
      expect(extremeErode.points.length, equals(4));
    });

    test(
      'RegionExtractor requires 468 mesh points and extracts regions + exclusions',
      () {
        final incomplete = RegionExtractor(const [IntPoint(0, 0)]);
        expect(incomplete.getLeftCheek(), isNull);
        expect(incomplete.getRightCheek(), isNull);
        expect(incomplete.getForehead(0), isNull);
        expect(incomplete.getNose(), isNull);
        expect(incomplete.getEyes(), isEmpty);
        expect(incomplete.getExclusions(), isEmpty);

        final extractor = RegionExtractor(_buildSyntheticFaceMesh());
        expect(extractor.getLeftCheek(), isNotNull);
        expect(extractor.getRightCheek(), isNotNull);
        expect(extractor.getForehead(40), isNotNull);
        expect(extractor.getNose(), isNotNull);
        expect(extractor.getEyes().length, equals(2));
        expect(extractor.getExclusions().length, equals(5));
      },
    );
  });

  group('SkinClassifier', () {
    test(
      'returns safe neutral fallback when cheek pixel regions are empty',
      () {
        final image = _solidFaceImage(r: 200, g: 160, b: 130);
        final emptyExtractor = RegionExtractor(const []);

        final result = SkinClassifier.classify(image, emptyExtractor, 0);
        expect(result.tone, equals(5));
        expect(result.undertone, equals('Neutral'));
        expect(result.toneConfidence, equals(0.0));
      },
    );

    test('classifies fair warm skin portrait into light Monk tones (1-4)', () {
      final image = _solidFaceImage(r: 245, g: 222, b: 196);
      final extractor = RegionExtractor(_buildSyntheticFaceMesh());

      final result = SkinClassifier.classify(image, extractor, 40);
      expect(result.tone, inInclusiveRange(1, 4));
      expect(['Warm', 'Neutral', 'Cool'], contains(result.undertone));
      expect(result.toneConfidence, inInclusiveRange(0.0, 1.0));
      expect(result.utConfidence, inInclusiveRange(0.0, 1.0));
    });

    test('classifies medium skin portrait into mid Monk tones (4-7)', () {
      final image = _solidFaceImage(r: 185, g: 138, b: 105);
      final extractor = RegionExtractor(_buildSyntheticFaceMesh());

      final result = SkinClassifier.classify(image, extractor, 40);
      expect(result.tone, inInclusiveRange(4, 7));
      expect(['Warm', 'Neutral', 'Cool'], contains(result.undertone));
    });

    test('classifies deep skin portrait into deep Monk tones (7-10)', () {
      final image = _solidFaceImage(r: 92, g: 62, b: 48);
      final extractor = RegionExtractor(_buildSyntheticFaceMesh());

      final result = SkinClassifier.classify(image, extractor, 40);
      expect(result.tone, inInclusiveRange(7, 10));
      expect(['Warm', 'Neutral', 'Cool'], contains(result.undertone));
    });
  });
}
