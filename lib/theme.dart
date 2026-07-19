import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';

/// The CO-OP brand theme: a flat, Bauhaus-inspired design language. Blue is the
/// brand/action color, deep purple the structural secondary, orange the
/// energetic accent. Inter throughout, hairline borders, and square corners —
/// the library renders the flat, zero-elevation, hairline-ruled components once
/// it is handed [BrandShape.square] and the hairline [BrandColorScheme.border].
const BrandTheme coopBrand = BrandTheme(
  light: _lightColors,
  dark: _darkColors,
  typography: _typography,
  shape: BrandShape.square(),
);

const BrandColorScheme _lightColors = BrandColorScheme(
  primary: Color(0xFF0A7AFF), // brand blue: actions / links
  secondary: Color(0xFF2B1F65), // deep purple: headers / accents
  tertiary: Color(0xFFFF5934), // orange: energetic accent
  background: Color(0xFFFFFFFF), // white page + surface
  foreground: Color(0xFF0E121C), // near-black primary text
  muted: Color(0xFFDFDFE6), // light gray secondary container
  mutedForeground: Color(0xFF555F78), // mid gray
  border: Color(0xFFD2D1E0), // hairline
  link: Color(0xFF0A6EE6), // AA link blue (4.79:1 on white)
  error: Color(0xFFBA1A1A), // semantic red (orange reserved for accent)
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onTertiary: Color(0xFF0E121C), // near-black on orange clears WCAG AA
  onError: Color(0xFFFFFFFF),
);

const BrandColorScheme _darkColors = BrandColorScheme(
  primary: Color(0xFF0A7AFF), // brand blue holds on dark
  secondary: Color(0xFF663399), // lifted medium purple
  tertiary: Color(0xFFFF5934), // orange accent
  background: Color(0xFF1D1F23), // near-black
  foreground: Color(0xFFDFDFE6), // light gray text
  muted: Color(0xFF2C2E33), // dark gray surface
  mutedForeground: Color(0xFF8A93A8), // neutral mid gray
  border: Color(0xFF2C2E33), // dark hairline
  link: Color(0xFF2E8BFF), // AA link blue (4.91:1 on bg)
  error: Color(0xFFFFB4AB), // semantic red (dark)
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onTertiary: Color(0xFF0E121C),
  onError: Color(0xFF690005),
);

// CO-OP is a single geometric grotesque: Inter for every role. Headings carry
// heavy weights and tight (negative) tracking; body stays restrained; the label
// roles are tracked uppercase typographic blocks (labelMedium drives the
// library's badge style — the text is uppercased at the call site).
const BrandTypography _typography = BrandTypography(
  bodyFamily: 'Inter',
  displayFamily: 'Inter',
  brandFamily: 'Inter',
  displayLarge: TypeScaleOverride(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 1.05,
    letterSpacing: -1,
  ),
  displayMedium: TypeScaleOverride(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
  ),
  displaySmall: TypeScaleOverride(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.4,
  ),
  headlineLarge: TypeScaleOverride(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.3,
  ),
  headlineMedium: TypeScaleOverride(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  ),
  headlineSmall: TypeScaleOverride(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.1,
  ),
  titleLarge: TypeScaleOverride(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  ),
  titleMedium: TypeScaleOverride(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
  ),
  titleSmall: TypeScaleOverride(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
  ),
  bodyLarge: TypeScaleOverride(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  ),
  bodyMedium: TypeScaleOverride(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  ),
  bodySmall: TypeScaleOverride(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.1,
  ),
  labelLarge: TypeScaleOverride(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.2,
  ),
  labelMedium: TypeScaleOverride(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1,
  ),
  labelSmall: TypeScaleOverride(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 1,
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
