import 'dart:async';

import 'package:entao_log/entao_log.dart';

void main() async {
  testLog();
  await Future.delayed(Duration(seconds: 1));
}

void testLog() async {
  // xlog.stream.stream.map((e) => utf8.encode(e.toString()) as List<int>).pipe(stdout);
  // xlog.stream.stream.pipe(MyConsumer());
  xlog.stream.pipe(LogConsole());
  // xlog.stream.stream.listen(print);
  // xlog.stream.stream.listen((v) => print(v));
  // FileSink fs = FileSink(File('/Users/entao/Downloads/a.txt'));
  // xlog.stream.pipe(fs);
  // xlog.stream.listen((v){
  //   LogConsole.instance.add(v);
  // });
  logd("hello", "entao", name: 'Jerry', age: 8);
  // logd("hello", "entao", name: 'Jerry', age: 8, $tag: "Animal");
  // loge("hello", "entao", name: 'Jerry', age: 8);
  // TagLog a = TagLog("SQL");
  // a.d('INSERT INTO Person');
}

void testBroadcast() async {
  StreamController<int> b = StreamController<int>.broadcast();
  b.add(1);
  b.stream.listen((v) => print(v));
  b.stream.listen((v) => print(v * v));
  b.add(11);
  b.add(111);
  Future.delayed(Duration(seconds: 1), () => b.close());
}

class MyConsumer implements StreamConsumer<LogItem> {
  MyConsumer();

  @override
  Future addStream(Stream<LogItem> stream) {
    var completer = Completer();
    late StreamSubscription<LogItem> sub;
    sub = stream.listen(
      (data) {
        try {
          print(data);
        } catch (e, s) {
          sub.cancel();
          completer.completeError(e, s);
        }
      },
      onError: completer.completeError,
      onDone: completer.complete,
      cancelOnError: true,
    );
    return completer.future;
  }

  @override
  Future close() {
    return Future.value();
  }
}
