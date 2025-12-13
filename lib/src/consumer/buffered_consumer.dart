part of '../../entao_log.dart';

/// delay,  milliseconds
abstract class BufferedLogConsumer extends LogSink {
  final List<String> buffer = [];
  final int? maxLine;
  final int delay;

  BufferedLogConsumer({super.level, super.tags, this.maxLine, this.delay = 2000});

  FutureOr<void> flush(String item);

  void _flush() {
    if (buffer.isEmpty) return;
    String s = buffer.map((s) => '$s\n').join('');
    buffer.clear();
    flush(s);
  }

  @override
  FutureOr<void> println(LogItem item) async {
    buffer.add(item.toString());
    if (maxLine != null && buffer.length >= maxLine!) {
      _flush();
      return;
    }
    _mergeCall('$this-${this.hashCode}', _flush, delay: delay, interval: true);
  }
}
