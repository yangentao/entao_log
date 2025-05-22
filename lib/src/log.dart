import 'dart:async';
import 'dart:io';

import 'package:entao_log/src/varcall.dart';
import 'package:path/path.dart' as path;

part 'dir_printer.dart';
part 'log_def.dart';
part 'log_printer.dart';
part 'log_util.dart';

dynamic logv = LogVarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.verbose, args, tag: kwargs["tag"]);
});

dynamic logd = LogVarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.debug, args, tag: kwargs["tag"]);
});

dynamic logi = LogVarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.info, args, tag: kwargs["tag"]);
});

dynamic logw = LogVarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.warning, args, tag: kwargs["tag"]);
});

dynamic loge = LogVarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.error, args, tag: kwargs["tag"]);
});

final class XLog {
  XLog._();

  static String tag = "xlog";
  static LogLevel level = LogLevel.all;
  static LogFormater formater = DefaultLogFormater();
  static TreeLogFilter filter = TreeLogFilter([]);
  static TreeLogPrinter printer = TreeLogPrinter([ConsolePrinter.inst]);
  static int _lastMessageTime = 0;
  static final Duration _flushDuration = Duration(seconds: 2);
  static Timer? _timer;

  static void onExit() {
    _timer?.cancel();
    flush();
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

  static void logItem(LogLevel level, List<dynamic> messages, {String? tag}) {
    if (!XLog.level.allow(level)) return;
    if (!printer.level.allow(level)) return;
    DateTime tm = DateTime.now();
    LogItem item = LogItem(level: level, message: _anyListToString(messages), tag: tag ?? XLog.tag, time: tm);
    if (filter.allow(item) == false) return;
    printer.printIf(item);
    if (printer is! ConsolePrinter) {
      _delayFlush(tm.millisecondsSinceEpoch);
    }
  }

  static void verbose(List<dynamic> messages) {
    logItem(LogLevel.verbose, messages);
  }

  static void debug(List<dynamic> messages) {
    logItem(LogLevel.debug, messages);
  }

  static void info(List<dynamic> messages) {
    logItem(LogLevel.info, messages);
  }

  static void warn(List<dynamic> messages) {
    logItem(LogLevel.warning, messages);
  }

  static void error(List<dynamic> messages) {
    logItem(LogLevel.error, messages);
  }
}

class TagLog {
  String tag;

  TagLog(this.tag);

  late dynamic v = LogVarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.verbose, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic d = LogVarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.debug, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic w = LogVarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.warning, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic i = LogVarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.info, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic e = LogVarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.error, args, tag: kwargs["tag"] ?? tag);
  });
}
