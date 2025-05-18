import 'dart:io';

import 'package:entao_log/entao_log.dart';

void main() {
  var dp = DirLogPrinter(dir: Directory("/Users/entao/Downloads/d"), maxFileCount: 5, singleFileSize: 10000, checkLineCount: 10);
  XLog.setPrinter(dp);
  for (int i = 0; i < 1000; ++i) {
    logd("this is debug");
    loge("this is error");
    logw("this is warning");
  }
  XLog.onExit();
}
