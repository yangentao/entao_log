part of '../entao_log.dart';

class LogItem {
  LogLevel level;
  String tag;
  String message;
  DateTime time;
  late String textLine;

  LogItem({required this.level, required this.message, required this.tag, required this.time}) {
    textLine = XLog.formater.format(this);
  }

  @override
  String toString() {
    return textLine;
  }
}
