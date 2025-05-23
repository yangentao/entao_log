part of 'log.dart';

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
