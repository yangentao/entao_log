part of '../entao_log.dart';

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
  String b = map.entries.where((e) => !e.key.startsWith(r'$')).map((e) => '${e.key}:${_anyToString(e.value)}').join(sep);
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

class _MergeCall {
  final void Function() _callback;
  final int _delay;
  final bool _interval;
  int _lastTime = 0;

  _MergeCall(this._callback, {int delay = 1000, bool interval = false})
      : _interval = interval,
        _delay = delay;

  void trigger() {
    int mills = DateTime.now().millisecondsSinceEpoch;
    if (_lastTime + _delay > mills) {
      _lastTime = mills;
      return;
    }
    _lastTime = mills;

    void invokeCallback() {
      if (_interval) {
        _lastTime = 0;
        _callback();
      } else {
        if (_lastTime == 0) return;
        int leftMills = _lastTime + _delay - DateTime.now().millisecondsSinceEpoch;
        if (leftMills <= 0) {
          _lastTime = 0;
          _callback();
        } else {
          Future.delayed(Duration(milliseconds: leftMills), invokeCallback);
        }
      }
    }

    Future.delayed(Duration(milliseconds: _delay), invokeCallback);
  }
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
