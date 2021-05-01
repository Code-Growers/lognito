import 'package:lognito/src/event/log_event.dart';

abstract class Formatter {
  /// Init method, is called when filter is registered in [Lognito] instance
  void init();

  List<String?> format(LogEvent event);

  void dispose();
}
