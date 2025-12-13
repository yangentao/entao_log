part of '../../entao_log.dart';

abstract class LogPrinter implements StreamConsumer<LogItem>, EventSink<LogItem> {
  StreamSubscription<LogItem>? _sub;
  LogLevel _level;
  Set<String>? _tags;
  LogFilter? _filter;

  LogPrinter({LogLevel? level, Set<String>? tags, bool Function(LogItem)? filter}) : _filter = filter, _tags = tags, _level = level ?? LogLevel.all;

  FutureOr<void> println(LogItem item);

  Future<void> cancel() async {
    await _sub?.cancel();
    _sub = null;
  }

  @override
  Future<dynamic> addStream(Stream<LogItem> stream) {
    _sub?.cancel();
    var completer = Completer();
    _sub = stream.listen(
      add,
      onError: completer.completeError,
      onDone: completer.complete,
      cancelOnError: true,
    );
    return completer.future;
  }

  @override
  Future<dynamic> close()  {
    _sub?.cancel();
    _sub = null;
    return Future.value();
  }

  @override
  void add(LogItem event) {
    if (event.level.index < _level.index) return;
    if (_tags == null || _tags!.isEmpty || _tags!.contains(event.tag)) {
      if (_filter == null || _filter!(event)) {
        println(event);
      }
    }
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
}

extension LogSinkExt<T extends LogPrinter> on T {
  T off() {
    this._level = LogLevel.off;
    return this;
  }

  T on({LogLevel? level, Set<String>? tags, LogFilter? filter}) {
    this._level = level ?? LogLevel.all;
    this._tags = tags ?? const {};
    this._filter = filter;
    return this;
  }
}
