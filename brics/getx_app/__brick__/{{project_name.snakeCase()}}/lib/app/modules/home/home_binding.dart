import 'package:get/get.dart';
import 'package:{{project_name}}/app/modules/home/home_controller.dart';
import 'package:{{project_name}}/app/modules/home/home_repository.dart';

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<HomeController>(
        () => HomeController(
          homeRepository: HomeRepository(),
        ),
      ),
    ];
  }
}
