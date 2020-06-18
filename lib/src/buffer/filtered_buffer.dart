import 'package:flutter/cupertino.dart';
import 'package:lognito/src/buffer/simple_buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/filter/filter.dart';
import 'package:lognito/src/output/output.dart';

/// Simple buffer with added filter
/// before adding to event to buffer
class FilteredBuffer extends SimpleBuffer {
  List<LogEvent> events = [];
  final Filter filter;

  FilteredBuffer(List<Output> outputs, {@required this.filter})
      : super(outputs);

  @override
  void addToBuffer(LogEvent event) {
    if (filter.shouldLog(event)) {
      events.add(event);
      flush();
    }
  }
}
