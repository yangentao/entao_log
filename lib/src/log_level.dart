part of '../entao_log.dart';

enum LogLevel implements Comparable<LogLevel> {
  all,
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
  off;

  bool allow(LogLevel other) => other >= this;

  String get firstChar => name.substring(0, 1).toUpperCase();

  @override
  int compareTo(LogLevel other) {
    return this.index - other.index;
  }

  bool operator <(LogLevel other) {
    return this.compareTo(other) < 0;
  }

  bool operator <=(LogLevel other) {
    return this.compareTo(other) <= 0;
  }

  bool operator >(LogLevel other) {
    return this.compareTo(other) > 0;
  }

  bool operator >=(LogLevel other) {
    return this.compareTo(other) >= 0;
  }
}
