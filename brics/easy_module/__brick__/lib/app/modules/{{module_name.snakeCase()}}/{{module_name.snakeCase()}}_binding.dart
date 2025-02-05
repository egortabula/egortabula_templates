import '{{module_name.snakeCase()}}_controller.dart';
import '{{module_name.snakeCase()}}_repository.dart';
import 'package:{{package_name.snakeCase()}}/core/utils/helpers/go_router_binding.dart';
import 'package:get/get.dart';

class {{module_name.pascalCase()}}Binding extends GoRouterBinding {
  @override
  void disposeBindings() {
    Get.delete<{{module_name.pascalCase()}}Controller>();
  }

  @override
  void injectBindings(state) {
    Get.put(
      {{module_name.pascalCase()}}Controller(
        repository: {{module_name.pascalCase()}}Repository(),
      ),
    );
  }
}
