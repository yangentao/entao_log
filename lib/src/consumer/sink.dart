part of '../../entao_log.dart';

abstract class LogSink implements StreamConsumer<LogItem>, EventSink<LogItem> {
  StreamSubscription<LogItem>? _sub;
  LogLevel level;
  Set<String>? tags;
  LogFilter? filter;

  LogSink({LogLevel? level, this.tags, this.filter}) : level = level ?? LogLevel.all;

  FutureOr<void> println(LogItem item);

  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
  }

  @override
  Future<dynamic> addStream(Stream<LogItem> stream) async {
    await _sub?.cancel();
    final completer = Completer();
    print("addStream $stream");
    _sub = stream.listen(
      (v) {
        print("recv: $v");
        add(v);
      },
      onError: (e ,st){
        print("error");
        completer.completeError(e, st);
      },
      onDone: (){
        print("done");
        completer.complete();
      },
      cancelOnError: true,
    );
    return completer.future;
  }

  @override
  Future<dynamic> close() async {
    await _sub?.cancel();
    _sub = null;
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
