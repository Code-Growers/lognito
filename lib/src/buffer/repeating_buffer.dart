import 'package:lognito/src/buffer/buffer.dart';
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/output/output.dart';

class RepeatingBuffer extends Buffer {
  List<Map<Output, LogEvent>> pendingEvents = <Map<Output, LogEvent>>[];
  final Duration repeatAfter;

  RepeatingBuffer(List<Output> outputs,
      {this.repeatAfter = const Duration(minutes: 5)})
      : super(outputs);

  @override
  void addToBuffer(LogEvent event) {
    final Map<Output, LogEvent> mappedEvents = <Output, LogEvent>{
      for (Output output in outputs) output: event
    };
    pendingEvents.add(mappedEvents);
    flush();
  }

  @override
  Future<void> flush() async {
    final List<Map<Output, LogEvent>> currentEvents = pendingEvents;
    pendingEvents = <Map<Output, LogEvent>>[];
    final List<List<bool>> remaining = await Future.wait(
        currentEvents.map((Map<Output, LogEvent> pendingEvent) {
      return Future.wait(Map<Output, LogEvent>.of(pendingEvent)
          .map((Output output, LogEvent event) {
            return MapEntry<Output, Future<bool>>(
                output, Future<bool>.sync(() => output.log(event)));
          })
          .values
          .toList());
    }));
    final List<Map<Output, LogEvent>> remainingEvents = currentEvents
      ..removeWhere((Map<Output, LogEvent> pendingEvent) {
        final int index = currentEvents.indexOf(pendingEvent);
        return remaining[index].every((bool e) => e);
      });
    pendingEvents.addAll(remainingEvents);
    if (currentEvents.isNotEmpty) {
      Future<void>.delayed(repeatAfter).then((_) {
        flush();
      });
    }
  }

  @override
  void dispose() {}

  @override
  void init() {}
}
