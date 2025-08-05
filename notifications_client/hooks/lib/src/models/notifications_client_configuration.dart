import 'package:equatable/equatable.dart';

/// The variables specified by this hook.
///
/// The variables can be found in the Brick's `brick.yaml` file. They are
/// initially included in the `HookContext.vars` map.
///
/// See also:
///
/// * [brick.yaml documentation](https://docs.brickhub.dev/brick-structure#brickyaml)
enum _NotificationsClientConfigurationVariables {
  appmetrica._('appmetrica');

  const _NotificationsClientConfigurationVariables._(this.key);

  /// The key used in the `HookContext.vars` [Map].
  ///
  /// This should match the variable key in the `brick.yaml`.
  final String key;
}

/// {@template notification_client_configuration}
/// Configuration for the notification_client brick.
/// {@endtemplate}
class NotificationsClientConfiguration extends Equatable {
  /// {@macro notification_client_configuration}
  const NotificationsClientConfiguration({
    required this.shouldGenerateAppMetricaClient,
  });

  /// Deserializes a [NotificationsClientConfiguration]
  /// from a `Map<String, dynamic>` used to represent the configuration
  /// in the `HookContext.vars` map.
  factory NotificationsClientConfiguration.fromHookVars(
      Map<String, dynamic> vars) {
    final clients = vars['clients'] as List<dynamic>?;

    if (clients == null) {
      throw ArgumentError(
        'The "clients" variable is required in the HookContext.vars map.',
      );
    }

    if (clients.isEmpty) {
      throw ArgumentError(
        'No clients selected. Please specify at least one client '
        'in the "clients" variable.',
      );
    }

    final shouldGenerateAppmetricaVar = clients
        .contains(_NotificationsClientConfigurationVariables.appmetrica.key);

    return NotificationsClientConfiguration(
      shouldGenerateAppMetricaClient: shouldGenerateAppmetricaVar,
    );
  }

  final bool shouldGenerateAppMetricaClient;

  @override
  List<Object?> get props => [shouldGenerateAppMetricaClient];
}
