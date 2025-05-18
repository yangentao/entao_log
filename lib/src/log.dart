import 'dart:io';

import 'package:entao_log/src/varcall.dart';

part 'log_def.dart';
part 'log_printer.dart';
part 'log_util.dart';
part 'dir_printer.dart';

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
  static LogFilter? filter;
  static LogPrinter _printer = ConsolePrinter.inst;
  static int _lastMessageTime = 0;
  static final Duration _flushDuration = Duration(seconds: 2);

  static void _delayFlush(int tmMsg) {
    if (tmMsg < _lastMessageTime + _flushDuration.inMilliseconds) {
      return;
    }
    _lastMessageTime = tmMsg;
    Future.delayed(_flushDuration, flush);
  }

  static void flush() {
    _lastMessageTime = 0;
    _printer.flush();
    if (_lastMessageTime != 0) {
      stderr.writeln("DONT log message in flush().");
    }
  }

  static void setPrinter(LogPrinter p) {
    _printer.flush();
    _printer.dispose();
    _printer = p;
  }

  static void logItem(LogLevel level, List<dynamic> messages, {String? tag}) {
    if (!XLog.level.allow(level)) return;
    if (!_printer.level.allow(level)) return;
    DateTime tm = DateTime.now();
    LogItem item = LogItem(level: level, message: _anyListToString(messages), tag: tag ?? XLog.tag, time: tm);
    if (filter?.allow(item) == false) return;
    _printer.printIf(item);
    if (_printer is! ConsolePrinter) {
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
