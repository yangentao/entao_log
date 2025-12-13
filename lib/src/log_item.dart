part of '../entao_log.dart';

class LogItem {
  final LogLevel level;
  final String tag;
  final String message;
  final DateTime time;
  late final String _text = xlog.formatter(this);

  LogItem({required this.level, required this.message, required this.tag, required this.time});

  @override
  String toString() {
    return _text;
  }
}
