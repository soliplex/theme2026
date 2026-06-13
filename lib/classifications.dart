import 'package:flutter/material.dart';
import 'package:soliplex_frontend/soliplex_frontend.dart';

/// Example sensitivity markings, ordered least → most restrictive.
final demoClassifications = ClassificationTheme(
  defaultId: 'internal',
  levels: const [
    ClassificationLevel(
      id: 'public',
      label: 'PUBLIC',
      background: Color(0xFF2E7D32),
      foreground: Colors.white,
    ),
    ClassificationLevel(
      id: 'internal',
      label: 'INTERNAL',
      background: Color(0xFF1565C0),
      foreground: Colors.white,
    ),
    ClassificationLevel(
      id: 'confidential',
      label: 'CONFIDENTIAL',
      background: Color(0xFFE65100),
      foreground: Colors.white,
    ),
    ClassificationLevel(
      id: 'restricted',
      label: 'RESTRICTED',
      background: Color(0xFFB71C1C),
      foreground: Colors.white,
    ),
  ],
);
