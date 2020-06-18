import 'package:flutter_test/flutter_test.dart';
import 'package:lognito/src/buffer/simple_buffer.dart';
import 'package:lognito/src/lognito.dart';

import 'mocks/output_mock.dart';

void main() {
  group('Lognito instances', () {
    test('Instances after init must be singleton', () {
      final firstInstance = Lognito.init();
      final secondInstance = Lognito();
      expect(firstInstance, equals(secondInstance));
    });

    test('Constructor withLabel returns same instance with different label',
            () {
          final firstInstance = Lognito.init();
          final secondInstance = Lognito.withLabel('Test', level: Level.error);
          expect(firstInstance, equals(secondInstance));
          expect(
              firstInstance.toString(),
              isNot(equals(secondInstance.toString())));
        });

    test('Test if output is called',
            () {
              final output = CallCountingOutput();
          final firstInstance = Lognito.init(
              buffer: SimpleBuffer([output]));
          firstInstance.i('test');
          expect(
              output.count, equals(1));
        });
  });
}
