import 'package:lognito/src/buffer/buffer.dart';
import 'package:lognito/src/buffer/repeating_buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/filter/development_filter.dart';
import 'package:lognito/src/filter/filter.dart';
import 'package:lognito/src/formatter/pretty_formatter.dart';
import 'package:lognito/src/output/console_output.dart';
import 'package:lognito/src/output/output.dart';

/// [Level]s to control logging output. Logging can be enabled to include all
/// levels above certain [Level].
enum Level {
  debug,
  info,
  warning,
  error,

  // Special level, doesn't include stacktrace
  special,
}

/// Use instances of logger to send log messages to the [Client].
class Lognito {
  /// The current logging level of the app.
  ///
  /// All logs with levels below this level will be omitted.

  static final _defaultOutputs = [ConsoleOutput(formatter: PrettyFormatter())];
  static final _defaultBuffer = [RepeatingBuffer(_defaultOutputs)];
  static Lognito _singleton;
  final Filter _filter;
  final List<Buffer> _buffers;
  final String _label;
  bool _active = true;

  /// Create a new instance of Logger.
  ///
  /// You can provide a custom [printer], [filter] and [output]. Otherwise the
  /// defaults: [PrettyPrinter], [DevelopmentFilter] and [ConsoleOutput] will be
  /// used.
  factory Lognito.init({
    Filter filter,
    Output output,
    Buffer buffer,
    List<Buffer> buffers,
    Level level,
    String label,
  }) {
    assert(buffer == null || buffers == null,
        'Use one of parameters, either one buffer, or list of buffers');
    final singleton = Lognito._internal(
        filter ?? DevelopmentFilter(level ?? Level.debug),
        buffer != null ? [buffer] : (buffers ?? _defaultBuffer),
        label ?? 'Root logger');
    _singleton = singleton;
    return singleton;
  }

  Lognito._internal(this._filter, this._buffers, this._label) {
    _filter.init();
    _buffers.map((o) => o.init());
  }

  /// Create new instance of Lognito with custom label and log [Level],
  /// but with same instance of buffer and outputs
  factory Lognito.withLabel(String label, {Level level}) {
    return _singleton._copyWithFilterLevelAndLabel(label, level);
  }

  /// Return singleton instance of [Lognito] create by calling [Lognito.init]
  factory Lognito() {
    assert(_singleton != null, 'You must init Lognito first');
    return _singleton;
  }

  Lognito _copyWithFilterLevelAndLabel(String label, Level level) {
    return Lognito._internal(
        this._filter.copyWithLevel(level), _buffers, label);
  }

  /// Log a message at level [Level.debug].
  void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Log a message at level [Level.debug].
  void debug(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.debug, message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Log a message at level [Level.info].
  void info(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.info, message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Log a message at level [Level.warning].
  void warning(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.warning, message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Log a message at level [Level.error].
  void error(dynamic message, [dynamic error, StackTrace stackTrace]) {
    log(Level.error, message, error, stackTrace);
  }

  /// Special log for bloc events [Level.special].
  void sp(dynamic message) {
    log(Level.special, message);
  }

  /// Special log for bloc events [Level.special].
  void special(dynamic message) {
    log(Level.special, message);
  }

  /// Log a message with [level].
  void log(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]) {
    if (!_active) {
      throw ArgumentError('Logger has already been closed.');
    } else if (error != null && error is StackTrace) {
      throw ArgumentError('Error parameter cannot take a StackTrace!');
    }
    var logEvent = LogEvent(level, message, error, stackTrace, _label);
    if (_filter.shouldLog(logEvent) || level == Level.special) {
      _buffers.forEach((o) {
        o.addToBuffer(logEvent);
      });
    }
  }

  List<Future<void>> flush() {
    return _buffers?.map((o) => o.flush());
  }

  /// Closes the logger and releases all resources.
  void close() {
    _active = false;
    _filter.dispose();
    _buffers?.map((o) => o.dispose());
  }

  bool operator ==(Object object) {
    if (object is Lognito) {
      if (this._buffers.length == object._buffers.length) {
        return !this
            ._buffers
            .asMap()
            .map((key, value) => MapEntry(key, object._buffers[key] == value))
            .values
            .toList()
            .contains(false);
      }
    }
    return false;
  }

  @override
  int get hashCode => _buffers.hashCode;

  @override
  String toString() {
    return 'Lognito{_label: $_label}';
  }
}
