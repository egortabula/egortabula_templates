import 'dart:async';

import 'package:appmetrica_notifications_client/src/mappings/mappings.dart';
import 'package:appmetrica_push_plugin/appmetrica_push_plugin.dart';
import 'package:notifications_client/notifications_client.dart';

/// {@template appmetrica_notifications_client}
/// AppMetrica notifications client implementation.
///
/// This client provides integration with AppMetrica Push SDK for handling
/// push notifications. It inherits comprehensive logging capabilities from
/// the base [NotificationsClient] class.
///
/// **Logging Features:**
/// - 🚀 Initialization status
/// - 📨 Notification parsing and handling
/// - 🔑 Token management and refresh
/// - ❌ Error details with troubleshooting tips
/// - ✅ Success confirmations
/// - 🏷️ Runtime type prefixes for easy identification
///
/// **Usage:**
/// ```dart
/// // With logging enabled (default)
/// final client = AppmetricaNotificationsClient();
///
/// // With logging disabled
/// final client = AppmetricaNotificationsClient(enableLogging: false);
///
/// await client.initialize(); // Logs initialization progress
///
/// // Subscribe to notifications with automatic logging
/// client.onMessage.listen(
///   (notification) => print('Got: ${notification.title}'),
///   onError: (error) => print('Error: $error'),
/// );
/// ```
/// {@endtemplate}
class AppmetricaNotificationsClient extends NotificationsClient {
  /// {@macro appmetrica_notifications_client}
  const AppmetricaNotificationsClient({
    super.enableLogging = true,
  });

  @override
  Future<void> initialize() async {
    try {
      log('🚀 AppMetrica Push: Initializing...');
      await AppMetricaPush.activate();
      log('✅ AppMetrica Push: Successfully initialized');
    } catch (error, stackTrace) {
      log(
        '❌ AppMetrica Push: Initialization failed - $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        InitializeNotificationClientFailure(error),
        stackTrace,
      );
    }
  }

  @override
  Future<PushNotification?> getInitialMessage() async {
    try {
      log('🔍 AppMetrica Push: Checking for launch notification...');
      final result = await AppMetricaPush.getLaunchPushInfo();
      if (result.payload == null) {
        log('ℹ️ AppMetrica Push: No launch notification found');
        return null;
      }

      log('📨 AppMetrica Push: Found launch notification, parsing...');
      final pushNotification = result.payload.toPushNotification();
      log('✅ AppMetrica Push: Launch notification parsed successfully');

      return pushNotification;
    } catch (error, stackTrace) {
      log(
        '❌ AppMetrica Push: Failed to get launch notification - $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(
        GetInitialMessageFailure(error),
        stackTrace,
      );
    }
  }

  @override
  Future<PushToken> getToken() async {
    try {
      log('🔑 AppMetrica Push: Requesting push token...');
      final result = await AppMetricaPush.getTokens();

      log('🔧 AppMetrica Push: Parsing token data...');
      final token = result.toPushToken();
      log(
        '✅ AppMetrica Push: Token obtained successfully '
        '(${token.provider.value})',
      );

      return token;
    } catch (error, stackTrace) {
      log(
        '❌ AppMetrica Push: Failed to get token - $error',
        error: error,
        stackTrace: stackTrace,
      );
      Error.throwWithStackTrace(GetTokenFailure(error), stackTrace);
    }
  }

  @override
  Stream<PushNotification> get onMessage => _onMessageStream();

  @override
  Stream<PushToken> get onTokenRefresh => _onTokenRefreshStream();

  /// Creates the notification message stream with logging.
  Stream<PushNotification> _onMessageStream() {
    return AppMetricaPush.pushClickStream.asyncExpand((data) async* {
      try {
        log('📨 AppMetrica Push: Received notification, parsing...');
        final notification = data.payload.toPushNotification();
        log(
          '✅ AppMetrica Push: Notification parsed successfully '
          '- Title: "${notification.title ?? 'No title'}"',
        );
        yield notification;
      } on Exception catch (error, stackTrace) {
        log(
          '❌ AppMetrica Push: Failed to parse notification - $error',
          error: error,
          stackTrace: stackTrace,
        );
        log(
          '💡 Tip: Check your notification payload format in '
          'AppMetrica console',
        );
        yield* Stream.error(OnPushMessageFailure(error), stackTrace);
      }
    });
  }

  /// Creates the token refresh stream with logging.
  Stream<PushToken> _onTokenRefreshStream() {
    return AppMetricaPush.tokenStream.asyncExpand((data) async* {
      try {
        log('🔄 AppMetrica Push: Token refresh detected, parsing...');
        final token = data.toPushToken();
        log(
          '✅ AppMetrica Push: Token refreshed successfully '
          '(${token.provider.value})',
        );
        yield token;
      } on Exception catch (error, stackTrace) {
        log(
          '❌ AppMetrica Push: Failed to parse refreshed token - $error',
          error: error,
          stackTrace: stackTrace,
        );
        log('💡 Tip: Verify your AppMetrica push service configuration');
        yield* Stream.error(OnTokenRefreshFailure(error), stackTrace);
      }
    });
  }
}
