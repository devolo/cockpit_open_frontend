import 'dart:convert';

import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {

  SimpleLogPrinter();

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];

    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    return [color!('$messageStr$errorStr')];
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}