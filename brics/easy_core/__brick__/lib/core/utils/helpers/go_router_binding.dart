import 'package:go_router/go_router.dart';

/// An abstract class that defines the contract for injecting and disposing
/// bindings related to [GoRouterState].
abstract class GoRouterBinding {
  /// Injects the necessary bindings for the given [GoRouterState].
  void injectBindings(GoRouterState state);

  /// Disposes of the bindings that were previously injected.
  void disposeBindings();
}
