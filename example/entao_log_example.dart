import 'dart:io';

import 'package:entao_log/entao_log.dart';

void main() {
  var p = FileLogPrinter(File("/Users/entao/Downloads/a.txt"));
  var tree = TreeLogPrinter([p, ConsolePrinter.inst]);
  ConsolePrinter.inst.level = LogLevel.WARNING;
  // XLog.setPrinter(BufPrinter());
  XLog.setPrinter(tree);
  _testLog();
  // await delayMills(3000);
  _testLog();
  // await delayMills(3000);
  _testLog();
  // await delayMills(3000);
  _testLog();
}

void _testLog() {
  logv("yang", tag: "hello", 12, 3);
  logd("debug", "Entao", 9999);
  logi("info");
  logw("hello ");
  loge("error");
  var lg = TagLog("yet");
  lg.e("hello tag");
  lg.i("info", 12, 3);
}
