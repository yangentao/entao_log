import 'dart:async';
import 'dart:io';

import 'package:entao_log/entao_log.dart';

void main() async {
  xlog.pipe(ConsolePrinter().on(level: LogLevel.all));
  xlog.pipe(FilePrinter(File('/Users/entao/Downloads/a.txt'), delay: 1000).on(level: LogLevel.info));
  xlog.pipe(DirPrinter(dir: Directory("/Users/entao/Downloads/xlog"), delay: 1000).on(level: LogLevel.error));

  for (int i = 0; i < 20; ++i) {
    logd(i, "hello", "entao", name: 'Jerry', age: 8);
    logi(i, "hello", "entao", name: 'Jerry', age: 8);
    loge(i, "hello", "entao", name: 'Jerry', age: 8);
    await Future.delayed(Duration(seconds: 1));
  }
  await Future.delayed(Duration(seconds: 1));
}
