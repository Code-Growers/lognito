import 'package:flutter/cupertino.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

class DebugPrinterOutput extends Output {
  final Formatter formatter;

  DebugPrinterOutput({@required this.formatter}) : assert(formatter != null);

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    final formattedMessage = formatter.format(event);
    formattedMessage.forEach((element) {
      debugPrint(element);
    });
    return true;
  }

  @override
  void dispose() {}
}
