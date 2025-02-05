import 'package:{{packageName.snakeCase()}}/core/utils/helpers/keys/navigator_keys.dart';

/// A container for holding global keys used throughout the application.
///
/// This class provides a structured way to access specific keys,
/// like those used for localization or other functionality,
/// making it easier to manage and avoid key duplication.
///
/// Example usage:
/// ```dart
/// final keys = Keys();
/// print(keys.localizationKeys.someKey);
/// ```
final keys = Keys();

/// A class that encapsulates different groups of keys used in the application.
///
/// Each property of this class represents a specific grouping of keys, such as
/// keys for localization, widgets, or other features. This approach helps in
/// maintaining a consistent and organized structure.
class Keys {
  /// The keys used for navigating within the application.
  final NavigatorKeys navigatorKeys = NavigatorKeys();
}
