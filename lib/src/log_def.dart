part of '../entao_log.dart';


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
