import 'package:entao_log/entao_log.dart';

void main() async {
  xlog.stream.pipe(LogConsole(level: LogLevel.debug));
  // xlog.stream.listen((v){
  //   LogConsole.instance.add(v);
  // });
  logd("hello", "entao", name: 'Jerry', age: 8);
  logd("hello", "entao", name: 'Jerry', age: 8, $tag: "Animal");
  loge("hello", "entao", name: 'Jerry', age: 8);
  TagLog a = TagLog("SQL");
  a.d('INSERT INTO Person');
}

class AA {}
