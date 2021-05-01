import 'package:flutter/cupertino.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

class DebugPrinterOutput extends Output {
  final Formatter formatter;

  DebugPrinterOutput({required this.formatter});

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    final List<String?> formattedMessage = formatter.format(event);
    formattedMessage.forEach((String? element) {
      debugPrint(element);
    });
    return true;
  }

  @override
  void dispose() {}
}
