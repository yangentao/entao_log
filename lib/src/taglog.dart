part of '../entao_log.dart';

dynamic logv = AnyCall<void>(
  callback: (args, kwargs) {
    XLog.logItem(LogLevel.verbose, args, tag: kwargs["\$tag"], sep: kwargs["\$sep"]);
  },
);

dynamic logd = AnyCall<void>(
  callback: (args, kwargs) {
    XLog.logItem(LogLevel.debug, args, tag: kwargs["\$tag"], sep: kwargs["\$sep"]);
  },
);

dynamic logi = AnyCall<void>(
  callback: (args, kwargs) {
    XLog.logItem(LogLevel.info, args, tag: kwargs["\$tag"], sep: kwargs["\$sep"]);
  },
);

dynamic logw = AnyCall<void>(
  callback: (args, kwargs) {
    XLog.logItem(LogLevel.warning, args, tag: kwargs["\$tag"], sep: kwargs["\$sep"]);
  },
);

dynamic loge = AnyCall<void>(
  callback: (args, kwargs) {
    XLog.logItem(LogLevel.error, args, tag: kwargs["\$tag"], sep: kwargs["\$sep"]);
  },
);

class TagLog {
  String tag;

  TagLog(this.tag);

  void on({LogLevel level = LogLevel.all}) {
    XLog.on(tag: tag, level: level);
  }

  void off() {
    XLog.off(tag: tag);
  }

  late dynamic v = AnyCall<void>(
    callback: (args, kwargs) {
      XLog.logItem(LogLevel.verbose, args, tag: kwargs["\$tag"] ?? tag, sep: kwargs["\$sep"]);
    },
  );
  late dynamic d = AnyCall<void>(
    callback: (args, kwargs) {
      XLog.logItem(LogLevel.debug, args, tag: kwargs["\$tag"] ?? tag, sep: kwargs["\$sep"]);
    },
  );
  late dynamic w = AnyCall<void>(
    callback: (args, kwargs) {
      XLog.logItem(LogLevel.warning, args, tag: kwargs["\$tag"] ?? tag, sep: kwargs["\$sep"]);
    },
  );
  late dynamic i = AnyCall<void>(
    callback: (args, kwargs) {
      XLog.logItem(LogLevel.info, args, tag: kwargs["\$tag"] ?? tag, sep: kwargs["\$sep"]);
    },
  );
  late dynamic e = AnyCall<void>(
    callback: (args, kwargs) {
      XLog.logItem(LogLevel.error, args, tag: kwargs["\$tag"] ?? tag, sep: kwargs["\$sep"]);
    },
  );
}
