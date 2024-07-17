import 'package:get/get.dart';
import '{{feature_name.snakeCase()}}_repository.dart';

class {{feature_name.pascalCase()}}Controller extends GetxController {
  final {{feature_name.pascalCase()}}Repository {{feature_name.camelCase()}}Repository;

  {{feature_name.pascalCase()}}Controller({required this.{{feature_name.camelCase()}}Repository});
}