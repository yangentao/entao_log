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
  List<LogPrinter> printers;

  TreeLogPrinter([List<LogPrinter>? printers]) : this.printers = printers ?? [];

  void add(LogPrinter p) {
    if (!printers.contains(p)) {
      printers.add(p);
    }
  }

  void remove(bool Function(LogPrinter) test) {
    printers.removeWhere((p) {
      bool b = test(p);
      if (b) {
        p.dispose();
      }
      return b;
    });
  }

  void set(LogPrinter p) {
    for (var e in printers) {
      if (!identical(e, p)) {
        e.dispose();
      }
    }
    printers.clear();
    printers.add(p);
  }

  @override
  void printItem(LogItem item) {
    for (var p in printers) {
      p.printIf(item);
    }
  }

  @override
  void flush() {
    for (var e in printers) {
      e.flush();
    }
  }

  @override
  void dispose() {
    for (var e in printers) {
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


/// XLog 2秒会flush()一下, 因此bufferSize只是个参考值.
class FileLogPrinter extends LogPrinter {
  final File file;
  final StringBuffer _buffer = StringBuffer();
  final int bufferSize;

  FileLogPrinter(this.file, {this.bufferSize = 8192});

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
    if (_buffer.length >= bufferSize) {
      flush();
    }
  }
}
