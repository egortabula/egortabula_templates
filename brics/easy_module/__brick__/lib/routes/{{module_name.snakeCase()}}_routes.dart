import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@TypedGoRoute<SignInRoute>(
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