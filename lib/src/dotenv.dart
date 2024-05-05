library dotenv;

import 'dart:io';

import 'package:meta/meta.dart';

part 'parser.dart';

final _env = <String, String>{
  ...Platform.environment,
};

@visibleForTesting
Map<String, String> get loadedEnv => _env;

/// Loads key-value pairs from a file into a [Map<String, String>].
///
/// The parser will attempt to handle simple variable substitution,
/// respect single- vs. double-quotes, and ignore `#comments` or the `export` keyword.
class DotEnv {
  static late DotEnv _instance;
  static bool _isInitialized = false;

  /// Returns an instance of [DotEnv] with default [DefaultParser].
  ///
  /// ```dart
  /// final myVar = DotEnv.instance['MY_VAR'];
  /// ```
  ///
  /// If you need a custom .env file parser, create a new instance of [DotEnv].
  ///
  /// ```dart
  /// class CustomParser implements Parser {
  ///   Map<String, String> parse(Iterable<String> lines) {
  ///     // custom implementation
  ///  }
  /// }
  ///
  /// final env = DotEnv(CustomParser())..load();
  static DotEnv get instance {
    if (!_isInitialized) {
      _instance = const DotEnv()..load();
      _isInitialized = true;
    }

    return _instance;
  }

  final DefaultParser _parser;

  const DotEnv([this._parser = const DefaultParser()]);

  /// Reads the value for [key] from the underlying map.
  ///
  /// Returns `null` if [key] is absent.  See [isDefined].
  String? operator [](String key) => _env[key];

  /// Calls [Map.addAll] on the underlying map.
  void addAll(Map<String, String> other) => _env.addAll(other);

  /// Calls [Map.clear] on the underlying map.
  void clear() {
    _env.clear();
  }

  /// Equivalent to [operator []] when the underlying map contains [key],
  /// and the value is non-empty.  See [isDefined].
  ///
  /// Otherwise, calls [orElse] and returns the value.
  String getOrElse(String key, String Function() orElse) =>
      isDefined(key) ? _env[key]! : orElse();

  /// True if [key] has a nonempty value in the underlying map.
  ///
  /// Differs from [Map.containsKey] by excluding empty values.
  bool isDefined(String key) => _env[key]?.isNotEmpty ?? false;

  /// True if all supplied [vars] have nonempty value; false otherwise.
  ///
  /// See [isDefined].
  bool isEveryDefined(Iterable<String> vars) => vars.every(isDefined);

  /// Parses environment variables from each path in [filenames], and adds them
  /// to the underlying [Map].
  ///
  /// Logs to [stderr] if any file does not exist; see [quiet].
  void load([
    Iterable<String> filenames = const ['.env'],
  ]) {
    for (var filename in filenames) {
      final uri = Uri.file(filename);
      final f = File.fromUri(uri);

      if (f.existsSync()) {
        final content = f.readAsLinesSync();
        final parsed = _parser.parse(content);
        _env.addAll(parsed);
      }
    }
  }
}
