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

String _anyListToString(List<dynamic> messages, {String? sep}) {
  return messages.map((e) => _anyToString(e)).join(sep ?? " ");
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
