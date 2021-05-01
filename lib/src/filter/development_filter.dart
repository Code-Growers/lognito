import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/filter/filter.dart';
import 'package:lognito/src/lognito.dart';
import 'package:lognito/src/utils/level_utils.dart';

class DevelopmentFilter extends Filter {
  final Level? level;

  DevelopmentFilter(this.level);

  @override
  void dispose() {}

  @override
  void init() {}

  @override
  bool shouldLog(LogEvent event) {
    return getLevelInt(event.level) >= getLevelInt(level);
  }

  @override
  Filter copyWithLevel(Level? level) {
    return DevelopmentFilter(level);
  }
}
