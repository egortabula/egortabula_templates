import 'package:get/get.dart';

import '{{module_name.snakeCase()}}_repository.dart';

class {{suffix.pascalCase()}}{{module_name.pascalCase()}}Controller extends GetxController {
  {{suffix.pascalCase()}}{{module_name.pascalCase()}}Controller({
    required {{suffix.pascalCase()}}{{module_name.pascalCase()}}Repository repository,
  }) : _repository = repository;

  final {{suffix.pascalCase()}}{{module_name.pascalCase()}}Repository _repository;
}
