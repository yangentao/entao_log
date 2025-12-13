part of '../entao_log.dart';

final class XLog {
  XLog._();

  static String tag = "xlog";
  static LogLevel level = LogLevel.all;
  static LogFormater formater = DefaultLogFormater();
  static TreeLogFilter filter = TreeLogFilter([]);
  static final Map<String, LogLevel> _tagLevelMap = {};
  static TreeLogPrinter printer = TreeLogPrinter([ConsolePrinter.inst]);
  static int _lastMessageTime = 0;
  static final Duration _flushDuration = Duration(seconds: 2);
  static Timer? _timer;

  static void onExit() {
    _timer?.cancel();
    flush();
  }

  static void off({String? tag}) {
    if (tag == null) {
      level = LogLevel.off;
    } else {
      _tagLevelMap[tag] = LogLevel.off;
    }
  }

  static void on({LogLevel level = LogLevel.all, String? tag}) {
    if (tag == null) {
      XLog.level = level;
    } else {
      _tagLevelMap[tag] = level;
    }
  }

  static void _delayFlush(int tmMsg) {
    if (tmMsg < _lastMessageTime + _flushDuration.inMilliseconds) {
      return;
    }
    _lastMessageTime = tmMsg;
    _timer = Timer(_flushDuration, flush);
  }

  static void flush() {
    _lastMessageTime = 0;
    printer.flush();
    if (_lastMessageTime != 0) {
      stderr.writeln("DONT log message in flush().");
    }
  }

  static void setPrinter(LogPrinter p) {
    printer.flush();
    printer.set(p);
  }

  static void addPrinter(LogPrinter p) {
    printer.add(p);
  }

  static void removePrinter(bool Function(LogPrinter) test) {
    printer.remove(test);
  }

  static void setTagLevel(String tag, LogLevel level) {
    XLog.filter.remove((e) => e is TagFilter && e.tag == tag);
    XLog.filter.add(TagFilter(tag: tag, level: level));
  }

  static void setFilter(LogFilter f) {
    XLog.filter.set(f);
  }

  static void addFilter(LogFilter f) {
    XLog.filter.add(f);
  }

  static void removeFilter(bool Function(LogFilter) test) {
    XLog.filter.remove(test);
  }

  static void logItem(LogLevel level, List<dynamic> messages, {String? tag, String? sep}) {
    if (!XLog.level.allow(level)) return;
    if (!printer.level.allow(level)) return;
    LogLevel? lv = _tagLevelMap[tag ?? XLog.tag];
    if (lv != null) {
      if (!lv.allow(level)) return;
    }
    DateTime tm = DateTime.now();
    LogItem item = LogItem(
      level: level,
      time: tm,
      message: _anyListToString(messages, sep: sep),
      tag: tag ?? XLog.tag,
    );
    if (filter.allow(item) == false) return;
    printer.printIf(item);
    if (printer is! ConsolePrinter) {
      _delayFlush(tm.millisecondsSinceEpoch);
    }
  }

  static void verbose(List<dynamic> messages, {String? tag, String? sep}) {
    logItem(LogLevel.verbose, messages, tag: tag, sep: sep);
  }

  static void debug(List<dynamic> messages, {String? tag, String? sep}) {
    logItem(LogLevel.debug, messages, tag: tag, sep: sep);
  }

  static void info(List<dynamic> messages, {String? tag, String? sep}) {
    logItem(LogLevel.info, messages, tag: tag, sep: sep);
  }

  static void warn(List<dynamic> messages, {String? tag, String? sep}) {
    logItem(LogLevel.warning, messages, tag: tag, sep: sep);
  }

  static void error(List<dynamic> messages, {String? tag, String? sep}) {
    logItem(LogLevel.error, messages, tag: tag, sep: sep);
  }
}
