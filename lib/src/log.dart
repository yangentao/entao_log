import 'dart:io';

import 'package:entao_log/src/varcall.dart';




const bool isReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool isProfileMode = bool.fromEnvironment('dart.vm.profile');
const bool isDebugMode = !isReleaseMode && !isProfileMode;

class BufPrinter extends LogPrinter {
  StringBuffer buf = StringBuffer();

  @override
  void flush() {
    if (buf.isEmpty) return;
    print(buf.toString());
    buf.clear();
    print("flush...");
  }

  @override
  void printItem(LogItem item) {
    buf.writeln(item);
  }
}

class FileLogPrinter extends LogPrinter {
  File file;
  IOSink fileSink;

  FileLogPrinter(this.file) : fileSink = file.openWrite(mode: FileMode.append);

  @override
  void dispose() {
    fileSink.close();
  }

  @override
  void flush() {
    fileSink.flush();
  }

  @override
  void printItem(LogItem item) {
    fileSink.writeln(item.toString());
  }
}

dynamic println = VarargFunction((args, kwargs) {
  StringSink? buf = kwargs["buf"];
  if (buf != null) {
    String line = args.map((e) => e.toString()).join(kwargs["sep"] ?? " ");
    buf.writeln(line);
    return;
  }
  if (!isDebugMode) return;
  String line = args.map((e) => e.toString()).join(kwargs["sep"] ?? " ");
  print(line);
});

dynamic logv = VarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.VERBOSE, args, tag: kwargs["tag"]);
});

dynamic logd = VarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.DEBUG, args, tag: kwargs["tag"]);
});

dynamic logi = VarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.INFO, args, tag: kwargs["tag"]);
});

dynamic logw = VarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.WARNING, args, tag: kwargs["tag"]);
});

dynamic loge = VarargFunction((args, kwargs) {
  XLog.logItem(LogLevel.ERROR, args, tag: kwargs["tag"]);
});

enum LogLevel implements Comparable<LogLevel> {
  ALL,
  VERBOSE,
  DEBUG,
  INFO,
  WARNING,
  ERROR,
  FATAIL,
  OFF;

  bool allow(LogLevel other) => other >= this;

  String get firstChar => this.name.substring(0, 1);

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

class TreeLogFilter extends LogFilter {
  List<LogFilter> list;

  TreeLogFilter(this.list);

  @override
  bool allow(LogItem item) {
    for (var f in list) {
      if (!f.allow(item)) return false;
    }
    return true;
  }
}

abstract class LogPrinter {
  LogLevel level = LogLevel.ALL;

  void printIf(LogItem item) {
    if (level.allow(item.level)) printItem(item);
  }

  void printItem(LogItem item);

  void flush();

  void dispose() {}
}

class TreeLogPrinter extends LogPrinter {
  List<LogPrinter> list;

  TreeLogPrinter(this.list);

  @override
  void printItem(LogItem item) {
    for (var p in list) {
      p.printIf(item);
    }
  }

  @override
  void flush() {
    for (var e in list) {
      e.flush();
    }
  }
}

class FuncLogPrinter extends LogPrinter {
  void Function(LogItem)? callback;

  FuncLogPrinter(this.callback);

  @override
  void printItem(LogItem item) {
    callback?.call(item);
  }

  @override
  void flush() {}
}

class ConsolePrinter extends LogPrinter {
  ConsolePrinter._internal();

  ConsolePrinter._();

  @override
  void printItem(LogItem item) {
    switch (item.level) {
      case LogLevel.VERBOSE:
        print(sgr("2") + sgr("3") + item.toString() + sgr("0"));
      case LogLevel.INFO:
        print(sgr("1") + item.toString() + sgr("0"));
      case LogLevel.WARNING:
        print(sgr("33") + item.toString() + sgr("0"));
      case >= LogLevel.ERROR:
        print(sgr("31") + item.toString() + sgr("0"));
      default:
        print(item.toString());
    }
  }

  static String sgr(String code) {
    return "\u001b[${code}m";
  }

  static final ConsolePrinter inst = ConsolePrinter._internal();

  @override
  void flush() {}
}

class DefaultLogFormater extends LogFormater {
  @override
  String format(LogItem item) {
    return "${item.time.formatDateTimeX} ${item.level.firstChar} ${item.tag}: ${item.message}";
  }
}

extension _DateTimeExt on DateTime {
  String get formatDateTimeX =>
      "${year.formated("0000")}-${month.formated("00")}-${day.formated("00")} ${hour.formated("00")}:${minute.formated("00")}:${second.formated("00")}.${millisecond.formated("000")}";
}

extension _NumFormatExt on num {
  String formated(String f) {
    return toString().padLeft(f.length, '0');
  }
}

class TagLog {
  String tag;

  TagLog(this.tag);

  late dynamic v = VarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.VERBOSE, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic d = VarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.DEBUG, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic w = VarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.WARNING, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic i = VarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.INFO, args, tag: kwargs["tag"] ?? tag);
  });
  late dynamic e = VarargFunction((args, kwargs) {
    XLog.logItem(LogLevel.ERROR, args, tag: kwargs["tag"] ?? tag);
  });
}

final class XLog {
  XLog._();

  static String tag = "xlog";
  static LogLevel level = LogLevel.ALL;
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
    logItem(LogLevel.VERBOSE, messages);
  }

  static void debug(List<dynamic> messages) {
    logItem(LogLevel.DEBUG, messages);
  }

  static void info(List<dynamic> messages) {
    logItem(LogLevel.INFO, messages);
  }

  static void warn(List<dynamic> messages) {
    logItem(LogLevel.WARNING, messages);
  }

  static void error(List<dynamic> messages) {
    logItem(LogLevel.ERROR, messages);
  }
}

String _anyListToString(List<dynamic> messages) {
  return messages.map((e) => _anyToString(e)).join(" ");
}

String _anyToString(dynamic value) {
  switch (value) {
    case null:
      return "null";
    case String s:
      return s;
    case num n:
      return n.toString();
    default:
      return value.toString();
  }
}
