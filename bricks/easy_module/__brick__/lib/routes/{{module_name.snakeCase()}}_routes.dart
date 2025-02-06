import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{package_name.snakeCase()}}/app/components/go_router_builder.dart';
import 'package:{{package_name.snakeCase()}}/app/modules/{{module_name.snakeCase()}}/{{module_name.snakeCase()}}_binding.dart';
import 'package:{{package_name.snakeCase()}}/app/modules/{{module_name.snakeCase()}}/{{module_name.snakeCase()}}_view.dart';

@TypedGoRoute<{{module_name.pascalCase()}}Route>(
  path: '/{{module_name.paramCase()}}',
  name: '{{module_name.sentenceCase()}}',
)
class {{module_name.pascalCase()}}Route extends GoRouteData {
  const {{module_name.pascalCase()}}Route();

  @override
  Widget build(BuildContext context, GoRouterState state) {
     return GoRouterBuilder(
      state: state,
      binding: {{module_name.pascalCase()}}Binding(),
      child: const {{module_name.pascalCase()}}View(),
    );
  }
}
