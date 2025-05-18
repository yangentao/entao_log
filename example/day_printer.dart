import 'dart:io';

import 'package:entao_log/entao_log.dart';

void main() {
  var dp = DirLogPrinter(dir: Directory("/Users/entao/Downloads/d"));
  XLog.setPrinter(dp);
  logd("this is debug");
  loge("this is error");
  logw("this is warning");
}
