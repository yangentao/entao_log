part of '../../entao_log.dart';

abstract class LogSink implements StreamConsumer<LogItem>, EventSink<LogItem> {
  StreamSubscription<LogItem>? _sub;
  LogLevel level;
  String? tag;

  LogSink({LogLevel? level, String? tag}) : level = level ?? LogLevel.all;

  FutureOr<void> println(String item);

  @override
  Future<dynamic> addStream(Stream<LogItem> stream) async {
    await _sub?.cancel();
    _sub = stream.listen(add, onError: addError, onDone: close);
  }

  @override
  Future<dynamic> close() async {
    await _sub?.cancel();
  }

  @override
  void add(LogItem event) {
    if (event.level.index >= level.index) {
      println(event.toString());
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
}
