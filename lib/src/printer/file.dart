part of '../../entao_log.dart';

/// 5秒会flush()一下.
class FilePrinter extends DelayPrinter {
  final File file;

  FilePrinter(this.file, {super.delay = 2000});

  @override
  FutureOr<void> flush(String item) {
    file.writeAsString(item, mode: FileMode.append);
  }
}
