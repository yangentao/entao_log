import 'package:entao_log/entao_log.dart';

void main() async  {
  xlog.stream.pipe(LogConsole());
  // xlog.stream.listen((v){
  //   LogConsole.instance.add(v);
  // });
  logd("hello");
}

class AA {}
