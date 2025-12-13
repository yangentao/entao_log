part of '../../entao_log.dart';

class LogConsole extends LogSink {
  // ignore: unused_element_parameter
  LogConsole._({super.level, super.tags});

  factory LogConsole({LogLevel level = LogLevel.all, Set<String>? tags}) {
    instance.level = level;
    instance.tags = tags;
    return instance;
  }

  static LogConsole instance = LogConsole._();

  @override
  FutureOr<void> println(LogItem item) {
    var ls = _map[item.level];
    String s = ls == null ? item.toString() : item.toString().styleEscaped(ls);
    print(s);
  }
}

final Map<LogLevel, List<EscapeCode>> _map = {
  LogLevel.verbose: [EscapeCode.bold, EscapeCode.italic],
  LogLevel.info: [EscapeCode.bold],
  LogLevel.warning: [EscapeCode.foreYellow],
  LogLevel.error: [EscapeCode.foreRed],
  LogLevel.fatal: [EscapeCode.foreRed, EscapeCode.italic],
};
