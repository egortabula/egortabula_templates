// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:appmetrica_notifications_client/appmetrica_notifications_client.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_client/notifications_client.dart';

class MockBinaryMessengerHandler extends Mock {
  Future<ByteData?> call(ByteData? message);
}

void main() {
  group('AppmetricaNotificationsClient', () {
    late AppmetricaNotificationsClient client;
    late TestWidgetsFlutterBinding binding;

    // AppMetrica Push plugin method channel names (Pigeon generated)
    const activateChannelName =
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.activate';
    const getLaunchPushInfoChannelName =
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.getLaunchPushInfo';
    const getTokensChannelName =
        'dev.flutter.pigeon.appmetrica_push_plugin.AppMetricaPushPigeon.getTokens';

    const codec = StandardMessageCodec();

    setUp(() {
      binding = TestWidgetsFlutterBinding.ensureInitialized();
      client = AppmetricaNotificationsClient();

      // Default handlers following AppMetrica's test pattern
      binding.defaultBinaryMessenger.setMockMessageHandler(
        activateChannelName,
        (_) => Future.value(codec.encodeMessage([])),
      );

      // Note: No default handler for getLaunchPushInfo since we don't mock it extensively
      // like AppMetrica's own tests

      binding.defaultBinaryMessenger.setMockMessageHandler(
        getTokensChannelName,
        (_) => Future.value(
          codec.encodeMessage([
            {'firebase': 'mock_firebase_token_123456789'},
          ]),
        ),
      );
    });

    tearDown(() {
      binding.defaultBinaryMessenger.setMockMessageHandler(
        activateChannelName,
        null,
      );
      binding.defaultBinaryMessenger.setMockMessageHandler(
        getLaunchPushInfoChannelName,
        null,
      );
      binding.defaultBinaryMessenger.setMockMessageHandler(
        getTokensChannelName,
        null,
      );
    });

    group('instantiation', () {
      test('can be instantiated', () {
        expect(AppmetricaNotificationsClient(), isNotNull);
      });

      test('can be instantiated with logging disabled', () {
        final client = AppmetricaNotificationsClient(enableLogging: false);
        expect(client, isNotNull);
      });

      test('can be instantiated with logging enabled by default', () {
        final client = AppmetricaNotificationsClient();
        expect(client, isNotNull);
      });
    });

    group('initialize', () {
      test('calls AppMetricaPush.activate and succeeds', () async {
        // Act
        await client.initialize();
        // Assert: No exception thrown means success
      });

      test(
        'throws InitializeNotificationClientFailure on platform error',
        () async {
          // Arrange
          final mock = MockBinaryMessengerHandler();
          when(() => mock.call(any())).thenAnswer(
            (_) => Future.value(
              codec.encodeMessage([
                'ACTIVATION_FAILED',
                'AppMetrica activation failed',
                null,
              ]),
            ),
          );
          binding.defaultBinaryMessenger.setMockMessageHandler(
            activateChannelName,
            mock.call,
          );

          // Act & Assert
          expect(
            () => client.initialize(),
            throwsA(isA<InitializeNotificationClientFailure>()),
          );
          verify(() => mock.call(any())).called(1);
        },
      );
    });

    group(
      'getInitialMessage',
      () {
        test('method exists and can be called', () {
          // Assert
          expect(client.getInitialMessage, isA<Function>());

          // Note: We only test that the method exists. AppMetrica's own tests
          // don't cover getLaunchPushInfo method, and the platform interaction
          // is complex to mock reliably due to Pigeon's custom codec.
        });

        test('handles exceptions gracefully', () async {
          // Arrange - Set up a handler that will cause issues
          binding.defaultBinaryMessenger.setMockMessageHandler(
            getLaunchPushInfoChannelName,
            (_) => throw Exception('Platform error'),
          );

          // Act & Assert
          expect(
            () => client.getInitialMessage(),
            throwsA(isA<GetInitialMessageFailure>()),
          );
        });
      },
    );

    group('getToken', () {
      test('returns parsed token successfully', () async {
        // Act (uses default handler with Firebase token)
        final result = await client.getToken();

        // Assert
        expect(result, isNotNull);
        expect(result.value, equals('mock_firebase_token_123456789'));
        expect(result.provider, equals(PushProvider.firebase));
        expect(result.createdAt, isA<DateTime>());
      });

      test('returns APNS token when provided', () async {
        // Arrange
        final mock = MockBinaryMessengerHandler();
        when(() => mock.call(any())).thenAnswer(
          (_) => Future.value(
            codec.encodeMessage([
              {'apns': 'mock_apns_token_987654321'},
            ]),
          ),
        );
        binding.defaultBinaryMessenger.setMockMessageHandler(
          getTokensChannelName,
          mock.call,
        );

        // Act
        final result = await client.getToken();

        // Assert
        expect(result.value, equals('mock_apns_token_987654321'));
        expect(result.provider, equals(PushProvider.apns));
        verify(() => mock.call(any())).called(1);
      });

      test('throws GetTokenFailure on platform error', () async {
        // Arrange
        final mock = MockBinaryMessengerHandler();
        when(() => mock.call(any())).thenAnswer(
          (_) => Future.value(
            codec.encodeMessage([
              'GET_TOKEN_FAILED',
              'Failed to get push token',
              null,
            ]),
          ),
        );
        binding.defaultBinaryMessenger.setMockMessageHandler(
          getTokensChannelName,
          mock.call,
        );

        // Act & Assert
        expect(
          () => client.getToken(),
          throwsA(isA<GetTokenFailure>()),
        );
        verify(() => mock.call(any())).called(1);
      });

      test('throws GetTokenFailure on empty token data', () async {
        // Arrange
        final mock = MockBinaryMessengerHandler();
        when(() => mock.call(any())).thenAnswer(
          (_) => Future.value(
            codec.encodeMessage([<String, Object?>{}]),
          ), // Empty map
        );
        binding.defaultBinaryMessenger.setMockMessageHandler(
          getTokensChannelName,
          mock.call,
        );

        // Act & Assert
        expect(
          () => client.getToken(),
          throwsA(isA<GetTokenFailure>()),
        );
        verify(() => mock.call(any())).called(1);
      });
    });

    group('streams', () {
      test('onMessage stream is accessible', () {
        // Act
        final stream = client.onMessage;

        // Assert
        expect(stream, isA<Stream<PushNotification>>());
      });

      group('.onTokenRefresh', () {
        test('onTokenRefresh stream is accessible', () {
          // Act
          final stream = client.onTokenRefresh;

          // Assert
          expect(stream, isA<Stream<PushToken>>());
        });

        test('onTokenRefresh stream emits new tokens', () async {
          // Arrange
          await client.initialize();
          final tokens = {'firebase': 'mock_token_value'};

          // Create a completer to wait for the stream event
          final completer = Completer<PushToken>();

          // Listen to the stream and complete when we receive a token
          final subscription = client.onTokenRefresh.listen((token) {
            if (!completer.isCompleted) {
              completer.complete(token);
            }
          });

          // Act - Send platform message to trigger token refresh
          await binding.defaultBinaryMessenger.handlePlatformMessage(
            'dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated',
            codec.encodeMessage([tokens]),
            (data) {},
          );

          // Assert - Wait for and verify the emitted token
          final receivedToken = await completer.future.timeout(
            Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('Stream did not emit token'),
          );

          expect(receivedToken.value, equals('mock_token_value'));
          expect(receivedToken.provider, equals(PushProvider.firebase));
          expect(receivedToken.createdAt, isA<DateTime>());

          // Cleanup
          await subscription.cancel();
        });

        test('onTokenRefresh stream handles errors gracefully', () async {
          // Arrange
          await client.initialize();
          final completer = Completer<Object>();

          // Listen to the stream for errors
          final subscription = client.onTokenRefresh.listen(
            (token) {
              // Should not receive any tokens in this test
              if (!completer.isCompleted) {
                completer.complete('Unexpected token received');
              }
            },
            onError: (Object error) {
              if (!completer.isCompleted) {
                completer.complete(error);
              }
            },
          );

          // Act - Send malformed platform message
          await binding.defaultBinaryMessenger.handlePlatformMessage(
            'dev.flutter.pigeon.appmetrica_push_plugin.TokenUpdateApi.onTokenUpdated',
            codec.encodeMessage([
              {'invalid_data': 'mock_token_value'},
            ]), // Invalid format
            (data) {},
          );

          // Wait a bit to see if any event is emitted
          final error = await completer.future.timeout(
            Duration(milliseconds: 5000),
            onTimeout: () => 'No event received',
          );
          expect(error, isA<OnTokenRefreshFailure>());
          expect((error as OnTokenRefreshFailure).error, isFormatException);

          // Cleanup
          await subscription.cancel();
        });
      });

      // Note: Full stream testing would require more complex mocking
      // of EventChannel behavior, which follows AppMetrica's pattern
      // of using handlePlatformMessage for testing streams.
    });

    group('logging behavior', () {
      test('logs messages when logging is enabled', () async {
        // Arrange
        final client = AppmetricaNotificationsClient();

        // Act
        await client.initialize();

        // Assert: No exception thrown means success
        // Note: Testing actual log output would require mocking debugPrint
        // or using a testable logging framework
      });

      test('works when logging is disabled', () async {
        // Arrange
        final client = AppmetricaNotificationsClient(enableLogging: false);

        // Act
        await client.initialize();

        // Assert: No exception thrown means success
        // No logs should be produced, but functionality should work
      });
    });
  });
}
