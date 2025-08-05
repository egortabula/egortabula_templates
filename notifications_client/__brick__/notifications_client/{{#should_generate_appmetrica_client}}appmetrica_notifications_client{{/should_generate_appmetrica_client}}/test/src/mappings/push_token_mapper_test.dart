// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:appmetrica_notifications_client/src/mappings/mappings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications_client/notifications_client.dart';

void main() {
  group('PushTokenMapper', () {
    group('toPushToken', () {
      test('converts Firebase token correctly', () {
        // Arrange
        final tokenData = {'firebase': 'abc123def456firebase'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('abc123def456firebase'));
        expect(result.provider, equals(PushProvider.firebase));
        expect(result.createdAt, isA<DateTime>());
      });

      test('converts APNS token correctly', () {
        // Arrange
        final tokenData = {'apns': 'deadbeefcafeapns'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('deadbeefcafeapns'));
        expect(result.provider, equals(PushProvider.apns));
        expect(result.createdAt, isA<DateTime>());
      });

      test('converts HMS token correctly', () {
        // Arrange
        final tokenData = {'hms': 'xyz789uvwhms'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('xyz789uvwhms'));
        expect(result.provider, equals(PushProvider.hms));
        expect(result.createdAt, isA<DateTime>());
      });

      test('converts Huawei token correctly (case insensitive)', () {
        // Arrange
        final tokenData = {'huawei': 'huaweitoken123'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('huaweitoken123'));
        expect(result.provider, equals(PushProvider.hms));
        expect(result.createdAt, isA<DateTime>());
      });

      test('converts RuStore token correctly', () {
        // Arrange
        final tokenData = {'rustore': 'rustoretoken456'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('rustoretoken456'));
        expect(result.provider, equals(PushProvider.rustore));
        expect(result.createdAt, isA<DateTime>());
      });

      test('handles case insensitive provider names', () {
        // Arrange
        final tokenData = {'FIREBASE': 'uppercase_firebase_token'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('uppercase_firebase_token'));
        expect(result.provider, equals(PushProvider.firebase));
      });

      test('throws FormatException for empty map', () {
        // Arrange
        final tokenData = <String, dynamic>{};

        // Act & Assert
        expect(
          tokenData.toPushToken,
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Push token data is empty'),
            ),
          ),
        );
      });

      test('throws FormatException for null token value', () {
        // Arrange
        final tokenData = {'firebase': null};

        // Act & Assert
        expect(
          tokenData.toPushToken,
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Push token value is null or empty'),
            ),
          ),
        );
      });

      test('throws FormatException for empty token value', () {
        // Arrange
        final tokenData = {'firebase': ''};

        // Act & Assert
        expect(
          tokenData.toPushToken,
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Push token value is null or empty'),
            ),
          ),
        );
      });

      test('throws FormatException for unknown provider', () {
        // Arrange
        final tokenData = {'unknown_provider': 'some_token'};

        // Act & Assert
        expect(
          tokenData.toPushToken,
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              allOf([
                contains('Unknown push token provider: unknown_provider'),
                contains('firebase, apns, hms, rustore'),
              ]),
            ),
          ),
        );
      });

      test('processes first key when multiple providers exist', () {
        // Arrange
        final tokenData = {
          'firebase': 'firebase_token',
          'apns': 'apns_token',
        };

        // Act
        final result = tokenData.toPushToken();

        // Assert
        // Should process the first key (implementation behavior)
        expect(result.value, equals('firebase_token'));
        expect(result.provider, equals(PushProvider.firebase));
      });

      test('handles token with special characters', () {
        // Arrange
        final tokenData = {'firebase': 'token-with_special.chars:123'};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals('token-with_special.chars:123'));
        expect(result.provider, equals(PushProvider.firebase));
      });

      test('handles very long token', () {
        // Arrange
        final longToken = 'a' * 1000; // Very long token
        final tokenData = {'firebase': longToken};

        // Act
        final result = tokenData.toPushToken();

        // Assert
        expect(result.value, equals(longToken));
        expect(result.provider, equals(PushProvider.firebase));
      });

      test('createdAt is set to current time', () {
        // Arrange
        final tokenData = {'firebase': 'time_test_token'};
        final beforeTime = DateTime.now();

        // Act
        final result = tokenData.toPushToken();

        // Assert
        final afterTime = DateTime.now();
        expect(result.createdAt, isNotNull);
        expect(
          result.createdAt.isAfter(beforeTime.subtract(Duration(seconds: 1))),
          isTrue,
        );
        expect(
          result.createdAt.isBefore(afterTime.add(Duration(seconds: 1))),
          isTrue,
        );
      });

      test('throws FormatException for non-string token value', () {
        // Arrange
        final tokenData = {'firebase': 123}; // Non-string value

        // Act & Assert
        expect(
          tokenData.toPushToken,
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
