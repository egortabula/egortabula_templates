import '../../../core/utils/helpers/go_router_binding.dart';
import 'error_controller.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ErrorBinding extends GoRouterBinding {
  @override
  void disposeBindings() {
    Get.delete<ErrorController>();
  }

  @override
  void injectBindings(GoRouterState state) {
    Get.put(ErrorController());
  }
}
