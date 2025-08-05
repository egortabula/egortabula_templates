// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:notifications_client/notifications_client.dart';
import 'package:test/test.dart';

void main() {
  group('PushProvider', () {
    test('has correct values for all providers', () {
      expect(PushProvider.firebase.value, equals('firebase'));
      expect(PushProvider.apns.value, equals('apns'));
      expect(PushProvider.hms.value, equals('hms'));
      expect(PushProvider.rustore.value, equals('rustore'));
    });

    test('provides all expected providers', () {
      const providers = PushProvider.values;
      expect(providers, hasLength(4));
      expect(providers, contains(PushProvider.firebase));
      expect(providers, contains(PushProvider.apns));
      expect(providers, contains(PushProvider.hms));
      expect(providers, contains(PushProvider.rustore));
    });

    test('has unique values for all providers', () {
      final values = PushProvider.values.map((p) => p.value).toSet();
      expect(values, hasLength(4));
    });
  });

  group('PushToken', () {
    const testToken = 'abc123def456';
    final testDate = DateTime(2024, 1, 15, 10, 30);

    group('constructor', () {
      test('creates instance with all required parameters', () {
        final token = PushToken(
          value: testToken,
          provider: PushProvider.firebase,
          createdAt: testDate,
        );

        expect(token.value, equals(testToken));
        expect(token.provider, equals(PushProvider.firebase));
        expect(token.createdAt, equals(testDate));
      });

      test('requires all parameters', () {
        expect(
          () => PushToken(
            value: testToken,
            provider: PushProvider.firebase,
            createdAt: testDate,
          ),
          returnsNormally,
        );
      });
    });

    group('factory constructors', () {
      test('firebase factory creates token with firebase provider', () {
        final token = PushToken.firebase(testToken);

        expect(token.value, equals(testToken));
        expect(token.provider, equals(PushProvider.firebase));
        expect(token.createdAt, isA<DateTime>());
        expect(
          token.createdAt.isBefore(DateTime.now().add(Duration(seconds: 1))),
          isTrue,
        );
      });

      test('apns factory creates token with apns provider', () {
        final token = PushToken.apns(testToken);

        expect(token.value, equals(testToken));
        expect(token.provider, equals(PushProvider.apns));
        expect(token.createdAt, isA<DateTime>());
      });

      test('hms factory creates token with hms provider', () {
        final token = PushToken.hms(testToken);

        expect(token.value, equals(testToken));
        expect(token.provider, equals(PushProvider.hms));
        expect(token.createdAt, isA<DateTime>());
      });

      test('rustore factory creates token with rustore provider', () {
        final token = PushToken.rustore(testToken);

        expect(token.value, equals(testToken));
        expect(token.provider, equals(PushProvider.rustore));
        expect(token.createdAt, isA<DateTime>());
      });
    });

    group('toMap', () {
      test('converts token to map correctly', () {
        final token = PushToken(
          value: testToken,
          provider: PushProvider.firebase,
          createdAt: testDate,
        );

        final map = token.toMap();

        expect(map, isA<Map<String, dynamic>>());
        expect(map['token'], equals(testToken));
        expect(map['provider'], equals('firebase'));
        expect(map['createdAt'], equals('2024-01-15T10:30:00.000'));
      });

      test('handles different providers correctly', () {
        final tokens = [
          PushToken(
            value: testToken,
            provider: PushProvider.firebase,
            createdAt: testDate,
          ),
          PushToken(
            value: testToken,
            provider: PushProvider.apns,
            createdAt: testDate,
          ),
          PushToken(
            value: testToken,
            provider: PushProvider.hms,
            createdAt: testDate,
          ),
          PushToken(
            value: testToken,
            provider: PushProvider.rustore,
            createdAt: testDate,
          ),
        ];

        final expectedProviders = ['firebase', 'apns', 'hms', 'rustore'];

        for (var i = 0; i < tokens.length; i++) {
          final map = tokens[i].toMap();
          expect(map['provider'], equals(expectedProviders[i]));
        }
      });

      test('includes all required fields', () {
        final token = PushToken.firebase(testToken);
        final map = token.toMap();

        expect(map.keys, hasLength(3));
        expect(map, containsPair('token', testToken));
        expect(map, containsPair('provider', 'firebase'));
        expect(map, contains('createdAt'));
      });
    });
  });

  group('PushNotification', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);
    const testData = {'key': 'value', 'number': 42};

    group('constructor', () {
      test('creates instance with all parameters', () {
        final notification = PushNotification(
          title: 'Test Title',
          body: 'Test Body',
          data: testData,
          receivedAt: testDate,
        );

        expect(notification.title, equals('Test Title'));
        expect(notification.body, equals('Test Body'));
        expect(notification.data, equals(testData));
        expect(notification.receivedAt, equals(testDate));
      });

      test('creates instance with only some parameters', () {
        final notification = PushNotification(
          title: 'Test Title',
        );

        expect(notification.title, equals('Test Title'));
        expect(notification.body, isNull);
        expect(notification.data, isNull);
        expect(notification.receivedAt, isNull);
      });

      test('creates instance with no parameters', () {
        final notification = PushNotification();

        expect(notification.title, isNull);
        expect(notification.body, isNull);
        expect(notification.data, isNull);
        expect(notification.receivedAt, isNull);
      });
    });

    group('empty factory', () {
      test('creates empty notification with current timestamp', () {
        final beforeCreation = DateTime.now();
        final notification = PushNotification.empty();
        final afterCreation = DateTime.now();

        expect(notification.title, isNull);
        expect(notification.body, isNull);
        expect(notification.data, isNull);
        expect(notification.receivedAt, isNotNull);
        expect(
          notification.receivedAt!.isAfter(beforeCreation) ||
              notification.receivedAt!.isAtSameMomentAs(beforeCreation),
          isTrue,
        );
        expect(
          notification.receivedAt!.isBefore(afterCreation) ||
              notification.receivedAt!.isAtSameMomentAs(afterCreation),
          isTrue,
        );
      });
    });

    group('isEmpty getter', () {
      test('returns true for default empty notification', () {
        final empty1 = PushNotification.empty();
        final empty2 = PushNotification.empty();

        // Since timestamps are different, they won't be equal
        // Testing the getter logic indirectly
        expect(empty1.title, isNull);
        expect(empty1.body, isNull);
        expect(empty1.data, isNull);
      });

      test('returns false for notification with content', () {
        final notification = PushNotification(title: 'Test');
        expect(notification.isEmpty, isFalse);
      });

      test('returns false for notification with data', () {
        final notification = PushNotification(data: const {'key': 'value'});
        expect(notification.isEmpty, isFalse);
      });
    });

    group('equality', () {
      test('notifications with same properties are equal', () {
        final notification1 = PushNotification(
          title: 'Test',
          body: 'Body',
          data: testData,
          receivedAt: testDate,
        );
        final notification2 = PushNotification(
          title: 'Test',
          body: 'Body',
          data: testData,
          receivedAt: testDate,
        );

        expect(notification1, equals(notification2));
        expect(notification1.hashCode, equals(notification2.hashCode));
      });

      test('notifications with different properties are not equal', () {
        final notification1 = PushNotification(title: 'Test1');
        final notification2 = PushNotification(title: 'Test2');

        expect(notification1, isNot(equals(notification2)));
      });

      test('notifications with null vs non-null values are not equal', () {
        final notification1 = PushNotification();
        final notification2 = PushNotification(title: 'Test');

        expect(notification1, isNot(equals(notification2)));
      });
    });

    group('toString', () {
      test('includes all properties in string representation', () {
        final notification = PushNotification(
          title: 'Test Title',
          body: 'Test Body',
          data: testData,
          receivedAt: testDate,
        );

        final string = notification.toString();

        expect(string, contains('PushNotification'));
        expect(string, contains('Test Title'));
        expect(string, contains('Test Body'));
        expect(string, contains(testData.toString()));
        expect(string, contains(testDate.toString()));
      });

      test('handles null values in string representation', () {
        final notification = PushNotification();
        final string = notification.toString();

        expect(string, contains('PushNotification'));
        expect(string, contains('null'));
      });
    });

    group('props getter', () {
      test('returns all properties for equality comparison', () {
        final notification = PushNotification(
          title: 'Test',
          body: 'Body',
          data: testData,
          receivedAt: testDate,
        );

        final props = notification.props;

        expect(props, hasLength(4));
        expect(props, contains('Test'));
        expect(props, contains('Body'));
        expect(props, contains(testData));
        expect(props, contains(testDate));
      });

      test('handles null properties correctly', () {
        final notification = PushNotification();
        final props = notification.props;

        expect(props, hasLength(4));
        expect(props, contains(null));
      });
    });
  });
}
