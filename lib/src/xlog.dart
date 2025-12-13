part of '../entao_log.dart';

/// logd("Hello", "Jerry");
/// logd("Hello", "Jerry", name: "Tom", $tag:"SQL");
dynamic logv = LogCall((list, map) => xlog._add(LogLevel.verbose, list, map));
dynamic logd = LogCall((list, map) => xlog._add(LogLevel.debug, list, map));
dynamic logi = LogCall((list, map) => xlog._add(LogLevel.info, list, map));
dynamic logw = LogCall((list, map) => xlog._add(LogLevel.warning, list, map));
dynamic loge = LogCall((list, map) => xlog._add(LogLevel.error, list, map));

/// xlog.d("Hello", "Jerry");
/// xlog.d("Hello", "Jerry", name: "Tom", $tag:"SQL");
class xlog {
  xlog._();

  static final LogStream stream = LogStream();
  static String TAG = "xlog";
  static LogFormatter formatter = defaultLogFormatter;
  static LogFilter filter = (item) => true;
  static LogLevel level = LogLevel.all;
  static String separator = ' ';

  static StreamSubscription<String> listenText(void Function(String event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return xlog.stream.map((e) => e.toString()).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static StreamSubscription<LogItem> listen(void Function(LogItem event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return xlog.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  static Future pipe(StreamConsumer<LogItem> streamConsumer) {
    return stream.pipe(streamConsumer);
  }

  static void _add(LogLevel level, List<dynamic> list, Map<String, dynamic> map) {
    if (level.index < xlog.level.index) return;
    LogItem item = LogItem(level: level, message: _logArgsToString(list, map, sep: xlog.separator), tag: map[r"$tag"] ?? TAG, formatter: formatter);
    if (!xlog.filter(item)) return;
    xlog.stream.add(item);
  }

  late dynamic v = LogCall((list, map) => _add(LogLevel.verbose, list, map));
  late dynamic d = LogCall((list, map) => _add(LogLevel.debug, list, map));
  late dynamic i = LogCall((list, map) => _add(LogLevel.info, list, map));
  late dynamic w = LogCall((list, map) => _add(LogLevel.warning, list, map));
  late dynamic e = LogCall((list, map) => _add(LogLevel.error, list, map));
}

/// final a = TagLog('SQL')
/// a.d('Hello", name: 'Jerry')
class TagLog {
  final LogStream stream = xlog.stream;
  final String tag;
  final LogLevel level;
  final LogFilter filter;
  final LogFormatter formatter;
  final String separator;

  TagLog(this.tag, {this.level = LogLevel.all, this.formatter = defaultLogFormatter, this.filter = logAcceptAll, this.separator = ' '});

  void _add(LogLevel level, List<dynamic> list, Map<String, dynamic> map) {
    if (level.index < this.level.index) return;
    LogItem item = LogItem(level: level, message: _logArgsToString(list, map, sep: separator), tag: tag, formatter: formatter);
    if (!filter(item)) return;
    stream.add(item);
  }

  late dynamic v = LogCall((list, map) => _add(LogLevel.verbose, list, map));
  late dynamic d = LogCall((list, map) => _add(LogLevel.debug, list, map));
  late dynamic i = LogCall((list, map) => _add(LogLevel.info, list, map));
  late dynamic w = LogCall((list, map) => _add(LogLevel.warning, list, map));
  late dynamic e = LogCall((list, map) => _add(LogLevel.error, list, map));
}
