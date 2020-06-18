import 'dart:async';

import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/output/output.dart';

abstract class Buffer {
  final List<Output> outputs;

  const Buffer(this.outputs);

  void init();

  FutureOr<void> flush();

  void addToBuffer(LogEvent event);

  void dispose();
}
