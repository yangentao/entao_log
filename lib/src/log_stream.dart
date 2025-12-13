part of '../entao_log.dart';

class LogStream extends Stream<LogItem> implements EventSink<LogItem> {
  final StreamController<LogItem> streamController = StreamController<LogItem>.broadcast();

  LogStream._();

  factory LogStream() {
    return instance;
  }

  static final LogStream instance = LogStream._();

  @override
  bool get isBroadcast => streamController.stream.isBroadcast;

  @override
  Stream<LogItem> asBroadcastStream({
    void Function(StreamSubscription<LogItem> subscription)? onListen,
    void Function(StreamSubscription<LogItem> subscription)? onCancel,
  }) =>
      streamController.stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

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
