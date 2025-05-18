part of 'log.dart';

abstract class LogPrinter {
  LogLevel level = LogLevel.all;

  void printIf(LogItem item) {
    if (level.allow(item.level)) printItem(item);
  }

  void printItem(LogItem item);

  void flush() {}

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

  @override
  void dispose() {
    for (var e in list) {
      e.dispose();
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
}

class ConsolePrinter extends LogPrinter {
  ConsolePrinter._internal() {
    if (!_isDebugMode) {
      level = LogLevel.off;
    }
  }

  @override
  void printItem(LogItem item) {
    switch (item.level) {
      case LogLevel.verbose:
        print(sgr("2") + sgr("3") + item.toString() + sgr("0"));
      case LogLevel.info:
        print(sgr("1") + item.toString() + sgr("0"));
      case LogLevel.warning:
        print(sgr("33") + item.toString() + sgr("0"));
      case >= LogLevel.error:
        print(sgr("31") + item.toString() + sgr("0"));
      default:
        print(item.toString());
    }
  }

  static String sgr(String code) {
    return "\u001b[${code}m";
  }

  static final ConsolePrinter inst = ConsolePrinter._internal();
}

class FileLogPrinter extends LogPrinter {
  File file;
  final StringBuffer _buffer = StringBuffer();

  FileLogPrinter(this.file);

  @override
  void dispose() {
    flush();
  }

  @override
  void flush() {
    file.writeAsStringSync(_buffer.toString(), mode: FileMode.append, flush: true);
    _buffer.clear();
  }

  @override
  void printItem(LogItem item) {
    _buffer.writeln(item.toString());
    if (_buffer.length >= 8192) {
      flush();
    }
  }
}
