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
  static final levelPrefixes = {
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
  };

  static final levelColors = {
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
    DateFormat dateFormat,
  }) : this.dateFormat = dateFormat ?? DateFormat('dd.MM HH:mm');

  @override
  List<String> format(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${dateFormat.format(DateTime.now())}' : '';
    return [
      '${_labelFor(event.level)} ${printLoggerLabel ? event.loggerLabel : ''}$timeStr $messageStr$errorStr'
    ];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level];
    var color = levelColors[level];

    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
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
