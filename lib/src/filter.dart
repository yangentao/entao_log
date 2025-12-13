part of '../entao_log.dart';

typedef LogFilter = bool Function(LogItem);

bool logAcceptAll(LogItem _) => true;
