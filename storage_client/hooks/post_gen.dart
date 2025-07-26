import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final generatedDir = Directory.current;

  // Проверяем наличие dart в PATH
  if (!await _isDartAvailable()) {
    context.logger.warn('⚠️  Dart CLI not found in PATH');
    context.logger.info(
      '💡 Please run "dart format ." manually to format generated files',
    );
    return;
  }

  context.logger.info('🎨 Formatting generated Dart files...');

  // Находим все .dart файлы
  final dartFiles = await _findDartFiles(generatedDir);

  if (dartFiles.isEmpty) {
    context.logger.detail('No Dart files found to format');
    return;
  }

  context.logger.detail('Found ${dartFiles.length} Dart files');

  try {
    // Запускаем dart format только для найденных файлов
    final result = await Process.run(
      'dart',
      ['format', ...dartFiles.map((f) => f.path)],
      workingDirectory: generatedDir.path,
    );

    if (result.exitCode == 0) {
      context.logger.success(
        '✅ Successfully formatted ${dartFiles.length} Dart files',
      );
    } else {
      context.logger.warn('⚠️  dart format completed with warnings');
      if (result.stderr.toString().isNotEmpty) {
        context.logger.detail('stderr: ${result.stderr}');
      }
    }

    // Опционально: запускаем dart analyze для проверки
    await _runAnalyze(context, generatedDir);
  } catch (e) {
    context.logger.warn('⚠️  Could not run dart format: $e');
    context.logger.info(
      '💡 Run "dart format ." manually to format the generated files',
    );
  }
}

Future<bool> _isDartAvailable() async {
  try {
    final result = await Process.run('dart', ['--version']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
}

Future<List<File>> _findDartFiles(Directory dir) async {
  final dartFiles = <File>[];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  }

  return dartFiles;
}

Future<void> _runAnalyze(HookContext context, Directory dir) async {
  try {
    context.logger.detail('Running dart analyze...');
    final result = await Process.run(
      'dart',
      ['analyze'],
      workingDirectory: dir.path,
    );

    // Просто выводим все как есть
    context.logger.detail('=== DART ANALYZE RESULT ===');
    context.logger.detail('Exit code: ${result.exitCode}');
    context.logger.detail('STDOUT:\n"${result.stdout}"');
    context.logger.detail('STDERR:\n"${result.stderr}"');
    context.logger.detail('=== END RESULT ===');

    if (result.exitCode == 0) {
      context.logger.success('✅ No analysis issues found');
    } else {
      context.logger.warn('⚠️  Analysis found issues');
    }
  } catch (e) {
    context.logger.detail('Could not run dart analyze: $e');
  }
}
