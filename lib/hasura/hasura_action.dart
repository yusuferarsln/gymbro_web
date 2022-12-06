import 'type_def.dart';

abstract class HasuraAction {
  HasuraAction({
    required this.method,
    required this.parameters,
    required this.returning,
  });

  final String method;
  final JsonMap parameters;
  final Set returning;

  @override
  String toString() {
    return '''
      $method(${_parseParameters(parameters)})
      ${_parseReturning(returning)}
    ''';
  }

  static String _parseParameters(dynamic value, {bool outerBrackets = false}) {
    if (value == null) {
      return '{}';
    } else if (value is String) {
      return value.startsWith('\$')
          ? value.replaceAll('\\', '')
          : '"${value.replaceAll('"', '\\"')}"';
    } else if (value is Map) {
      final withoutBrackets = value.keys.where((k) {
        return value[k] != null;
      }).map((k) {
        return '$k: ${_parseParameters(value[k], outerBrackets: true)}';
      }).join(', ');
      return outerBrackets ? '{$withoutBrackets}' : withoutBrackets;
    } else {
      return '$value';
    }
  }

  static String _parseReturning(dynamic value) {
    if (value is Map) {
      return value.keys.map((k) {
        return '$k ${_parseReturning(value[k])}';
      }).join(' ');
    } else if (value is MapEntry) {
      return '${value.key} ${_parseReturning(value.value)}';
    } else if (value is Iterable) {
      return '{${value.map((v) {
        return _parseReturning(v);
      }).join(' ')}}';
    } else {
      return '$value';
    }
  }
}
