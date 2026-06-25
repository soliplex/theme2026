import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';

/// The white-label brand theme for this app: a neutral grey-purple palette,
/// Inter for body/headline/title text, Oswald for the display roles, Squada
/// One for the brand name, and square corners.
const BrandTheme themeTemplateBrand = BrandTheme(
  light: _lightColors,
  dark: _darkColors,
  typography: _typography,
  shape: BrandShape.square(),
);

const BrandColorScheme _lightColors = BrandColorScheme(
  primary: Color(0xFF6B6D7B),
  secondary: Color(0xFF8E8698),
  background: Color(0xFFFAFAFA),
  foreground: Color(0xFF1A1A1E),
  muted: Color(0xFFE4E4E8),
  mutedForeground: Color(0xFF6E6E78),
  border: Color(0xFFC8C8CE),
  tertiary: Color(0xFF7B7486),
  error: Color(0xFFBA1A1A),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onTertiary: Color(0xFFFFFFFF),
  onError: Color(0xFFFFFFFF),
);

const BrandColorScheme _darkColors = BrandColorScheme(
  primary: Color(0xFFB8B9C6),
  secondary: Color(0xFFCDC5D4),
  background: Color(0xFF1A1A1D),
  foreground: Color(0xFFE5E5E8),
  muted: Color(0xFF2E2E33),
  mutedForeground: Color(0xFF9A9AA2),
  border: Color(0xFF48484F),
  tertiary: Color(0xFFB0A8BA),
  error: Color(0xFFFFB4AB),
  onPrimary: Color(0xFF1A1A1E),
  onSecondary: Color(0xFF1A1A1E),
  onTertiary: Color(0xFF1A1A1E),
  onError: Color(0xFF690005),
);

// Oswald (the display family) styles the display roles. The headline and
// title roles are routed back to Inter, and Squada One is the brand-name
// family. Each role carries its own size/weight/height/spacing.
const BrandTypography _typography = BrandTypography(
  bodyFamily: 'Inter',
  displayFamily: 'Oswald',
  brandFamily: 'Squada One',
  displayLarge: TypeScaleOverride(
    fontSize: 48,
    height: 1.2,
    letterSpacing: -0.25,
  ),
  displayMedium: TypeScaleOverride(fontSize: 32, height: 1.8, letterSpacing: 0),
  displaySmall: TypeScaleOverride(fontSize: 28, height: 2.15, letterSpacing: 0),
  headlineLarge: TypeScaleOverride(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.455,
    letterSpacing: 0,
    family: BrandFontRole.body,
  ),
  headlineMedium: TypeScaleOverride(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 2,
    letterSpacing: 0,
    family: BrandFontRole.body,
  ),
  headlineSmall: TypeScaleOverride(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 2,
    letterSpacing: 0,
    family: BrandFontRole.body,
  ),
  titleLarge: TypeScaleOverride(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
    family: BrandFontRole.body,
  ),
  titleMedium: TypeScaleOverride(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.8,
    letterSpacing: 0.15,
    family: BrandFontRole.body,
  ),
  titleSmall: TypeScaleOverride(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    family: BrandFontRole.body,
  ),
  bodyLarge: TypeScaleOverride(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.5,
  ),
  bodyMedium: TypeScaleOverride(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.25,
  ),
  bodySmall: TypeScaleOverride(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0.4,
  ),
  labelLarge: TypeScaleOverride(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  ),
  labelMedium: TypeScaleOverride(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  ),
  labelSmall: TypeScaleOverride(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  ),
);

/// Resolves font families for the brand, serving bundled families from local
/// assets and fetching everything else through `google_fonts`.
///
/// Bundled families resolve verbatim so Flutter's asset machinery handles them
/// offline. Any other family is registered and lazily downloaded by
/// `google_fonts`; the family name it registers under is returned so the text
/// renders once the download completes. A non-bundled family on a device that
/// has never been online falls back to the bundled body font.
class GoogleFontResolver extends FontResolver {
  const GoogleFontResolver();

  static const Set<String> _bundledFamilies = {'Inter'};

  @override
  ResolvedFont resolve(String family, List<String> fallbacks) {
    if (_bundledFamilies.contains(family)) {
      return ResolvedFont(fontFamily: family, fontFamilyFallback: fallbacks);
    }
    final resolved = GoogleFonts.getFont(family);
    return ResolvedFont(
      fontFamily: resolved.fontFamily,
      fontFamilyFallback: fallbacks,
    );
  }
}
