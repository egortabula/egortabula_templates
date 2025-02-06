import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '{{module_name.snakeCase()}}_controller.dart';

class {{module_name.pascalCase()}}View extends GetView<{{module_name.pascalCase()}}Controller> {
  const {{module_name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{module_name.pascalCase()}}')),
      body: const Center(
        child: Text('Welcome to {{module_name.pascalCase()}} module!'),
      ),
    );
  }
}
