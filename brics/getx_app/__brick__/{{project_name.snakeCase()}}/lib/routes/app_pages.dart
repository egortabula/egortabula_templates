import 'package:get/get.dart';

import 'package:{{project_name}}/app/modules/home/home_binding.dart';
import 'package:{{project_name}}/app/modules/home/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
