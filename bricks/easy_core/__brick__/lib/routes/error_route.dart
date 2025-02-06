import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/components/go_router_builder.dart';
import '../app/modules/error/error_binding.dart';
import '../app/modules/error/error_view.dart';


class ErrorRoute extends GoRouteData {
  const ErrorRoute({required this.error});

    final Exception error;


  @override
  Widget build(BuildContext context, GoRouterState state) {
     return GoRouterBuilder(
      state: state,
      binding: ErrorBinding(),
      child:  ErrorView(error: error,),
    );
  }
}
