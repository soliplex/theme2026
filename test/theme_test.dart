import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';
import 'package:theme_template/theme.dart';

void main() {
  // Lowering with the bundled resolver keeps these tests offline and free of
  // google_fonts side effects: both 'Inter' and 'Oswald' resolve verbatim.
  ThemeData lower(Brightness brightness) =>
      lowerBrandTheme(themeTemplateBrand, brightness);

  group('themeTemplateBrand light palette', () {
    final theme = lower(Brightness.light);

    test('maps the brand colors onto the color scheme', () {
      expect(theme.colorScheme.primary, const Color(0xFF6B6D7B));
      expect(theme.colorScheme.secondary, const Color(0xFF8E8698));
      expect(theme.colorScheme.tertiary, const Color(0xFF7B7486));
      expect(theme.colorScheme.surface, const Color(0xFFFAFAFA));
      expect(theme.colorScheme.onSurface, const Color(0xFF1A1A1E));
      expect(theme.colorScheme.error, const Color(0xFFBA1A1A));
    });
  });

  group('themeTemplateBrand dark palette', () {
    final theme = lower(Brightness.dark);

    test('maps the brand colors onto the color scheme', () {
      expect(theme.colorScheme.primary, const Color(0xFFB8B9C6));
      expect(theme.colorScheme.secondary, const Color(0xFFCDC5D4));
      expect(theme.colorScheme.tertiary, const Color(0xFFB0A8BA));
      expect(theme.colorScheme.surface, const Color(0xFF1A1A1D));
      expect(theme.colorScheme.onSurface, const Color(0xFFE5E5E8));
      expect(theme.colorScheme.error, const Color(0xFFFFB4AB));
    });
  });

  group('themeTemplateBrand shape', () {
    test('uses square (zero-radius) corners', () {
      final shape = lower(Brightness.light).cardTheme.shape;
      expect(shape, isA<RoundedRectangleBorder>());
      expect((shape as RoundedRectangleBorder).borderRadius, BorderRadius.zero);
    });
  });

  group('themeTemplateBrand typography', () {
    final textTheme = lower(Brightness.light).textTheme;

    test('body roles use Inter, display/title roles use Oswald', () {
      expect(textTheme.bodyMedium?.fontFamily, 'Inter');
      expect(textTheme.titleLarge?.fontFamily, 'Oswald');
    });

    test('applies the ported per-role type-scale overrides', () {
      // titleSmall defaults to 16 in the design system; PR #75 set it to 14.
      expect(textTheme.titleSmall?.fontSize, 14);
      expect(textTheme.titleSmall?.fontWeight, FontWeight.w600);
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
