import 'dart:convert';

import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';

/// Simple Json formatter
/// formats message to with [json.encode]
class JsonFormatter extends Formatter {
  @override
  void dispose() {}

  @override
  List<String> format(LogEvent event) {
    return [json.encode(event.message)];
  }

  @override
  void init() {}
}
