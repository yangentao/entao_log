part of '../../entao_log.dart';

class LogConsole extends LogSink {
  LogConsole({super.level, super.tag});

  @override
  FutureOr<void> println(String item) {
    print(item);
  }
}
