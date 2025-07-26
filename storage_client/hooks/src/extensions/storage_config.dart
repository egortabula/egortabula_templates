// Добавляем в конец файла pre_gen.dart

import '../models/models.dart';

/// Расширение для дополнительных утилит конфигурации
extension StorageConfigExtensions on StorageConfig {
  /// Валидирует конфигурацию и выбрасывает исключения при ошибках
  void validate() {
    // Проверяем что выбран хотя бы один метод
    if (methods.enabledMethods.isEmpty) {
      throw ArgumentError('At least one storage method must be selected');
    }

    // Проверяем что выбрана хотя бы одна реализация
    if (implementations.enabledImplementations.isEmpty) {
      throw ArgumentError(
        'At least one storage implementation must be selected',
      );
    }

    // Проверяем совместимость методов и реализаций
    if (methods.hasCollectionMethods &&
        !implementations.hasSharedPrefsImplementations) {
      throw ArgumentError(
        'Collection methods (getKeys, isEmpty, isNotEmpty) require SharedPreferences implementations',
      );
    }

    // Логика валидации для конкретных комбинаций
    if (methods.includeGetKeys && !_supportsGetKeys()) {
      throw ArgumentError(
        'getKeys method is not supported by selected implementations',
      );
    }
  }

  bool _supportsGetKeys() {
    // Проверяем какие реализации поддерживают getKeys
    return implementations.includeSharedPrefsAsync ||
        implementations.includeSharedPrefsSync ||
        implementations.includeSharedPrefsCache ||
        implementations.includeHiveString ||
        implementations.includeHiveModel;
  }

  /// Предупреждения о конфигурации
  List<String> get warnings {
    final warnings = <String>[];

    if (methods.includeIsEmpty && methods.includeIsNotEmpty) {
      warnings.add(
        'Both isEmpty and isNotEmpty are selected - consider using only one',
      );
    }

    if (implementations.hasSecureStorage && !methods.hasBasicMethods) {
      warnings.add('Secure storage selected without basic read/write methods');
    }

    return warnings;
  }

  /// Рекомендации по оптимизации
  List<String> get suggestions {
    final suggestions = <String>[];

    if (methods.includeRead && !methods.includeContainsKey) {
      suggestions.add('Consider adding containsKey method for safer reads');
    }

    if (methods.includeWrite && !methods.includeDelete) {
      suggestions.add('Consider adding delete method for data cleanup');
    }

    return suggestions;
  }
}
