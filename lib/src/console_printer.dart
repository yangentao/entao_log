part of 'log.dart';

class ConsolePrinter extends LogPrinter {
  static final Map<LogLevel, List<EscapeCode>> _map = {
    LogLevel.verbose: [EscapeCode.bold, EscapeCode.italic],
    LogLevel.info: [EscapeCode.bold],
    LogLevel.warning: [EscapeCode.yellow],
    LogLevel.error: [EscapeCode.red],
    LogLevel.fatal: [EscapeCode.red, EscapeCode.italic],
  };

  ConsolePrinter._internal() {
    if (!_isDebugMode) {
      level = LogLevel.off;
    }
  }

  static void setEscapeCodes(LogLevel level, List<EscapeCode>? codes) {
    if (codes == null) {
      _map.remove(level);
    } else {
      _map[level] = codes;
    }
  }

  @override
  void printItem(LogItem item) {
    var ls = _map[item.level];
    if (ls == null) {
      print(item.toString());
    } else {
      print(ls.map((e) => e.escapeText).join("") + item.toString() + EscapeCode.reset.escapeText);
    }
  }

  static final ConsolePrinter inst = ConsolePrinter._internal();
}

enum EscapeCode {
  reset("0"),
  bold("1"),
  faint("2"),
  italic("3"),
  underline("4"),
  black("30"),
  red("31"),
  green("32"),
  yellow("33"),
  blue("34"),
  magenta("35"),
  cyan("36"),
  white("37"),
  blackLight("90"),
  redLight("91"),
  greenLight("92"),
  yellowLight("93"),
  blueLight("94"),
  magentaLight("95"),
  cyanLight("96"),
  whiteLight("97"),
  backBlack("40"),
  backRed("41"),
  backGreen("42"),
  backYellow("43"),
  backBlue("44"),
  backMagenta("45"),
  backCyan("46"),
  backWhite("47"),
  backBlackLight("100"),
  backRedLight("101"),
  backGreenLight("102"),
  backYellowLight("103"),
  backBlueLight("104"),
  backMagentaLight("105"),
  backCyanLight("106"),
  backWhiteLight("107");

  final String code;

  const EscapeCode(this.code);

  String get escapeText => "\u001b[${code}m";
}
