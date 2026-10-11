import 'package:flutter_test/flutter_test.dart';
import 'package:app_github/src/common/utils/formatters.dart';

void main() {
  group('compactNumber', () {
    test('formats values', () {
      expect(Formatters.compactNumber(999), '999');
      expect(Formatters.compactNumber(1000), '1k');
      expect(Formatters.compactNumber(1540), '1.5k');
      expect(Formatters.compactNumber(2300000), '2.3m');
    });
  });

  group('relativeDate', () {
    final now = DateTime(2026, 10, 11, 12);

    test('formats ranges', () {
      expect(Formatters.relativeDate(null), '');
      expect(
        Formatters.relativeDate(
          now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
        'Updated 5m ago',
      );
      expect(
        Formatters.relativeDate(
          now.subtract(const Duration(hours: 3)),
          now: now,
        ),
        'Updated 3h ago',
      );
      expect(
        Formatters.relativeDate(
          now.subtract(const Duration(days: 2)),
          now: now,
        ),
        'Updated 2d ago',
      );
      expect(
        Formatters.relativeDate(
          now.subtract(const Duration(days: 65)),
          now: now,
        ),
        'Updated 2mo ago',
      );
      expect(
        Formatters.relativeDate(
          now.subtract(const Duration(days: 800)),
          now: now,
        ),
        'Updated 2y ago',
      );
    });
  });
}
