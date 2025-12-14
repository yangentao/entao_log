part of '../../entao_log.dart';

/// 2秒会flush()一下.
class FilePrinter extends DelayPrinter {
  final File file;

  FilePrinter(this.file, {super.delay = 2000});

  @override
  FutureOr<void> flush(String text) {
    file.writeAsStringSync(text, mode: FileMode.append, flush: false);
  }
}
