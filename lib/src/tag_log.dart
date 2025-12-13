part of '../entao_log.dart';

class TagLogX {
  String tag;
  LogFormatter formatter;

  TagLogX({required this.tag, this.formatter = defaultLogFormatter});
}
