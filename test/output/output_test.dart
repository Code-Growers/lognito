import 'package:flutter_test/flutter_test.dart';
import 'package:lognito/src/buffer/simple_buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/simple_formatter.dart';
import 'package:lognito/src/lognito.dart';
import 'package:lognito/src/output/console_output.dart';
import 'package:lognito/src/output/debug_printer_output.dart';

final event = LogEvent(Level.info, 'test', null, null, 'fabricated event');

void main() {
  group('Console output', () {
    test('expect to print', () async {
      final buffer =
          SimpleBuffer([ConsoleOutput(formatter: SimpleFormatter())]);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.events.isEmpty, equals(true));
    });
    test('expect to print', () async {
      final buffer =
          SimpleBuffer([DebugPrinterOutput(formatter: SimpleFormatter())]);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.events.isEmpty, equals(true));
    });
  });
}
