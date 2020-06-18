import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/lognito.dart';

abstract class Filter {
  /// Init method, is called when filter is registered in [Lognito] instance
  void init();

  /// Method used when creating new [Lognito] with different log level
  Filter copyWithLevel(Level level);

  /// Is called every time a new log message is sent and decides if
  /// it will be printed or canceled.
  ///
  /// Returns `true` if the message should be logged.
  bool shouldLog(LogEvent event);

  void dispose();
}
