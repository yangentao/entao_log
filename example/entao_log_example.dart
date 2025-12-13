import 'dart:io';

import 'package:entao_log/entao_log.dart';

//
// 2025-05-18 15:27:48.706 D xlog: Hello Tom 1 2 3
// 2025-05-18 15:27:48.708 E tom: Hello Tom 1 2 3
// 2025-05-18 15:27:48.709 E yet: tag log hello
// 2025-05-18 15:27:48.709 I yet: tag log info 12 3
// 2025-05-18 15:27:48.709 E xlog: e1
//

void main() async {
  _normal();
  _tagLog();
  // XLog.onExit();
}

void _normal() {
  logd("Hello", "Tom", 1, 2, 3);
  loge("Hello", "Tom", 1, 2, 3, tag: "tom");
}

void _tagLog() {
  var lg = TagLog("yet");
  lg.e("tag log hello");
  lg.i("tag log info", 12, 3);
}

// ignore: unused_element
void _fileLog() {
  var p = FileLogPrinter(File("/Users/entao/Downloads/a.txt"));
  var c = ConsolePrinter.inst;
  c.level = LogLevel.warning;
  var tree = TreeLogPrinter([p, c]);
  // XLog.setPrinter(tree);

  logd("to file");
}
