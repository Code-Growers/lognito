import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/pretty_formatter.dart';
import 'package:lognito/src/formatter/simple_formatter.dart';
import 'package:lognito/src/lognito.dart';

final infoEvent = LogEvent(Level.info, 'info', null, null, 'Logger');
final warningEvent = LogEvent(Level.warning, 'warning', null, null, 'Logger');
final debugEvent = LogEvent(Level.debug, 'debug', null, null, 'Logger');
final errorEvent = LogEvent(Level.error, 'error', null, null, 'Logger');
final specialEvent = LogEvent(Level.special, 'error', null, null, 'Logger');

final listEvent =
    LogEvent(Level.info, ['first item', 'second item'], null, null, 'Logger');
final mapEvent = LogEvent(
    Level.info, {'first': 'first', 'second': 'second'}, null, null, 'Logger');

void main() {
  group('Simple formatter', () {
    test('expect simple formatted messages by log level', () {
      final formatter = SimpleFormatter();
      expect(formatter.format(infoEvent),
          equals(['\x1B[38;5;12m[I]\x1B[0m  info']));
      expect(formatter.format(warningEvent),
          equals(['\x1B[38;5;208m[W]\x1B[0m  warning']));
      expect(formatter.format(debugEvent), equals(['[D]  debug']));
      expect(formatter.format(errorEvent),
          equals(['\x1B[38;5;196m[E]\x1B[0m  error']));

      expect(formatter.format(listEvent),
          equals(['\x1B[38;5;12m[I]\x1B[0m  ["first item","second item"]']));
      expect(
          formatter.format(mapEvent),
          equals([
            '\x1B[38;5;12m[I]\x1B[0m  {"first":"first","second":"second"}'
          ]));
    });

    test('expect simple formatted messages by log level with time', () {
      final formatter = SimpleFormatter(printTime: true);
      final now = DateFormat('dd.MM HH:mm').format(DateTime.now());
      expect(formatter.format(infoEvent),
          equals(['\x1B[38;5;12m[I]\x1B[0m TIME: $now info']));
      expect(formatter.format(warningEvent),
          equals(['\x1B[38;5;208m[W]\x1B[0m TIME: $now warning']));
      expect(formatter.format(debugEvent), equals(['[D] TIME: $now debug']));
      expect(formatter.format(errorEvent),
          equals(['\x1B[38;5;196m[E]\x1B[0m TIME: $now error']));

      expect(
          formatter.format(listEvent),
          equals([
            '\x1B[38;5;12m[I]\x1B[0m TIME: $now ["first item","second item"]'
          ]));
      expect(
          formatter.format(mapEvent),
          equals([
            '\x1B[38;5;12m[I]\x1B[0m TIME: $now {"first":"first","second":"second"}'
          ]));
    });

    test('expect simple formatted messages by log level logger label', () {
      final formatter = SimpleFormatter(printLoggerLabel: true);
      expect(formatter.format(infoEvent),
          equals(['\x1B[38;5;12m[I]\x1B[0m Logger info']));
      expect(formatter.format(warningEvent),
          equals(['\x1B[38;5;208m[W]\x1B[0m Logger warning']));
      expect(formatter.format(debugEvent), equals(['[D] Logger debug']));
      expect(formatter.format(errorEvent),
          equals(['\x1B[38;5;196m[E]\x1B[0m Logger error']));

      expect(
          formatter.format(listEvent),
          equals(
              ['\x1B[38;5;12m[I]\x1B[0m Logger ["first item","second item"]']));
      expect(
          formatter.format(mapEvent),
          equals([
            '\x1B[38;5;12m[I]\x1B[0m Logger {"first":"first","second":"second"}'
          ]));
    });
  });

  group('Pretty formatter', () {
    test('expect pretty formatted messages', () {
      final formatter = PrettyFormatter(methodCount: 0, lineLength: 50);
      expect(
          formatter.format(infoEvent),
          equals([
            '\x1B[38;5;12m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;12m│ 💡 info\x1B[0m',
            '\x1B[38;5;12m└─────────────────────────────────────────────────\x1B[0m'
          ]));
      expect(
          formatter.format(warningEvent),
          equals([
            '\x1B[38;5;208m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;208m│ ⚠️ warning\x1B[0m',
            '\x1B[38;5;208m└─────────────────────────────────────────────────\x1B[0m'
          ]));
      expect(
          formatter.format(debugEvent),
          equals([
            '┌─────────────────────────────────────────────────',
            '│ 🐛 debug',
            '└─────────────────────────────────────────────────'
          ]));
      expect(
          formatter.format(errorEvent),
          equals([
            '\x1B[38;5;196m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;196m│ ⛔ error\x1B[0m',
            '\x1B[38;5;196m└─────────────────────────────────────────────────\x1B[0m'
          ]));

      expect(
          formatter.format(listEvent),
          equals([
            '\x1B[38;5;12m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;12m│ 💡 [\x1B[0m',
            '\x1B[38;5;12m│ 💡   "first item",\x1B[0m',
            '\x1B[38;5;12m│ 💡   "second item"\x1B[0m',
            '\x1B[38;5;12m│ 💡 ]\x1B[0m',
            '\x1B[38;5;12m└─────────────────────────────────────────────────\x1B[0m'
          ]));
      expect(
          formatter.format(mapEvent),
          equals([
            '\x1B[38;5;12m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;12m│ 💡 {\x1B[0m',
            '\x1B[38;5;12m│ 💡   "first": "first",\x1B[0m',
            '\x1B[38;5;12m│ 💡   "second": "second"\x1B[0m',
            '\x1B[38;5;12m│ 💡 }\x1B[0m',
            '\x1B[38;5;12m└─────────────────────────────────────────────────\x1B[0m'
          ]));
    });
    test('expect pretty formatted messages with stackTrace', () {
      final formatter = PrettyFormatter(methodCount: 1, lineLength: 50);
      expect(
          formatter.format(infoEvent),
          equals([
            '\x1B[38;5;12m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;12m│ #0   PrettyFormatter.format (package:lognito/src/formatter/pretty_formatter.dart:105:56)',
            '\x1B[38;5;12m├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄\x1B[0m',
            '\x1B[38;5;12m│ 💡 info\x1B[0m',
            '\x1B[38;5;12m└─────────────────────────────────────────────────\x1B[0m'
          ]));
      expect(
          formatter.format(specialEvent),
          equals([
            '\x1B[38;5;100m┌─────────────────────────────────────────────────\x1B[0m',
            '\x1B[38;5;100m│ error\x1B[0m',
            '\x1B[38;5;100m└─────────────────────────────────────────────────\x1B[0m'
          ]));
    });
  });
}
