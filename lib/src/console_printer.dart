part of '../entao_log.dart';

class ConsolePrinter extends LogPrinter {
  static final Map<LogLevel, List<EscapeCode>> _map = {
    LogLevel.verbose: [EscapeCode.bold, EscapeCode.italic],
    LogLevel.info: [EscapeCode.bold],
    LogLevel.warning: [EscapeCode.foreYellow],
    LogLevel.error: [EscapeCode.foreRed],
    LogLevel.fatal: [EscapeCode.foreRed, EscapeCode.italic],
  };

  ConsolePrinter._internal() {
    if (!_isDebugMode) {
      level = LogLevel.off;
    }
  }

  static void setEscapeCodes(LogLevel level, List<EscapeCode>? codes) {
    if (codes == null) {
      _map.remove(level);
    } else {
      _map[level] = codes;
    }
  }

  @override
  void printItem(LogItem item) {
    var ls = _map[item.level];
    if (ls == null) {
      print(item.toString());
    } else {
      item.toString().styleEscaped(ls);
    }
  }

  static final ConsolePrinter inst = ConsolePrinter._internal();
}
