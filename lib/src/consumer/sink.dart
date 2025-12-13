part of '../../entao_log.dart';

abstract class LogSink implements StreamConsumer<LogItem>, EventSink<LogItem> {
  StreamSubscription<LogItem>? _sub;
  LogLevel level;
  Set<String>? tags;
  LogFilter? filter;

  LogSink({LogLevel? level, this.tags, this.filter}) : level = level ?? LogLevel.all;

  FutureOr<void> println(LogItem item);

  @override
  Future<dynamic> addStream(Stream<LogItem> stream) async {
    await _sub?.cancel();
    final completer = Completer();
    _sub = stream.listen(
      add,
      onError: completer.completeError,
      onDone: completer.complete,
      cancelOnError: true,
    );
    return completer.future;
  }

  @override
  Future<dynamic> close() async {
    await _sub?.cancel();
  }

  @override
  void add(LogItem event) {
    if (event.level.index < level.index) return;
    if (tags == null || tags!.isEmpty || tags!.contains(event.tag)) {
      if (filter == null || filter!(event)) {
        println(event);
      }
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
}

extension LogSinkExt<T extends LogSink> on T {
  T off() {
    this.level = LogLevel.off;
    return this;
  }

  T filter({LogLevel? level, Set<String>? tags, LogFilter? filter}) {
    this.level = level ?? LogLevel.all;
    this.tags = tags ?? const {};
    this.filter = filter;
    return this;
  }
}
