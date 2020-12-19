import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lognito/src/event/log_event.dart';
import 'package:lognito/src/formatter/formater.dart';
import 'package:lognito/src/output/output.dart';

/// Sends the event over HTTP to desired api defined by params
///
class HTTPOutput extends Output {
  /// formats the event before sending it to api
  /// even tho [Formatter] returns list of string,
  /// to api is send only the first one
  /// designed to use [JsonFormatter]
  final Formatter formatter;

  /// Endpoint uri
  final Uri uri;

  /// Optional http headers
  final Map<String, String> headers;

  /// Encoding of the final message
  final Encoding encoding;

  HTTPOutput({
    @required this.uri,
    this.formatter,
    this.headers,
    this.encoding,
  }) : assert(formatter != null,
            'formatter param passed to HTTPOutput cannot be null!');

  @override
  void init() {}

  @override
  Future<bool> log(LogEvent event) async {
    final http.Response response = await postMessage(formatter.format(event).first);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  /// Send out the list of line (messages)
  /// [message] should be properly formatted for your use-case by formatter
  Future<http.Response> postMessage(String message) {
    return http.post(uri, headers: headers, body: message, encoding: encoding);
  }

  @override
  void dispose() {}
}
