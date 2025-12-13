part of '../entao_log.dart';

typedef LogFormatter = String Function(LogItem item);

String defaultLogFormatter(LogItem item) => "${item.time.formatDateTimeX} ${item.level.firstChar} ${item.tag}: ${item.message}";
