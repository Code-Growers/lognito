import 'package:flutter/cupertino.dart';
import 'package:lognito/src/buffer/repeating_buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/lognito.dart';
import 'package:lognito/src/output/output.dart';
import 'package:lognito/src/utils/level_utils.dart';

class LevelDelayedBuffer extends RepeatingBuffer {
  final Level triggerLevel;

  LevelDelayedBuffer(List<Output> outputs, {@required this.triggerLevel})
      : super(outputs);

  void addToBuffer(LogEvent event) {
    final mappedEvents = {for (var output in outputs) output: event};
    pendingEvents.add(mappedEvents);
    if (getLevelInt(event.level) >= getLevelInt(triggerLevel)) {
      super.flush();
    }
  }
}
