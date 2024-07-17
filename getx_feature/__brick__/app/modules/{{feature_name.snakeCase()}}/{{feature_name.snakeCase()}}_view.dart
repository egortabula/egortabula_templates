import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '{{feature_name.snakeCase()}}_controller.dart';

class {{feature_name.pascalCase()}}View extends GetView<{{feature_name.pascalCase()}}Controller> {
  const {{feature_name.pascalCase()}}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_name.titleCase()}} View'),
      ),
      body: Center(
        child: Text(
          '{{feature_name.titleCase()}} View is working',
          style: Get.textTheme.titleLarge,
        ),
      ),
    );
  }
}