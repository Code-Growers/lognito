import 'dart:convert';

import 'package:lognito/src/color/ansi_color.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/lognito.dart';

import '../../lognito.dart';

/// Credit to https://github.com/leisim/logger

/// Default implementation of [Formatter].
///
/// Outut looks like this:
/// ```
/// ┌──────────────────────────
/// │ Error info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Method stack history
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Log message
/// └──────────────────────────
/// ```

const Map<Level, AnsiColor> levelColors = <Level, AnsiColor>{
  Level.debug: AnsiColor.none(),
  Level.info: AnsiColor.fg(12),
  Level.warning: AnsiColor.fg(208),
  Level.error: AnsiColor.fg(196),
  Level.special: AnsiColor.fg(100),
};

const Map<Level, String> levelEmojis = <Level, String>{
  Level.debug: '🐛 ',
  Level.info: '💡 ',
  Level.warning: '⚠️ ',
  Level.error: '⛔ ',
  Level.special: '',
};

/// Matches a stacktrace line as generated on Android/iOS devices.
/// For example:
/// #1      Logger.log (package:logger/src/logger.dart:115:29)
final RegExp _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

/// Matches a stacktrace line as generated by Flutter web.
/// For example:
/// packages/logger/src/printers/pretty_printer.dart 91:37
final RegExp _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

const String topLeftCorner = '┌';
const String bottomLeftCorner = '└';
const String middleCorner = '├';
const String verticalLine = '│';
const String doubleDivider = '─';
const String singleDivider = '┄';

class PrettyFormatter extends Formatter {
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printEmojis;
  final bool printTime;
  DateTime _startTime;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  PrettyFormatter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printEmojis = true,
    this.printTime = false,
  }) {
    _startTime ??= DateTime.now();

    StringBuffer doubleDividerLine = StringBuffer();
    StringBuffer singleDividerLine = StringBuffer();
    for (int i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  @override
  void init() {}

  @override
  void dispose() {}

  @override
  List<String> format(LogEvent event) {
    String messageStr = _stringifyMessage(event.message);

    String stackTraceStr;
    if (event.level != Level.special) {
      if (event.stackTrace == null) {
        if (methodCount > 0) {
          stackTraceStr = _formatStackTrace(StackTrace.current, methodCount);
        }
      } else if (errorMethodCount > 0) {
        stackTraceStr = _formatStackTrace(event.stackTrace, errorMethodCount);
      }
    }

    String errorStr = event.error?.toString();

    String timeStr;
    if (printTime) {
      timeStr = _getTime();
    }

    return _formatAndPrint(
      event.level,
      messageStr,
      timeStr,
      errorStr,
      stackTraceStr,
    );
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  AnsiColor _getLevelColor(Level level) {
    if (colors) {
      return levelColors[level];
    } else {
      return AnsiColor.none();
    }
  }

  AnsiColor _getErrorColor(Level level) {
    if (colors) {
      return levelColors[Level.error].toBg();
    } else {
      return AnsiColor.none();
    }
  }

  String _formatStackTrace(StackTrace stackTrace, int methodCount) {
    List<String> lines = stackTrace.toString().split('\n');
    List<String> formatted = <String>[];
    int count = 0;
    for (String line in lines) {
      if (_discardDeviceStacktraceLine(line) ||
          _discardWebStacktraceLine(line)) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      if (++count == methodCount) {
        break;
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String _getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    DateTime now = DateTime.now();
    String h = _twoDigits(now.hour);
    String min = _twoDigits(now.minute);
    String sec = _twoDigits(now.second);
    String ms = _threeDigits(now.millisecond);
    String timeSinceStart = now.difference(_startTime).toString();
    return '$h:$min:$sec.$ms (+$timeSinceStart)';
  }

  bool _discardDeviceStacktraceLine(String line) {
    Match match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2).startsWith('package:logger');
  }

  bool _discardWebStacktraceLine(String line) {
    Match match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1).startsWith('packages/logger') ||
        match.group(1).startsWith('dart-sdk/lib');
  }

  String _getEmoji(Level level) {
    if (printEmojis) {
      return levelEmojis[level];
    } else {
      return '';
    }
  }

  List<String> _formatAndPrint(
    Level level,
    String message,
    String time,
    String error,
    String stacktrace,
  ) {
    // This code is non trivial and a type annotation here helps understanding.
    List<String> buffer = <String>[];
    AnsiColor color = _getLevelColor(level);
    buffer.add(color(_topBorder));

    if (error != null) {
      AnsiColor errorColor = _getErrorColor(level);
      for (String line in error.split('\n')) {
        buffer.add(
          color('$verticalLine ') +
              errorColor.resetForeground +
              errorColor(line) +
              errorColor.resetBackground,
        );
      }
      buffer.add(color(_middleBorder));
    }

    if (stacktrace != null) {
      for (String line in stacktrace.split('\n')) {
        buffer.add('$color$verticalLine $line');
      }
      buffer.add(color(_middleBorder));
    }

    if (time != null) {
      buffer..add(color('$verticalLine $time'))..add(color(_middleBorder));
    }

    String emoji = _getEmoji(level);
    for (String line in message.split('\n')) {
      buffer.add(color('$verticalLine $emoji$line'));
    }
    buffer.add(color(_bottomBorder));

    return buffer;
  }
}
