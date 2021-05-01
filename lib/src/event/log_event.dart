import 'package:lognito/src/lognito.dart';

class LogEvent {
  final Level level;
  final String? loggerLabel;
  final dynamic message;
  final dynamic error;
  final StackTrace? stackTrace;

  LogEvent(this.level, this.message, this.error, this.stackTrace, this.loggerLabel);
}