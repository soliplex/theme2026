import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';
import 'package:theme_template/theme.dart';

void main() {
  // Lowering with the bundled resolver keeps these tests offline and free of
  // google_fonts side effects: 'Inter' resolves verbatim from the bundle.
  ThemeData lower(Brightness brightness) =>
      lowerBrandTheme(coopBrand, brightness);

  group('coopBrand light palette', () {
    final theme = lower(Brightness.light);

    test('maps the brand colors onto the color scheme', () {
      expect(theme.colorScheme.primary, const Color(0xFF0A7AFF));
      expect(theme.colorScheme.secondary, const Color(0xFF2B1F65));
      expect(theme.colorScheme.tertiary, const Color(0xFFFF5934));
      expect(theme.colorScheme.surface, const Color(0xFFFFFFFF));
      expect(theme.colorScheme.onSurface, const Color(0xFF0E121C));
      expect(theme.colorScheme.error, const Color(0xFFBA1A1A));
    });
  });

  group('coopBrand dark palette', () {
    final theme = lower(Brightness.dark);

    test('maps the brand colors onto the color scheme', () {
      expect(theme.colorScheme.primary, const Color(0xFF0A7AFF));
      expect(theme.colorScheme.secondary, const Color(0xFF663399));
      expect(theme.colorScheme.tertiary, const Color(0xFFFF5934));
      expect(theme.colorScheme.surface, const Color(0xFF1D1F23));
      expect(theme.colorScheme.onSurface, const Color(0xFFDFDFE6));
      expect(theme.colorScheme.error, const Color(0xFFFFB4AB));
    });
  });

  group('coopBrand contrast', () {
    double contrastRatio(Color a, Color b) {
      final la = a.computeLuminance();
      final lb = b.computeLuminance();
      final hi = math.max(la, lb);
      final lo = math.min(la, lb);
      return (hi + 0.05) / (lo + 0.05);
    }

    // Both brand schemes set every slot; the `!`s below are on the fields the
    // type still declares nullable.
    final schemes = <String, BrandColorScheme>{
      'light': coopBrand.light,
      'dark': coopBrand.dark,
    };

    for (final entry in schemes.entries) {
      test('${entry.key} scheme clears WCAG contrast floors', () {
        final scheme = entry.value;

        expect(
          contrastRatio(scheme.foreground, scheme.background),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(scheme.link!, scheme.background),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(scheme.onSecondary!, scheme.secondary),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(scheme.onTertiary!, scheme.tertiary!),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(scheme.onError!, scheme.error!),
          greaterThanOrEqualTo(4.5),
        );
        // De-emphasized text rides the WCAG UI/large-text 3:1 floor, matching
        // the library's own muted-foreground floor.
        expect(
          contrastRatio(scheme.mutedForeground, scheme.muted),
          greaterThanOrEqualTo(3.0),
        );
        // Recorded brand exception: primary fills keep the exact brand blue.
        // White-on-blue is 4.01:1, which clears only the WCAG large-text/UI
        // 3:1 bar. Accepted because button labels are bold labelLarge.
        expect(
          contrastRatio(scheme.onPrimary!, scheme.primary),
          greaterThanOrEqualTo(3.0),
        );
      });
    }
  });

  group('coopBrand shape', () {
    test('uses square (zero-radius) corners', () {
      final shape = lower(Brightness.light).cardTheme.shape;
      expect(shape, isA<RoundedRectangleBorder>());
      expect((shape as RoundedRectangleBorder).borderRadius, BorderRadius.zero);
    });
  });

  group('coopBrand typography', () {
    final textTheme = lower(Brightness.light).textTheme;

    test('every role uses Inter, the single brand grotesque', () {
      expect(textTheme.displayLarge?.fontFamily, 'Inter');
      expect(textTheme.headlineLarge?.fontFamily, 'Inter');
      expect(textTheme.titleLarge?.fontFamily, 'Inter');
      expect(textTheme.bodyMedium?.fontFamily, 'Inter');
      expect(textTheme.labelMedium?.fontFamily, 'Inter');
    });

    test('applies the full per-role type scale', () {
      expect(textTheme.displayLarge?.fontSize, 48);
      expect(textTheme.displayLarge?.fontWeight, FontWeight.w800);
      expect(textTheme.displayLarge?.letterSpacing, -1);
      expect(textTheme.headlineLarge?.fontSize, 28);
      expect(textTheme.headlineLarge?.fontWeight, FontWeight.w700);
      expect(textTheme.titleLarge?.fontSize, 18);
      expect(textTheme.titleLarge?.fontWeight, FontWeight.w700);
      expect(textTheme.titleSmall?.fontSize, 14);
      expect(textTheme.titleSmall?.fontWeight, FontWeight.w600);
      expect(textTheme.bodyLarge?.fontSize, 16);
      expect(textTheme.labelLarge?.fontSize, 14);
    });

    test('label roles are tracked typographic blocks', () {
      expect(textTheme.labelMedium?.fontWeight, FontWeight.w700);
      expect(textTheme.labelMedium?.letterSpacing, 1);
      expect(textTheme.labelSmall?.letterSpacing, 1);
    });

    test('uses Inter for the brand-name family', () {
      expect(coopBrand.typography.brandFamily, 'Inter');
    });
  });

  group('GoogleFontResolver', () {
    test('resolves bundled families verbatim without fetching', () {
      const resolver = GoogleFontResolver();
      final resolved = resolver.resolve('Inter', const ['Roboto']);
      expect(resolved.fontFamily, 'Inter');
      expect(resolved.fontFamilyFallback, const ['Roboto']);
    });

    test('is a FontResolver', () {
      expect(const GoogleFontResolver(), isA<FontResolver>());
    });
  });
}
