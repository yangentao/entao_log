part of '../../entao_log.dart';

/// 5秒会flush()一下.
class FileSink extends DelayLogConsumer {
  final File file;

  FileSink(this.file, {super.delay = 2000});

  @override
  FutureOr<void> flush(String item) {
    file.writeAsString(item, mode: FileMode.append);
  }
}
