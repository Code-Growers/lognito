import 'package:lognito/src/buffer/buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/output/output.dart';

class RepeatingBuffer extends Buffer {
  List<Map<Output, LogEvent>> pendingEvents = [];
  final Duration repeatAfter;

  RepeatingBuffer(List<Output> outputs,
      {this.repeatAfter = const Duration(minutes: 5)})
      : super(outputs);

  @override
  void addToBuffer(LogEvent event) {
    final mappedEvents = {for (var output in outputs) output: event};
    pendingEvents.add(mappedEvents);
    flush();
  }

  @override
  Future<void> flush() async {
    final List<Map<Output, LogEvent>> currentEvents = pendingEvents;
    pendingEvents = [];
    final remaining = await Future.wait(currentEvents.map((pendingEvent) {
      return Future.wait(Map.of(pendingEvent)
          .map((output, event) {
            return MapEntry(output, Future.sync(() => output.log(event)));
          })
          .values
          .toList());
    }));
    final remainingEvents = currentEvents
      ..removeWhere((pendingEvent) {
        final index = currentEvents.indexOf(pendingEvent);
        return remaining[index].every((e) => e);
      });
    pendingEvents.addAll(remainingEvents);
    if (currentEvents.isNotEmpty) {
      Future.delayed(repeatAfter).then((_) {
        flush();
      });
    }
  }

  @override
  void dispose() {}

  @override
  void init() {}
}
