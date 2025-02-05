import 'package:flutter/material.dart';
import 'package:{{packageName}}/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();

  runApp(const {{packageName.pascalCase()}}App());
}

/// Initializes the necessary services for the application.
///
/// This method is called before the application starts to ensure that all
/// required services are properly set up.
Future<void> initServices() async {
  //TODO: add services
}
