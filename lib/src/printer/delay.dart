part of '../../entao_log.dart';

/// delay,  milliseconds
abstract class DelayPrinter extends LogPrinter {
  final List<String> buffer = [];
  final int? maxLine;
  final int delay;
  late final _MergeCall _mergeCall;

  DelayPrinter({super.level, super.tags, this.maxLine, this.delay = 2000}) {
    _mergeCall = _MergeCall(_flush, delay: delay, interval: true);
  }

  void flush(String item);

  @override
  Future<dynamic> close() {
    _flush();
    return super.close();
  }

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
    _mergeCall.trigger();
  }
}
