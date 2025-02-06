import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final installPackagesProgress =
      context.logger.progress('Installing packages');

  // Run `flutter packages get` after generation.
  await Process.run('flutter', [
    'pub',
    'add',
    'logging',
    'get:5.0.0-release-candidate-9.2.1',
    'go_router',
    'dart_mappable',
    'fpdart',
    'cached_network_image',
    'flutter_svg',
    'intl',
    'material_symbols_icons',
    'flutter_localizations:{"sdk":"flutter"}',
  ]);

  installPackagesProgress.complete();

  final installDevPackagesProgress =
      context.logger.progress('Installing dev packages');

  // Run `flutter packages get` after generation.
  await Process.run(
    'flutter',
    [
      'pub',
      'add',
      'dev:build_runner',
      'dev:dart_mappable_builder',
      'dev:go_router_builder',
      'dev:very_good_analysis',
      'dev:mocktail',
    ],
  );

  installDevPackagesProgress.complete();
}
