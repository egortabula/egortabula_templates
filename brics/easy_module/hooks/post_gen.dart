import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final moduleName = context.vars['module_name'];
  final languages = context.vars['languages'];

  context.logger.detail('$languages, type: ${languages.runtimeType}');

  final i18nDir = Directory('assets/i18n/');
  if (!i18nDir.existsSync()) {
    i18nDir.createSync(recursive: true);
  }

  for (final lang in languages) {
    final fileName = '{{module_name.snakeCase()}}_$lang.i18n.json';
    final file = File('${i18nDir.path}/$fileName');

    if (!file.existsSync()) {
      file.writeAsStringSync('{\n}');
      context.logger.success('✅ Created $fileName');
    }
  }

  final dartFixProgress = context.logger.progress('Running dart fix...');

  final result = await Process.run(
    'dart',
    ['fix', '--apply'],
    runInShell: true,
  );

  if (result.exitCode == 0) {
    context.logger
        .progress('✅ dart fix --apply completed successfully.')
        .complete();
  } else {
    context.logger
        .progress('❌ dart fix --apply failed: ${result.stderr}')
        .complete();
  }

  dartFixProgress.complete();
}
