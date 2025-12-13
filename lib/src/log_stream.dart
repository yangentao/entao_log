part of '../entao_log.dart';

class LogStream extends Stream<LogItem> implements EventSink<LogItem> {
  final StreamController<LogItem> streamController = StreamController();

  LogStream._();

  factory LogStream() {
    return _inst;
  }

  static final LogStream _inst = LogStream._();

  @override
  void add(LogItem event) {
    streamController.add(event);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    streamController.addError(error, stackTrace);
  }

  @override
  void close() {
    streamController.close();
  }

  @override
  StreamSubscription<LogItem> listen(void Function(LogItem event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
