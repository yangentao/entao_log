typedef LogVarargCallback = void Function(List<dynamic> args, Map<String, dynamic> kwargs);

class LogVarargFunction {
  final LogVarargCallback callback;

  LogVarargFunction(this.callback);

  void call() => callback([], {});

  //Symbol("x")
  String _symbolText(Symbol sym) {
    String s = sym.toString();
    return s.substring(8, s.length - 2);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return callback(
      invocation.positionalArguments,
      invocation.namedArguments.map(
            (sym, v) {
          return MapEntry(_symbolText(sym), v);
        },
      ),
    );
  }
}