import '{{module_name.snakeCase()}}_controller.dart';
import '{{module_name.snakeCase()}}_repository.dart';
import '../../../core/utils/helpers/go_router_binding.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';


class {{module_name.pascalCase()}}Binding extends GoRouterBinding {
  @override
  void disposeBindings() {
    Get.delete<{{module_name.pascalCase()}}Controller>();
  }

  @override
  void injectBindings(GoRouterState state) {
    Get.put(
      {{module_name.pascalCase()}}Controller(
        repository: {{module_name.pascalCase()}}Repository(),
      ),
    );
  }
}
