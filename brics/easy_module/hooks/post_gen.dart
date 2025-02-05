import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
   final moduleName = Platform.environment['MODULE_NAME'];
  final languages = Platform.environment['LANGUAGES']?.split(',') ?? ['en', 'ru'];

  final i18nDir = Directory('assets/i18n/');
  if (!i18nDir.existsSync()) {
    i18nDir.createSync(recursive: true);
  }

  for (final lang in languages) {
    final fileName = '${moduleName}_$lang.i18n.json';
    final file = File('${i18nDir.path}/$fileName');
    
    if (!file.existsSync()) {
      file.writeAsStringSync('{\n  "example_key": "Example translation for $lang"\n}');
      print('✅ Created $fileName');
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
