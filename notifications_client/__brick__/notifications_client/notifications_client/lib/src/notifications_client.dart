import 'dart:developer' as dev;

import 'package:notifications_client/notifications_client.dart';

/// {@template notification_exception}
/// Exceptions from the notification client.
/// {@endtemplate}
abstract class NotificationException implements Exception {
  /// {@macro notification_exception}
  const NotificationException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template initialize_notification_client_failure}
/// Exception thrown when the notification client fails to initialize.
/// This can occur due to various reasons such as network issues, invalid
/// configuration, or service unavailability.
/// {@endtemplate}
class InitializeNotificationClientFailure extends NotificationException {
  /// {@macro initialize_notification_client_failure}
  const InitializeNotificationClientFailure(super.error);

  @override
  String toString() => 'Failed to initialize notification client: $error';
}

/// {@template get_initial_message_failure}
/// Exception thrown when the notification client fails to retrieve the
/// initial message. This can happen if the client is not properly initialized,
/// or if there are no initial messages available.
/// {@endtemplate}
class GetInitialMessageFailure extends NotificationException {
  /// {@macro get_initial_message_failure}
  const GetInitialMessageFailure(super.error);

  @override
  String toString() => 'Failed to get initial message: $error';
}

/// {@template get_token_failure}
/// Exception thrown when the notification client fails to retrieve the
/// push token. This can occur if the client is not initialized, or if there
/// are issues with the push notification service.
/// {@endtemplate}
class GetTokenFailure extends NotificationException {
  /// {@macro get_token_failure}
  const GetTokenFailure(super.error);

  @override
  String toString() => 'Failed to get push token: $error';
}

/// {@template on_token_refresh_failure}
/// Exception thrown when the notification client encounters an error
/// while handling a token refresh. This can happen if the new token is invalid,
/// or if there are issues processing the token data.
/// {@endtemplate}
class OnTokenRefreshFailure extends NotificationException {
  /// {@macro on_token_refresh_failure}
  const OnTokenRefreshFailure(super.error);

  @override
  String toString() => 'Failed to handle token refresh: $error';
}

/// {@template on_push_message_failure}
/// Exception thrown when the notification client encounters an error
/// while handling a push message. This can happen if the message format is
/// invalid, or if there are issues processing the message data.
/// {@endtemplate}
class OnPushMessageFailure extends NotificationException {
  /// {@macro on_push_message_failure}
  const OnPushMessageFailure(super.error);

  @override
  String toString() => 'Failed to handle push message: $error';
}

/// {@template notifications_client}
/// A Generic Notifications Client Interface.
///
/// This abstract class provides a common interface for all notification client
/// implementations and includes built-in logging capabilities for debugging
/// and monitoring.
/// {@endtemplate}
abstract class NotificationsClient {
  /// {@macro notifications_client}
  const NotificationsClient({
    this.enableLogging = true,
  });

  /// Whether to enable debug logging for this client.
  ///
  /// When enabled, all operations will be logged with descriptive messages
  /// and runtime type information for easier debugging and monitoring.
  ///
  /// Defaults to `true`. Set to `false` in production if you want to
  /// reduce log noise.
  final bool enableLogging;

  /// Logs a message with the client's runtime type prefix
  /// if logging is enabled.
  ///
  /// All log messages will be prefixed with the runtime type for easy
  /// identification in logs when multiple notification clients are used.
  ///
  /// Example output: `FirebaseNotificationsClient: 🚀 Initializing...`
  void log(String message, {Object? error, StackTrace? stackTrace}) {
    if (enableLogging) {
      dev.log(
        message,
        time: DateTime.now(),
        name: runtimeType.toString(),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initializes the notifications client.
  ///
  /// Throws [InitializeNotificationClientFailure] if initialization fails.
  Future<void> initialize();

  /// Returns a stream of push tokens when they are refreshed.
  Stream<PushToken> get onTokenRefresh;

  /// Returns a stream of push notifications when user clicks on them.
  Stream<PushNotification> get onMessage;

  /// Returns the initial push notification if the app was launched from a
  /// notification.
  ///
  /// Throws [GetInitialMessageFailure] if the initial message
  /// cannot be retrieved.
  Future<PushNotification?> getInitialMessage();

  /// Returns the current push token for the device.
  ///
  /// Throws [GetTokenFailure] if the token cannot be retrieved.
  Future<PushToken> getToken();
}
