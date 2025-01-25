import 'package:{{packageName}}/core/utils/helpers/keys/localization_keys.dart';

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
  /// The keys related to localization module in the application.
  ///
  /// This group contains all the keys used for managing translations
  /// and localized content.
  final LocalizationKeys localizationKeys = LocalizationKeys();
}
