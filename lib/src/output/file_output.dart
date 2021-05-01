import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

/// Credit to https://github.com/leisim/logger

/// Output to file.
class FileOutput extends Output {
  final Formatter formatter;
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  late IOSink _sink;

  FileOutput({
    required this.file,
    required this.formatter,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  void init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void dispose() async{
    await _sink.flush();
    await _sink.close();
  }

  @override
  FutureOr<bool> log(LogEvent event) {
    final List<String?> lines = formatter.format(event);
    try{
      _sink.writeAll(lines, '\n');
      return true;
    }catch(_){
      return false;
    }
  }
}
