import 'dart:io';

import 'package:dart_file_editor/dart_file_editor.dart';
import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final directory = Directory.current.path;

  List<String> folders;
  if (Platform.isWindows) {
    folders = directory.split(r'\').toList();
  } else {
    folders = directory.split('/').toList();
  }
  final progress = logger.progress('Adding route');

  await _addRoute(context, progress);
  await _addPage(context, progress);

  progress.complete(green.wrap('Routes added!') as String);
}

Future<void> _addPage(HookContext context, Progress progress) async {
  progress.update(green.wrap('Updating page file...')!);

  final appRoutesFile = File('routes/app_pages.dart');

  String content = await appRoutesFile.readAsString();

  final String featureName = (context.vars['feature_name'] as String);

  final packageNameValue = await packageName(context);

  // Adding imports
  final String viewImport = "import 'package:${packageNameValue}/app/modules/"
      "${featureName.snakeCase}/${featureName.snakeCase}_view.dart';";
  final String bindingImport =
      "import 'package:${packageNameValue}/app/modules/${featureName.snakeCase}"
      "/${featureName.snakeCase}_binding.dart';";
  content = DartFileEditor.addImports(
    content,
    imports: [
      viewImport,
      bindingImport,
    ],
  );

  // Adding route to routes list
  final newRoute = '''
    GetPage(
      name: _Paths.${featureName.camelCase},
      page: () => const ${featureName.pascalCase}View(),
      binding: ${featureName.pascalCase}Binding(),
    ),''';

  content = DartFileEditor.addElementToList(
    content,
    listName: 'static final routes = [',
    elementToAdd: newRoute,
  );

  // writing to file
  appRoutesFile.writeAsStringSync(content, flush: true);
  progress.update(green.wrap('Page file was updated')!);
}

Future<void> _addRoute(HookContext context, Progress progress) async {
  progress.update(green.wrap('Updating route file...')!);
  final String featureName = (context.vars['feature_name'] as String);
  final String newPath =
      "  static const ${featureName.camelCase} = '/${featureName.camelCase}';";
  final String newRoute =
      "  static String ${featureName.camelCase} = _Paths.${featureName.camelCase};";

  final appRoutesFile = File('routes/app_routes.dart');

  String content = await appRoutesFile.readAsString();

  content = DartFileEditor.addContentToClass(
    content,
    className: 'Routes',
    contentToAdd: newRoute,
  );

  content = DartFileEditor.addContentToClass(
    content,
    className: '_Paths',
    contentToAdd: newPath,
  );

  await appRoutesFile.writeAsString(content, flush: true);
  progress.update(green.wrap('Route file was updated!')!);
}

Future<String> packageName(HookContext context) async {
  final directory = Directory.current.path;
  List<String> folders;

  if (Platform.isWindows) {
    folders = directory.split(r'\').toList();
  } else {
    folders = directory.split('/').toList();
  }
  final libIndex = folders.indexWhere((folder) => folder == 'lib');
  final pubSpecFile =
      File('${folders.sublist(0, libIndex).join('/')}/pubspec.yaml');
  final pubContent = await pubSpecFile.readAsString();
  final yamlMap = loadYaml(pubContent);
  final packageName = yamlMap['name'];
  return packageName;
}
