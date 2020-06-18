import 'package:lognito/src/lognito.dart';

int getLevelInt(Level level) {
  if (level == Level.bloc) {
    return -1;
  }
  return Level.values.indexOf(level);
}
