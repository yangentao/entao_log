part of '../../entao_log.dart';

class LogConsole extends LogSink {
  LogConsole({super.level, super.tags});

  @override
  FutureOr<void> println(LogItem item) {
    var ls = _map[item.level];
    if (ls == null) {
      print(item.toString());
    } else {
      print(item.toString().styleEscaped(ls));
    }
  }
}

final Map<LogLevel, List<EscapeCode>> _map = {
  LogLevel.verbose: [EscapeCode.bold, EscapeCode.italic],
  LogLevel.info: [EscapeCode.bold],
  LogLevel.warning: [EscapeCode.foreYellow],
  LogLevel.error: [EscapeCode.foreRed],
  LogLevel.fatal: [EscapeCode.foreRed, EscapeCode.italic],
};
