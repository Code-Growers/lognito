import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/output/output.dart';

/// Always return result param as return value of log
/// [Output.log] -> result
class AlwaysOutput extends Output {
  final bool result;

  AlwaysOutput(this.result);

  @override
  void dispose() {}

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    if (result) {
      print('${event.message} ${event.error}');
    }
    return result;
  }
}

/// First return result param as return value of log
/// and negates it,
/// First call [Output.log] -> result
/// Second call [Output.log] -> !result
class SwappingOutput extends Output {
  bool result;

  SwappingOutput(this.result);

  @override
  void dispose() {}

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    final currentResult = result;
    if (currentResult) {
      print(event.message);
    }
    result = !result;
    return currentResult;
  }
}

/// Counts how many times the log is called
class CallCountingOutput extends Output {
  int count = 0;

  CallCountingOutput();

  @override
  void dispose() {}

  @override
  void init() {}

  @override
  bool log(LogEvent event) {
    count += 1;
    print(event.message);
    return true;
  }
}
