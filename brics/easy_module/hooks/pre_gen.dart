import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) {
  // Get the current directory
  final currentDirectory = Directory.current;

  // Return the folder name
  final packageName = currentDirectory.path.split(Platform.pathSeparator).last;

  context.vars['package_name'] = packageName;
}
