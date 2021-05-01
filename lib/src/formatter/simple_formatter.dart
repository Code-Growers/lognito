import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:lognito/src/color/ansi_color.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/lognito.dart';

/// Credit to https://github.com/leisim/logger

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class SimpleFormatter extends Formatter {
  static final Map<Level, String> levelPrefixes = <Level, String>{
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
  };

  static final Map<Level, AnsiColor> levelColors = <Level, AnsiColor>{
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
  };

  final bool printTime;
  final bool colors;
  final bool printLoggerLabel;
  final DateFormat dateFormat;

  SimpleFormatter({
    this.printTime = false,
    this.colors = true,
    this.printLoggerLabel = false,
    DateFormat? dateFormat,
  }) : this.dateFormat = dateFormat ?? DateFormat('dd.MM HH:mm');

  @override
  List<String> format(LogEvent event) {
    String messageStr = _stringifyMessage(event.message);
    String errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    String timeStr =
        printTime ? 'TIME: ${dateFormat.format(DateTime.now())}' : '';
    return <String>[
      '${_labelFor(event.level)} ${printLoggerLabel ? event.loggerLabel : ''}$timeStr $messageStr$errorStr'
    ];
  }

  String? _labelFor(Level level) {
    String? prefix = levelPrefixes[level];
    AnsiColor? color = levelColors[level];

    return colors ? color!(prefix!) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      JsonEncoder encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  @override
  void dispose() {}

  @override
  void init() {}
}
