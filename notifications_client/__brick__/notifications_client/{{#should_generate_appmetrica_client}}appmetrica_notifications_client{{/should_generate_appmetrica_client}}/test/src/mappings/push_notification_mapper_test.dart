// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:appmetrica_notifications_client/src/mappings/mappings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifications_client/notifications_client.dart';

void main() {
  group('PushNotificationMapper', () {
    group('toPushNotification', () {
      test('converts valid JSON with title and body', () {
        // Arrange
        const jsonPayload =
            '{"title": "New Message", "body": "Hello World!", "messageId": '
            '"123", "customData": "test"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('New Message'));
        expect(result.body, equals('Hello World!'));
        expect(result.data, equals({'messageId': '123', 'customData': 'test'}));
        expect(result.receivedAt, isA<DateTime>());
      });

      test('converts valid JSON without title and body', () {
        // Arrange
        const jsonPayload =
            '{"messageId": "456", "senderId": "user789", "type": "silent"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, isNull);
        expect(result.body, isNull);
        expect(
          result.data,
          equals({'messageId': '456', 'senderId': 'user789', 'type': 'silent'}),
        );
        expect(result.receivedAt, isA<DateTime>());
      });

      test('converts JSON with only title', () {
        // Arrange
        const jsonPayload = '{"title": "Important Update", "messageId": "789"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('Important Update'));
        expect(result.body, isNull);
        expect(result.data, equals({'messageId': '789'}));
      });

      test('converts JSON with only body', () {
        // Arrange
        const jsonPayload =
            '{"body": "This is a message body", "userId": "42"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, isNull);
        expect(result.body, equals('This is a message body'));
        expect(result.data, equals({'userId': '42'}));
      });

      test('handles empty JSON object', () {
        // Arrange
        const jsonPayload = '{}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, isNull);
        expect(result.body, isNull);
        expect(result.data, equals({}));
      });

      test('preserves original data when only title/body present', () {
        // Arrange
        const jsonPayload = '{"title": "Test", "body": "Message"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('Test'));
        expect(result.body, equals('Message'));
        // Should preserve original JSON since no custom data remains
        expect(result.data, equals({'title': 'Test', 'body': 'Message'}));
      });

      test('handles complex nested JSON data', () {
        // Arrange
        const jsonPayload = '''
        {
          "title": "Notification Title",
          "body": "Notification Body",
          "metadata": {
            "campaignId": "abc123",
            "trackingData": ["event1", "event2"]
          },
          "settings": {
            "priority": "high",
            "sound": "default"
          }
        }''';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('Notification Title'));
        expect(result.body, equals('Notification Body'));
        expect(result.data, isNotNull);
        expect(result.data!['metadata'], isA<Map<String, dynamic>>());
        expect(result.data!['settings'], isA<Map<String, dynamic>>());
        expect(
          (result.data!['metadata'] as Map)['campaignId'],
          equals('abc123'),
        );
        expect((result.data!['settings'] as Map)['priority'], equals('high'));
      });

      test('returns empty notification for null string', () {
        // Arrange
        const String? jsonPayload = null;

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        final empty = PushNotification.empty();
        expect(result.title, equals(empty.title));
        expect(result.body, equals(empty.body));
        expect(result.data, equals(empty.data));
        expect(result.receivedAt, isA<DateTime>());
      });

      test('returns empty notification for empty string', () {
        // Arrange
        const jsonPayload = '';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        final empty = PushNotification.empty();
        expect(result.title, equals(empty.title));
        expect(result.body, equals(empty.body));
        expect(result.data, equals(empty.data));
        expect(result.receivedAt, isA<DateTime>());
      });

      test('throws FormatException for invalid JSON', () {
        // Arrange
        const invalidJson = '{"title": "Test", "body": }'; // Missing value

        // Act & Assert
        expect(
          () => invalidJson.toPushNotification(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('AppMetrica notification payload parsing failed'),
            ),
          ),
        );
      });

      test('throws FormatException for non-object JSON', () {
        // Arrange
        const arrayJson = '["title", "body"]';

        // Act & Assert
        expect(
          () => arrayJson.toPushNotification(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              allOf([
                contains('Expected JSON object but got List'),
                contains('AppMetrica console'),
              ]),
            ),
          ),
        );
      });

      test('throws FormatException for primitive JSON values', () {
        // Arrange
        const stringJson = '"just a string"';

        // Act & Assert
        expect(
          () => stringJson.toPushNotification(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Expected JSON object but got String'),
            ),
          ),
        );
      });

      test('handles special characters in title and body', () {
        // Arrange
        const jsonPayload =
            r'{"title": "🚀 Special chars: ñáéíóú", "body": "Body with\nnewlines\tand\ttabs", "id": "special"}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('🚀 Special chars: ñáéíóú'));
        expect(result.body, equals('Body with\nnewlines\tand\ttabs'));
        expect(result.data, equals({'id': 'special'}));
      });

      test('handles numeric and boolean values in data', () {
        // Arrange
        const jsonPayload =
            '{"title": "Test", "count": 42, "isRead": true, "priority": 3.14}';

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        expect(result.title, equals('Test'));
        expect(result.data, isNotNull);
        expect(result.data!['count'], equals(42));
        expect(result.data!['isRead'], equals(true));
        expect(result.data!['priority'], equals(3.14));
      });

      test('receivedAt is set to current time', () {
        // Arrange
        const jsonPayload = '{"title": "Time test"}';
        final beforeTime = DateTime.now();

        // Act
        final result = jsonPayload.toPushNotification();

        // Assert
        final afterTime = DateTime.now();
        expect(result.receivedAt, isNotNull);
        expect(
          result.receivedAt!.isAfter(beforeTime.subtract(Duration(seconds: 1))),
          isTrue,
        );
        expect(
          result.receivedAt!.isBefore(afterTime.add(Duration(seconds: 1))),
          isTrue,
        );
      });
    });
  });
}
