import 'package:entao_log/entao_log.dart';
import 'package:println/println.dart';
import 'package:test/test.dart';

void main() {
  test('Log Test', () {
    logv("this", "is", "verbose");
    logd("this", "is", "debug", sep: ",");
    logw("this is", "warning", tag: "HTTP", sep: ", ");
    loge("this is", " error");
  });

  test("tag", () {
    TagLog sql = TagLog("SQL");
    // sql.off();
    sql.d("create table if no exist");
    // sql.on(level: LogLevel.error);
    sql.d("create table if no exist");
    sql.e("create table if no exist");
  });
}
