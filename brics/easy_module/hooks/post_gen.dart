import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final dartFixProgress = context.logger.progress('Running dart fix...');

  // Run `flutter packages get` after generation.
  await Process.run('dart', [
    'fix:apply',
  ]);

  dartFixProgress.complete();
}
