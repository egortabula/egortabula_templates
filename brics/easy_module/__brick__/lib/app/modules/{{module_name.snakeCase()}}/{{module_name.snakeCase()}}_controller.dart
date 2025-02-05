import 'package:get/get.dart';

import '{{module_name.snakeCase()}}_repository.dart';

class {{module_name.pascalCase()}}Controller extends GetxController {
  {{module_name.pascalCase()}}Controller({
    required {{module_name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{module_name.pascalCase()}}Repository _repository;
}
