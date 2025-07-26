/// Конфигурация методов storage
class StorageMethods {
  const StorageMethods({
    required this.includeRead,
    required this.includeWrite,
    required this.includeDelete,
    required this.includeClear,
    required this.includeContainsKey,
    required this.includeGetKeys,
    required this.includeIsEmpty,
    required this.includeIsNotEmpty,
  });

  /// Создает конфигурацию методов из списка строк
  factory StorageMethods.fromList(List<String> methods) {
    return StorageMethods(
      includeRead: methods.contains('read'),
      includeWrite: methods.contains('write'),
      includeDelete: methods.contains('delete'),
      includeClear: methods.contains('clear'),
      includeContainsKey: methods.contains('containsKey'),
      includeGetKeys: methods.contains('getKeys'),
      includeIsEmpty: methods.contains('isEmpty'),
      includeIsNotEmpty: methods.contains('isNotEmpty'),
    );
  }

  /// Базовая конфигурация (только основные методы)
  factory StorageMethods.basic() {
    return const StorageMethods(
      includeRead: true,
      includeWrite: true,
      includeDelete: true,
      includeClear: false,
      includeContainsKey: false,
      includeGetKeys: false,
      includeIsEmpty: false,
      includeIsNotEmpty: false,
    );
  }

  /// Полная конфигурация (все методы)
  factory StorageMethods.full() {
    return const StorageMethods(
      includeRead: true,
      includeWrite: true,
      includeDelete: true,
      includeClear: true,
      includeContainsKey: true,
      includeGetKeys: true,
      includeIsEmpty: true,
      includeIsNotEmpty: true,
    );
  }

  final bool includeRead;
  final bool includeWrite;
  final bool includeDelete;
  final bool includeClear;
  final bool includeContainsKey;
  final bool includeGetKeys;
  final bool includeIsEmpty;
  final bool includeIsNotEmpty;

  /// Применяет конфигурацию методов к Mason vars
  void applyToVars(Map<String, dynamic> vars) {
    vars['include_read'] = includeRead;
    vars['include_write'] = includeWrite;
    vars['include_delete'] = includeDelete;
    vars['include_clear'] = includeClear;
    vars['include_containsKey'] = includeContainsKey;
    vars['include_getKeys'] = includeGetKeys;
    vars['include_isEmpty'] = includeIsEmpty;
    vars['include_isNotEmpty'] = includeIsNotEmpty;
  }

  /// Возвращает список включенных методов
  List<String> get enabledMethods {
    final methods = <String>[];
    if (includeRead) methods.add('read');
    if (includeWrite) methods.add('write');
    if (includeDelete) methods.add('delete');
    if (includeClear) methods.add('clear');
    if (includeContainsKey) methods.add('containsKey');
    if (includeGetKeys) methods.add('getKeys');
    if (includeIsEmpty) methods.add('isEmpty');
    if (includeIsNotEmpty) methods.add('isNotEmpty');
    return methods;
  }

  /// Проверяет, включены ли основные методы
  bool get hasBasicMethods => includeRead && includeWrite;

  /// Проверяет, включены ли методы для работы с коллекциями
  bool get hasCollectionMethods =>
      includeGetKeys || includeIsEmpty || includeIsNotEmpty;

  @override
  String toString() {
    return 'StorageMethods(enabled: ${enabledMethods.join(", ")})';
  }
}
