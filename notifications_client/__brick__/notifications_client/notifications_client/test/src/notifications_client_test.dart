// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:notifications_client/notifications_client.dart';
import 'package:test/test.dart';

/// Test implementation of NotificationsClient for testing purposes
class TestNotificationsClient extends NotificationsClient {
  TestNotificationsClient({super.enableLogging = true});

  // Storage for testing log calls
  final List<String> logMessages = [];

  @override
  void log(String message, {Object? error, StackTrace? stackTrace}) {
    // Override to capture log messages for testing
    if (enableLogging) {
      logMessages.add(message);
    }
    super.log(message, error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> initialize() async {
    // Simple test implementation
    log('Initializing test client...');
  }

  @override
  Stream<PushToken> get onTokenRefresh => Stream.empty();

  @override
  Stream<PushNotification> get onMessage => Stream.empty();

  @override
  Future<PushNotification?> getInitialMessage() async {
    log('Getting initial message...');
    return null;
  }

  @override
  Future<PushToken> getToken() async {
    log('Getting token...');
    return PushToken(
      value: 'test_token',
      provider: PushProvider.firebase,
      createdAt: DateTime.now(),
    );
  }
}

void main() {
  group('NotificationsClient', () {
    late TestNotificationsClient client;

    setUp(() {
      client = TestNotificationsClient();
    });

    group('constructor', () {
      test('can be instantiated with logging enabled by default', () {
        final client = TestNotificationsClient();
        expect(client.enableLogging, isTrue);
      });

      test('can be instantiated with logging disabled', () {
        final client = TestNotificationsClient(enableLogging: false);
        expect(client.enableLogging, isFalse);
      });

      test('can be instantiated with logging explicitly enabled', () {
        final client = TestNotificationsClient();
        expect(client.enableLogging, isTrue);
      });
    });

    group('log method', () {
      test('logs messages when logging is enabled', () {
        // Arrange
        final client = TestNotificationsClient()

        // Act
        ..log('Test message');

        // Assert
        expect(client.logMessages, contains('Test message'));
      });

      test('does not log messages when logging is disabled', () {
        // Arrange
        final client = TestNotificationsClient(enableLogging: false)

        // Act
        ..log('Test message');

        // Assert
        expect(client.logMessages, isEmpty);
      });

      test('logs messages with error and stack trace', () {
        // Arrange
        final client = TestNotificationsClient();
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;

        // Act
        client.log('Error message', error: error, stackTrace: stackTrace);

        // Assert
        expect(client.logMessages, contains('Error message'));
      });

      test('handles null error and stack trace gracefully', () {
        // Arrange
        final client = TestNotificationsClient();

        // Act & Assert (should not throw)
        expect(() => client.log('Message'), returnsNormally);
        expect(client.logMessages, contains('Message'));
      });

      test('logs are called during method execution', () async {
        // Arrange
        final client = TestNotificationsClient();

        // Act
        await client.initialize();
        await client.getInitialMessage();
        await client.getToken();

        // Assert
        expect(client.logMessages, contains('Initializing test client...'));
        expect(client.logMessages, contains('Getting initial message...'));
        expect(client.logMessages, contains('Getting token...'));
      });
    });

    group('abstract methods accessibility', () {
      test('initialize method is accessible', () {
        expect(client.initialize, isA<Function>());
      });

      test('onTokenRefresh stream is accessible', () {
        expect(client.onTokenRefresh, isA<Stream<PushToken>>());
      });

      test('onMessage stream is accessible', () {
        expect(client.onMessage, isA<Stream<PushNotification>>());
      });

      test('getInitialMessage method is accessible', () {
        expect(client.getInitialMessage, isA<Function>());
      });

      test('getToken method is accessible', () {
        expect(client.getToken, isA<Function>());
      });
    });

    group('runtime type information', () {
      test('provides correct runtime type for logging', () {
        // Arrange & Act
        final typeName = client.runtimeType.toString();

        // Assert
        expect(typeName, equals('TestNotificationsClient'));
      });
    });
  });
}
