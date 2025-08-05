import 'dart:async';

import 'package:notifications_client/notifications_client.dart';
import 'package:rxdart/subjects.dart';

/// {@template notifications_service}
/// A service that manages push notifications and tokens.
/// It listens for incoming notifications and token refresh events,
/// and provides a stream of notifications to subscribers.
/// {@endtemplate}
class NotificationsService {
  /// {@macro notifications_service}
  NotificationsService({
    required NotificationsClient notificationsClient,
  }) : _notificationsClient = notificationsClient,
       _pushNotificationSubject = BehaviorSubject<PushNotification>() {
    unawaited(_getInitialPushNotification());
    _notificationsClient.onMessage
        .listen(_onPushNotification)
        .onError(_handleError);
  }

  final NotificationsClient _notificationsClient;
  final BehaviorSubject<PushNotification> _pushNotificationSubject;

  /// Stream of push notifications received by the client.
  Stream<PushNotification> get onPushNotification => _pushNotificationSubject;

  /// Stream of push tokens received by the client.
  Stream<PushToken> get onTokenRefresh => _notificationsClient.onTokenRefresh;

  /// {@macro get_token}
  Future<PushToken> getToken() => _notificationsClient.getToken();

  Future<void> _getInitialPushNotification() async {
    try {
      final initialPushNotification = await _notificationsClient
          .getInitialMessage();
      if (initialPushNotification != null) {
        _onPushNotification(initialPushNotification);
      }
    } on GetInitialMessageFailure catch (error, stackTrace) {
      _handleError(error, stackTrace);
    } on Exception catch (error, stackTrace) {
      _handleError(GetInitialMessageFailure(error), stackTrace);
    }
  }

  void _onPushNotification(PushNotification notification) {
    _pushNotificationSubject.add(notification);
  }

  void _handleError(Object error, StackTrace stackTrace) {
    _pushNotificationSubject.addError(error, stackTrace);
  }
}
