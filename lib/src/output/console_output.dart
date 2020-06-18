import 'package:flutter/cupertino.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

class ConsoleOutput extends Output {
  final Formatter formatter;

  ConsoleOutput({@required this.formatter}) : assert(formatter != null);

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    final formattedMessage = formatter.format(event);
    formattedMessage.forEach((element) {
      print(element);
    });
    return true;
  }

  @override
  void dispose() {}
}
