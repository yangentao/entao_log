part of '../entao_log.dart';

enum LogLevel {
  all,
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
  off;

  String get firstChar => name.substring(0, 1).toUpperCase();
}
