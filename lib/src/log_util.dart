part of '../entao_log.dart';

const bool _isReleaseMode = bool.fromEnvironment('dart.vm.product');
const bool _isProfileMode = bool.fromEnvironment('dart.vm.profile');
const bool _isDebugMode = !_isReleaseMode && !_isProfileMode;

extension _DateTimeExt on DateTime {
  String get formatDateTimeX =>
      "${year.formated("0000")}-${month.formated("00")}-${day.formated("00")} ${hour.formated("00")}:${minute.formated("00")}:${second.formated("00")}.${millisecond.formated("000")}";

  String get formatDate => "${year.formated("0000")}-${month.formated("00")}-${day.formated("00")}";

  bool sameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

extension _NumFormatExt on num {
  String formated(String f) {
    return toString().padLeft(f.length, '0');
  }
}

String _logArgsToString(List<dynamic> list, Map<String, dynamic> map, {required String sep}) {
  String a = list.map((e) => _anyToString(e)).join(sep);
  if (map.isEmpty) return a;
  String b = map.entries.where((e) => !e.key.startsWith(r'$')).map((e) => '${e.key}: ${_anyToString(e.value)}').join(sep);
  return '$a$sep$b';
}

String _anyToString(dynamic value) {
  switch (value) {
    case null:
      return "null";
    case String s:
      return s;
    case num n:
      return n.toString();
    default:
      return value.toString();
  }
}

int get _millsNow => DateTime.now().millisecondsSinceEpoch;

Map<Object, MapEntry<int, void Function()>> _mergeMap = {};

void _mergeCall(Object key, void Function() callback, {int delay = 1000, bool interval = false}) {
  if (_mergeMap.containsKey(key)) {
    _mergeMap[key] = MapEntry(_millsNow, callback);
    return;
  }
  _mergeMap[key] = MapEntry(_millsNow, callback);

  void invokeCallback() {
    if (interval) {
      _mergeMap.remove(key)?.value.call();
    } else {
      MapEntry<int, void Function()>? e = _mergeMap[key];
      if (e == null) return;
      int leftMills = e.key + delay - _millsNow;
      if (leftMills <= 0) {
        _mergeMap.remove(key)?.value.call();
      } else {
        Future.delayed(Duration(milliseconds: leftMills), invokeCallback);
      }
    }
  }

  Future.delayed(Duration(milliseconds: delay), invokeCallback);
}

class LogCall {
  final void Function(List<dynamic> list, Map<String, dynamic> map) callback;

  LogCall(this.callback);

  void call() {
    return callback([], {});
  }

  //Symbol("x") => x
  String _symbolText(Symbol sym) {
    String s = sym.toString();
    return s.substring(8, s.length - 2);
  }

  @override
  void noSuchMethod(Invocation invocation) {
    List<dynamic> list = invocation.positionalArguments.toList();
    Map<String, dynamic> map = invocation.namedArguments.map((sym, v) {
      return MapEntry(_symbolText(sym), v);
    });
    callback(list, map);
  }
}
