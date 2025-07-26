import 'models.dart';

/// Модель конфигурации для генерации storage клиента
class StorageConfig {
  const StorageConfig({
    required this.implementations,
    required this.methods,
  });

  /// Фабричный метод для создания конфигурации из Mason vars
  factory StorageConfig.fromVars(Map<String, dynamic> vars) {
    final implementationsList =
        (vars['storage_implementations'] as List<dynamic>).cast<String>();
    final methodsList = (vars['storage_methods'] as List<dynamic>)
        .cast<String>();

    return StorageConfig(
      implementations: StorageImplementations.fromList(implementationsList),
      methods: StorageMethods.fromList(methodsList),
    );
  }

  final StorageImplementations implementations;
  final StorageMethods methods;

  /// Применяет конфигурацию к Mason vars, добавляя boolean переменные
  void applyToVars(Map<String, dynamic> vars) {
    // Применяем методы
    methods.applyToVars(vars);

    // Применяем реализации
    implementations.applyToVars(vars);
  }

  @override
  String toString() {
    return 'StorageConfig(\n'
        '  implementations: $implementations,\n'
        '  methods: $methods\n'
        ')';
  }
}
