import 'dart:io';

void main() async {
  String atxt = "/Users/entao/Downloads/a.txt";
  int t = DateTime.now().millisecondsSinceEpoch;
  for (int i = 0; i < 100; ++i) {
    File(atxt).writeAsStringSync("$i $atxt \n", mode: FileMode.append, flush: false  );
  }
  int delta = DateTime.now().millisecondsSinceEpoch - t;
  print("Done ${delta }"); // 9
}
