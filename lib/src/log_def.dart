part of 'log.dart';

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

class LogItem {
  LogLevel level;
  String message;
  String tag;
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

abstract interface class LogFormater {
  String format(LogItem item);
}

abstract interface class LogFilter {
  bool allow(LogItem item);
}

class FuncLogFilter extends LogFilter {
  bool Function(LogItem) callback;

  FuncLogFilter(this.callback);

  @override
  bool allow(LogItem item) {
    return callback(item);
  }
}

class TagFilter extends LogFilter {
  String tag;
  LogLevel level;

  TagFilter({required this.tag, required this.level});

  @override
  bool allow(LogItem item) {
    if (item.tag == tag) {
      return item.level >= level;
    }
    return true;
  }
}

class TreeLogFilter extends LogFilter {
  List<LogFilter> filters;

  TreeLogFilter([List<LogFilter>? list]) : this.filters = list ?? [];

  void set(LogFilter f) {
    filters.clear();
    filters.add(f);
  }

  void add(LogFilter f) {
    filters.add(f);
  }

  void remove(bool Function(LogFilter) test) {
    filters.removeWhere(test);
  }

  @override
  bool allow(LogItem item) {
    for (var f in filters) {
      if (!f.allow(item)) return false;
    }
    return true;
  }
}

class DefaultLogFormater extends LogFormater {
  @override
  String format(LogItem item) {
    return "${item.time.formatDateTimeX} ${item.level.firstChar} ${item.tag}: ${item.message}";
  }
}
