import 'package:flutter_test/flutter_test.dart';
import 'package:lognito/src/lognito.dart';
import 'package:lognito/src/utils/level_utils.dart';

void main() {
  group('Levels', () {
    test('expect levels to match indexes', () {
      expect(getLevelInt(Level.debug), equals(0));
      expect(getLevelInt(Level.info), equals(1));
      expect(getLevelInt(Level.warning), equals(2));
      expect(getLevelInt(Level.error), equals(3));
    });
  });
}
