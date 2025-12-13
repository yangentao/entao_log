part of '../../entao_log.dart';

class DirPrinter extends DelayPrinter {
  final Directory dir;
  final String baseName;
  final String extName;
  final int maxDays;
  final int maxFileCount;
  final int singleFileSize;
  FilePrinter? _filePrinter;
  int _dayFile = 0;
  int _preCheckTime = 0;

  late final RegExp _nameReg = RegExp("${baseName}_\\d{4}-\\d{2}-\\d{2}\\.\\d+\\.$extName");

  DirPrinter(
      {required this.dir,
      this.baseName = "app",
      this.extName = "log",
      super.delay = 2000,
      this.maxDays = 30,
      this.maxFileCount = 200,
      this.singleFileSize = 20 * 1024 * 1024}) {
    assert(maxDays > 0);
    assert(baseName.isNotEmpty);
    assert(extName.isNotEmpty);
    assert(maxFileCount > 0);
    assert(singleFileSize > 0);

    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  FilePrinter _checkFile() {
    DateTime today = DateTime.now();

    if (_filePrinter == null) {
      return createNewFile(today);
    }
    if (today.millisecondsSinceEpoch < _preCheckTime + 300_000) {
      return _filePrinter!;
    }
    _preCheckTime = today.millisecondsSinceEpoch;

    int sz = _filePrinter!.file.lengthSync();
    if (sz > singleFileSize) {
      return createNewFile(today);
    }
    int day = DateTime.now().day;
    if (day != _dayFile) {
      return createNewFile(today);
    }
    return _filePrinter!;
  }

  FilePrinter createNewFile(DateTime today) {
    FilePrinter? oldFp = _filePrinter;
    if (oldFp != null) {
      oldFp.close();
      File oldFile = oldFp.file;
      _filePrinter = null;
      File backFile = _makeBackupFile(today);
      oldFile.renameSync(backFile.path);
    }

    _dayFile = today.day;
    File newFile = File(path.join(dir.path, "$baseName.$extName"));
    if (newFile.existsSync()) {
      DateTime fileDate = newFile.statSync().modified;
      if (!fileDate.sameDay(today)) {
        File backFile = _makeBackupFile(fileDate);
        newFile.renameSync(backFile.path);
      }
    }
    _deleteExpired();
    FilePrinter fs = FilePrinter(newFile, delay: delay);
    _filePrinter = fs;
    return fs;
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
  void flush(String item) {
    FilePrinter fs = _checkFile();
    fs.flush(item);
  }
}
