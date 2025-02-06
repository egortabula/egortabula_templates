import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final installPackagesProgress =
      context.logger.progress('Installing packages');

  // Run `flutter packages get` after generation.
  await Process.run('flutter', [
    'pub',
    'add',
    'slang',
    'slang_flutter',
    'logging',
    'get',
    'hive_ce',
    'hive_ce_flutter',
  ]);

  installPackagesProgress.complete();

  final slangGenProgress = context.logger.progress(
    'Generating translations...',
  );

  await Process.run(
    'dart',
    ['run', 'slang'],
  );

  slangGenProgress.complete();
}
