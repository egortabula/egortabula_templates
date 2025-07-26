import 'package:mason/mason.dart';

import 'src/storage_client_hooks.dart';

// Обновляем основной run метод
void run(HookContext context) {
  try {
    // Создаем конфигурацию из пользовательского ввода
    final config = StorageConfig.fromVars(context.vars)
      // Валидируем конфигурацию
      ..validate();

    // Показываем предупреждения если есть
    for (final warning in config.warnings) {
      context.logger.warn(warning);
    }

    // Показываем предложения если есть
    for (final suggestion in config.suggestions) {
      context.logger.info('💡 Suggestion: $suggestion');
    }

    // Применяем конфигурацию к context.vars
    config.applyToVars(context.vars);

    // Логирование для отладки
    context.logger.info('✅ Configuration applied successfully');
    context.logger.detail(
      'Selected methods: ${config.methods.enabledMethods.join(", ")}',
    );
    context.logger.detail(
      'Selected implementations: '
      '${config.implementations.enabledImplementations.join(", ")}',
    );
  } catch (e) {
    context.logger.err('❌ Configuration error: $e');
    rethrow;
  }
}
