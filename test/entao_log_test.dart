import 'package:entao_log/entao_log.dart';
import 'package:println/println.dart';
import 'package:test/test.dart';

void main() {
  test('Log Test', () {
    ConsolePrinter.setEscapeCodes(LogLevel.warning, [EscapeCode.foreYellow, EscapeCode.backCyan]);
    logv("this", "is", "verbose");
    logd("this", "is", "debug", sep: ",");
    logw("this is", "warning", tag: "HTTP", sep: ", ");
    loge("this is", " error");
  });
}
