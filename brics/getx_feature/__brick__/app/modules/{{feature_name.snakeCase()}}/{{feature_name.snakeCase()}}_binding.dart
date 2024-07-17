import 'package:get/get.dart';

import '{{feature_name.snakeCase()}}_controller.dart';
import '{{feature_name.snakeCase()}}_repository.dart';

class {{feature_name.pascalCase()}}Binding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => {{feature_name.pascalCase()}}Controller(
          {{feature_name.camelCase()}}Repository: {{feature_name.pascalCase()}}Repository(),
        ),
      ),
    ];
  }
}
