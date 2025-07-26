/// Конфигурация реализаций storage
class StorageImplementations {
  const StorageImplementations({
    required this.includeStorageClient,
    required this.includeSharedPrefsAsync,
    required this.includeSharedPrefsSync,
    required this.includeSharedPrefsCache,
    required this.includeHiveString,
    required this.includeHiveModel,
    required this.includeGetStorage,
    required this.includeFlutterSecureStorage,
  });

  /// Создает конфигурацию реализаций из списка строк
  factory StorageImplementations.fromList(List<String> implementations) {
    return StorageImplementations(
      includeStorageClient: implementations.contains('storage_client'),
      includeSharedPrefsAsync: implementations.contains('shared_prefs_async'),
      includeSharedPrefsSync: implementations.contains('shared_prefs_sync'),
      includeSharedPrefsCache: implementations.contains('shared_prefs_cache'),
      includeHiveString: implementations.contains('hive_string'),
      includeHiveModel: implementations.contains('hive_model'),
      includeGetStorage: implementations.contains('get_storage'),
      includeFlutterSecureStorage: implementations.contains(
        'flutter_secure_storage',
      ),
    );
  }

  /// Только интерфейс
  factory StorageImplementations.interfaceOnly() {
    return const StorageImplementations(
      includeStorageClient: true,
      includeSharedPrefsAsync: false,
      includeSharedPrefsSync: false,
      includeSharedPrefsCache: false,
      includeHiveString: false,
      includeHiveModel: false,
      includeGetStorage: false,
      includeFlutterSecureStorage: false,
    );
  }

  /// Базовый набор (интерфейс + SharedPreferences async)
  factory StorageImplementations.basic() {
    return const StorageImplementations(
      includeStorageClient: true,
      includeSharedPrefsAsync: true,
      includeSharedPrefsSync: false,
      includeSharedPrefsCache: false,
      includeHiveString: false,
      includeHiveModel: false,
      includeGetStorage: false,
      includeFlutterSecureStorage: false,
    );
  }

  final bool includeStorageClient;
  final bool includeSharedPrefsAsync;
  final bool includeSharedPrefsSync;
  final bool includeSharedPrefsCache;
  final bool includeHiveString;
  final bool includeHiveModel;
  final bool includeGetStorage;
  final bool includeFlutterSecureStorage;

  /// Применяет конфигурацию реализаций к Mason vars
  void applyToVars(Map<String, dynamic> vars) {
    vars['include_storage_client'] = includeStorageClient;
    vars['include_shared_prefs_async'] = includeSharedPrefsAsync;
    vars['include_shared_prefs_sync'] = includeSharedPrefsSync;
    vars['include_shared_prefs_cache'] = includeSharedPrefsCache;
    vars['include_hive_string'] = includeHiveString;
    vars['include_hive_model'] = includeHiveModel;
    vars['include_get_storage'] = includeGetStorage;
    vars['include_flutter_secure_storage'] = includeFlutterSecureStorage;
  }

  /// Возвращает список включенных реализаций
  List<String> get enabledImplementations {
    final implementations = <String>[];
    if (includeStorageClient) implementations.add('storage_client');
    if (includeSharedPrefsAsync) implementations.add('shared_prefs_async');
    if (includeSharedPrefsSync) implementations.add('shared_prefs_sync');
    if (includeSharedPrefsCache) implementations.add('shared_prefs_cache');
    if (includeHiveString) implementations.add('hive_string');
    if (includeHiveModel) implementations.add('hive_model');
    if (includeGetStorage) implementations.add('get_storage');
    if (includeFlutterSecureStorage) {
      implementations.add('flutter_secure_storage');
    }
    return implementations;
  }

  /// Проверяет, включены ли SharedPreferences реализации
  bool get hasSharedPrefsImplementations =>
      includeSharedPrefsAsync ||
      includeSharedPrefsSync ||
      includeSharedPrefsCache;

  /// Проверяет, включены ли Hive реализации
  bool get hasHiveImplementations => includeHiveString || includeHiveModel;

  /// Проверяет, включена ли secure storage
  bool get hasSecureStorage => includeFlutterSecureStorage;

  @override
  String toString() {
    return 'StorageImplementations(enabled: ${enabledImplementations.join(", ")})';
  }
}
