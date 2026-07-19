import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';

import 'classifications.dart';
import 'consent_notice.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final callbackParams = CallbackParamsCapture.captureNow();
  clearCallbackUrl();
  final config = await standard(
    identity: AppIdentity(
      appName: 'Theme Template',
      logoLight: SvgPicture.asset(
        'assets/branding/theme_template/logo.svg',
        width: 64,
        height: 64,
      ),
      logoDark: SvgPicture.asset(
        'assets/branding/theme_template/logo-dark.svg',
        width: 64,
        height: 64,
      ),
    ),
    theme: coopBrand,
    fontResolver: const GoogleFontResolver(),
    classifications: demoClassifications,
    redirectScheme: 'dev.soliplex.theme',
    defaultBackendUrl: 'https://api.example.com',
    consentNotice: demoConsentNotice,
    callbackParams: callbackParams,
  );
  runSoliplexShell(config);
}
