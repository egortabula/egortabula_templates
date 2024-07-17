import 'package:get/get.dart';

import 'not_found_controller.dart';

class NotFoundBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<NotFoundController>(
        () => NotFoundController(),
      ),
    ];
  }
}
