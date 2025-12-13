part of '../entao_log.dart';

class DirLogPrinter extends LogPrinter {
  final Directory dir;
  final String baseName;
  final String extName;
  final int maxDays;
  final int maxFileCount;
  final int singleFileSize;
  final int checkLineCount;

  late final RegExp _nameReg = RegExp("${baseName}_\\d{4}-\\d{2}-\\d{2}\\.\\d+\\.$extName");
  FileLogPrinter? _filePrinter;
  int _lines = 0;
  int _dayFile = 0;

  DirLogPrinter(
      {required this.dir,
      this.baseName = "app",
      this.extName = "log",
      this.maxDays = 30,
      this.maxFileCount = 200,
      this.singleFileSize = 20 * 1024 * 1024,
      this.checkLineCount = 200}) {
    assert(maxDays > 0);
    assert(baseName.isNotEmpty);
    assert(extName.isNotEmpty);
    assert(maxFileCount > 0);
    assert(singleFileSize > 0);
    assert(checkLineCount > 0);

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  void _checkFile() {
    if (_filePrinter == null) {
      createNewFile();
      return;
    }
    if (_lines > checkLineCount) {
      int sz = _filePrinter!.file.lengthSync();
      if (sz > singleFileSize) {
        createNewFile();
        return;
      }
    }
    int day = DateTime.now().day;
    if (day != _dayFile) {
      createNewFile();
    }
  }

  void createNewFile() {
    _dayFile = DateTime.now().day;
    _lines = 0;
    File newFile = File(path.join(dir.path, "$baseName.$extName"));
    FileLogPrinter? fp = _filePrinter;
    if (fp != null) {
      File oldFile = fp.file;
      fp.dispose();
      _filePrinter = null;
      File backFile = _makeBackupFile(DateTime.now());
      oldFile.renameSync(backFile.path);
    } else {
      if (newFile.existsSync()) {
        DateTime fileDate = newFile.statSync().modified;
        if (!fileDate.sameDay(DateTime.now())) {
          File backFile = _makeBackupFile(fileDate);
          newFile.renameSync(backFile.path);
        }
      }
    }
    _filePrinter = FileLogPrinter(newFile);
    _deleteExpired();
  }

  File _makeBackupFile(DateTime date) {
    String ds = date.formatDate;
    RegExp reg = RegExp("${baseName}_$ds\\.(\\d+)\\.$extName");
    int idx = 0;
    List<FileSystemEntity> feList = dir.listSync();
    for (var fe in feList) {
      var m = reg.allMatches(path.basename(fe.path)).toList();
      if (m.isNotEmpty) {
        var ns = m[0].group(1);
        if (ns == null) continue;
        int n = int.parse(ns);
        if (n > idx) idx = n;
      }
    }
    idx += 1;
    File f = File(path.join(dir.path, "${baseName}_$ds.$idx.$extName"));
    while (f.existsSync()) {
      idx += 1;
      f = File(path.join(dir.path, "${baseName}_$ds.$idx.$extName"));
    }
    return f;
  }

  bool _isLogFile(FileSystemEntity fe) {
    var name = path.basename(fe.path);
    return fe.statSync().type == FileSystemEntityType.file && _nameReg.allMatches(name).isNotEmpty;
  }

  void _deleteExpired() {
    if (maxDays <= 0) return;
    List<FileSystemEntity> fs = dir.listSync().where((e) => _isLogFile(e)).toList();
    fs.sort((a, b) => a.statSync().modified.millisecondsSinceEpoch - b.statSync().modified.millisecondsSinceEpoch);
    if (fs.isEmpty) return;
    DateTime delDate = DateTime.now().add(Duration(days: -maxDays));
    int tm = delDate.millisecondsSinceEpoch;
    int minIndex = fs.length - maxFileCount;
    for (int i = 0; i < fs.length; ++i) {
      FileSystemEntity fe = fs[i];
      if (i < minIndex) {
        fe.delete();
      } else if (fe.statSync().modified.millisecondsSinceEpoch < tm) {
        fe.delete();
      } else {
        break;
      }
    }
  }

  @override
  void printItem(LogItem item) {
    _lines += 1;
    _checkFile();
    _filePrinter?.printItem(item);
    _filePrinter?.flush();
  }

  @override
  void dispose() {
    _lines = 0;
    _filePrinter?.dispose();
    _filePrinter = null;
  }

  @override
  void flush() {
    _filePrinter?.flush();
  }
}
