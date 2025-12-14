## dart log

### Example

```dart

void main() async {
  xlog.pipe(ConsolePrinter());
  // xlog.pipe(FilePrinter(File('/Users/xxx/Downloads/a.txt'), delay: 1000).on(level: LogLevel.info));
  // xlog.pipe(DirPrinter(dir: Directory("/Users/xxx/Downloads/xlog"), delay: 1000).on(level: LogLevel.error));
  logd("Hello", "Tom", 1, 2, 3);
  loge("Hello", "Tom", 1, 2, 3, name: "tom", $tag:'Animal');

  var lg = TagLog("yet");
  lg.e("tag log hello");
  lg.i("tag log info", 12, 3);
}

```  