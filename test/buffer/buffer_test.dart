import 'package:flutter_test/flutter_test.dart';
import 'package:lognito/src/buffer/level_delayed_buffer.dart';
import 'package:lognito/src/buffer/repeating_buffer.dart';
import 'package:lognito/src/buffer/simple_buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/lognito.dart';

import '../mocks/output_mock.dart';

final event = LogEvent(Level.info, 'test', 'error',
    StackTrace.fromString('stackTraceString'), 'fabricated event');

void main() {
  group('RepeatingBuffer', () {
    test('expect pending events to be empty, single output', () async {
      final buffer = RepeatingBuffer([AlwaysOutput(true)]);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(true));
    });

    test('expect pending events to be empty, multiple outputs, single event',
        () async {
      final buffer = RepeatingBuffer(
          [AlwaysOutput(true), AlwaysOutput(true), AlwaysOutput(true)]);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(true));
    });

    test(
        'expect pending events not to be empty, multiple outputs, multiple events',
        () async {
      final buffer = RepeatingBuffer(
          [AlwaysOutput(true), AlwaysOutput(true), AlwaysOutput(false)]);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(false));
    });

    test('expect pending events to be empty after repeatAfter is called',
        () async {
      final repeatAfter = Duration(milliseconds: 10);
      final buffer =
          RepeatingBuffer([SwappingOutput(false)], repeatAfter: repeatAfter);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(false));
      await Future.delayed(repeatAfter);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(true));
    });
  });

  group('LevelDelayedBuffer', () {
    test('expect pending events to be empty', () async {
      final buffer =
          LevelDelayedBuffer([AlwaysOutput(true)], triggerLevel: Level.debug);
      buffer.addToBuffer(event);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(true));
    });

    test('expect pending events not to be empty', () async {
      final buffer =
          LevelDelayedBuffer([AlwaysOutput(true)], triggerLevel: Level.error);
      buffer.addToBuffer(event);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(false));
    });

    test('expect pending events to be empty, triggered by error event', () async {
      final buffer =
          LevelDelayedBuffer([AlwaysOutput(true)], triggerLevel: Level.error);
      buffer.addToBuffer(event);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.length, equals(2));
      buffer.addToBuffer(LogEvent(Level.error, 'test', 'error', null, null));
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect(buffer.pendingEvents.isEmpty, equals(true));
    });
  });

  group('SimpleBuffer', () {
    test('expect log to be call twice', () async {
      final buffer = SimpleBuffer([CallCountingOutput()]);
      buffer.addToBuffer(event);
      buffer.addToBuffer(event);
      // awaits because flush is asynchronous
      await Future.delayed(Duration(milliseconds: 1));
      expect((buffer.outputs[0] as CallCountingOutput).count, equals(2));
    });
  });
}
