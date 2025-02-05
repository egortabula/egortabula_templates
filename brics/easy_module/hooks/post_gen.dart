import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
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
