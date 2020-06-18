import 'dart:async';

import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/lognito.dart';

abstract class Output {
  /// Init method, is called when filter is registered in [Lognito] instance
  void init();

  FutureOr<bool> log(LogEvent event);

  void dispose();
}
