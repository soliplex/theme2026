import 'package:flutter_test/flutter_test.dart';
import 'package:theme_template/classifications.dart';
import 'package:theme_template/consent_notice.dart';

void main() {
  group('demoClassifications', () {
    test('default id resolves to a defined level', () {
      final ids = demoClassifications.levels.map((level) => level.id);
      expect(ids, contains(demoClassifications.defaultId));
    });

    test('every level has a non-empty id and label', () {
      for (final level in demoClassifications.levels) {
        expect(level.id, isNotEmpty);
        expect(level.label, isNotEmpty);
      }
    });
  });

  group('demoConsentNotice', () {
    test('has a title, body, and acknowledgment label', () {
      expect(demoConsentNotice.title, isNotEmpty);
      expect(demoConsentNotice.body, isNotEmpty);
      expect(demoConsentNotice.acknowledgmentLabel, isNotEmpty);
    });
  });
}
