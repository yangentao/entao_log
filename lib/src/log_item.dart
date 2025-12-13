part of '../entao_log.dart';

class LogItem {
  final LogLevel level;
  final String tag;
  final String message;
  final DateTime time;
  final LogFormatter formatter;
  late final String _text = formatter(this);

  LogItem({required this.level, required this.message, required this.tag, DateTime? time, this.formatter = defaultLogFormatter}) : time = time ?? DateTime.now();

  @override
  String toString() {
    return _text;
  }
}
