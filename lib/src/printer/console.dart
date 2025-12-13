part of '../../entao_log.dart';

class ConsolePrinter extends LogPrinter {
  // ignore: unused_element_parameter
  ConsolePrinter._({super.level, super.tags});

  factory ConsolePrinter({LogLevel level = LogLevel.all, Set<String>? tags}) {
    instance._level = level;
    instance._tags = tags;
    return instance;
  }

  static ConsolePrinter instance = ConsolePrinter._();

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
