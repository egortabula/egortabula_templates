import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final dartFixProgress = context.logger.progress('Running dart fix...');

  await Process.run(
    'dart',
    ['fix', '--apply', '.'],
    runInShell: true,
  );

  dartFixProgress.complete();
}
