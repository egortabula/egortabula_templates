import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/helpers/go_router_binding.dart';

/// A widget that builds a GoRouter with the provided state and bindings.
class GoRouterBuilder extends StatefulWidget {
  /// Creates a [GoRouterBuilder].
  ///
  /// The [child], [binding], and [state] parameters must not be null.
  const GoRouterBuilder({
    required this.child,
    required this.binding,
    required this.state,
    super.key,
  });

  /// The child widget to display.
  final Widget child;

  /// The state of the GoRouter.
  final GoRouterState state;

  /// The binding to inject into the GoRouter.
  final GoRouterBinding binding;

  @override
  State<GoRouterBuilder> createState() => _GoRouterBuilderState();
}

class _GoRouterBuilderState extends State<GoRouterBuilder> {
  @override
  void initState() {
    widget.binding.injectBindings(widget.state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.binding.disposeBindings();
    super.dispose();
  }
}
