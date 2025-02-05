import '{{module_name.snakeCase()}}_controller.dart';
import '{{module_name.snakeCase()}}_repository.dart';

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
