part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static String notFound = _Paths.notFound;
}

abstract class _Paths {
  static const home = '/home';
  static const notFound = '/404';
}
