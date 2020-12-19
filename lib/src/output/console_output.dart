import 'package:flutter/cupertino.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

class ConsoleOutput extends Output {
  final Formatter formatter;

  ConsoleOutput({@required this.formatter})
      : assert(formatter != null,
            'formatter param passed to ConsoleOutput cannot be null!');

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    final List<String> formattedMessage = formatter.format(event);
    formattedMessage.forEach((String element) {
      print(element);
    });
    return true;
  }

  @override
  void dispose() {}
}
