/// Loads environment variables from a `.env` file and merges with
/// `Platform.environment`.
///
/// ## usages
///
/// Use the default instance of [DotEnv] to read env vars:
///
///    import 'package:dotenv/dotenv.dart';
///
///    void main() {
///      final myVar = DotEnv.instance['MY_VAR'];
///    }
///
/// Use `DotEnv(parser)..load()` to create a `DotEnv` instance
/// with a custom parser:
///
///     import 'package:dotenv/dotenv.dart';
///
///     class CustomParser implements Parser {
///       Map<String, String> parse(Iterable<String> lines) {
///         // custom implementation
///       }
///     }
///
///     void main() {
///       final env = DotEnv(CustomParser())..load();
///       final foo = env['foo'];
///       final homeDir = env['HOME'];
///       // ...
///     }
///
/// Verify required variables are present:
///
///     const _requiredEnvVars = ['host', 'port'];
///     bool get hasEnv => env.isEveryDefined(_requiredEnvVars);
export 'package:dotenv/src/dotenv.dart' show DotEnv, Parser;
