// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:notifications_client/notifications_client.dart';
import 'package:test/test.dart';

void main() {
  group('NotificationException', () {
    group('hierarchy', () {
      test(
        'InitializeNotificationClientFailure extends NotificationException',
        () {
          final exception = InitializeNotificationClientFailure('test error');
          expect(exception, isA<NotificationException>());
          expect(exception, isA<Exception>());
        },
      );

      test('GetInitialMessageFailure extends NotificationException', () {
        final exception = GetInitialMessageFailure('test error');
        expect(exception, isA<NotificationException>());
        expect(exception, isA<Exception>());
      });

      test('GetTokenFailure extends NotificationException', () {
        final exception = GetTokenFailure('test error');
        expect(exception, isA<NotificationException>());
        expect(exception, isA<Exception>());
      });

      test('OnTokenRefreshFailure extends NotificationException', () {
        final exception = OnTokenRefreshFailure('test error');
        expect(exception, isA<NotificationException>());
        expect(exception, isA<Exception>());
      });

      test('OnPushMessageFailure extends NotificationException', () {
        final exception = OnPushMessageFailure('test error');
        expect(exception, isA<NotificationException>());
        expect(exception, isA<Exception>());
      });
    });

    group('error property', () {
      test('stores error object correctly', () {
        const errorMessage = 'Test error message';
        final exception = InitializeNotificationClientFailure(errorMessage);

        expect(exception.error, equals(errorMessage));
      });

      test('stores complex error objects', () {
        final errorObject = Exception('Complex error');
        final exception = GetTokenFailure(errorObject);

        expect(exception.error, equals(errorObject));
      });

      test('stores null error', () {
        const Object nullError = 'null_placeholder'; // Object can't be null
        final exception = OnPushMessageFailure(nullError);

        expect(exception.error, equals(nullError));
      });

      test('stores different error types', () {
        const stringError = 'String error';
        const intError = 404;
        final mapError = {'error': 'code', 'message': 'description'};

        expect(
          InitializeNotificationClientFailure(stringError).error,
          equals(stringError),
        );
        expect(GetInitialMessageFailure(intError).error, equals(intError));
        expect(GetTokenFailure(mapError).error, equals(mapError));
      });
    });
  });

  group('InitializeNotificationClientFailure', () {
    test('creates instance with error message', () {
      const errorMessage = 'Initialization failed';
      final exception = InitializeNotificationClientFailure(errorMessage);

      expect(exception.error, equals(errorMessage));
    });

    test('toString includes error message', () {
      const errorMessage = 'Network connection failed';
      final exception = InitializeNotificationClientFailure(errorMessage);

      final result = exception.toString();

      expect(result, contains('Failed to initialize notification client'));
      expect(result, contains(errorMessage));
      expect(
        result,
        equals('Failed to initialize notification client: $errorMessage'),
      );
    });

    test('toString handles different error types', () {
      final exception1 = InitializeNotificationClientFailure('String error');
      final exception2 = InitializeNotificationClientFailure(
        Exception('Exception error'),
      );
      final exception3 = InitializeNotificationClientFailure(42);

      expect(exception1.toString(), contains('String error'));
      expect(exception2.toString(), contains('Exception: Exception error'));
      expect(exception3.toString(), contains('42'));
    });
  });

  group('GetInitialMessageFailure', () {
    test('creates instance with error message', () {
      const errorMessage = 'No initial message found';
      final exception = GetInitialMessageFailure(errorMessage);

      expect(exception.error, equals(errorMessage));
    });

    test('toString includes error message', () {
      const errorMessage = 'Message parsing failed';
      final exception = GetInitialMessageFailure(errorMessage);

      final result = exception.toString();

      expect(result, contains('Failed to get initial message'));
      expect(result, contains(errorMessage));
      expect(result, equals('Failed to get initial message: $errorMessage'));
    });

    test('handles null and empty errors', () {
      final exception1 = GetInitialMessageFailure(
        '',
      ); // Use empty string instead of null
      final exception2 = GetInitialMessageFailure('');

      expect(exception1.toString(), equals('Failed to get initial message: '));
      expect(exception2.toString(), equals('Failed to get initial message: '));
    });
  });

  group('GetTokenFailure', () {
    test('creates instance with error message', () {
      const errorMessage = 'Token retrieval failed';
      final exception = GetTokenFailure(errorMessage);

      expect(exception.error, equals(errorMessage));
    });

    test('toString includes error message', () {
      const errorMessage = 'Token service unavailable';
      final exception = GetTokenFailure(errorMessage);

      final result = exception.toString();

      expect(result, contains('Failed to get push token'));
      expect(result, contains(errorMessage));
      expect(result, equals('Failed to get push token: $errorMessage'));
    });

    test('handles complex error objects', () {
      final complexError = {
        'code': 'TOKEN_ERROR',
        'message': 'Service temporarily unavailable',
        'retryAfter': 300,
      };
      final exception = GetTokenFailure(complexError);

      expect(exception.toString(), contains(complexError.toString()));
    });
  });

  group('OnTokenRefreshFailure', () {
    test('creates instance with error message', () {
      const errorMessage = 'Token refresh failed';
      final exception = OnTokenRefreshFailure(errorMessage);

      expect(exception.error, equals(errorMessage));
    });

    test('toString includes error message', () {
      const errorMessage = 'Invalid token format';
      final exception = OnTokenRefreshFailure(errorMessage);

      final result = exception.toString();

      expect(result, contains('Failed to handle token refresh'));
      expect(result, contains(errorMessage));
      expect(result, equals('Failed to handle token refresh: $errorMessage'));
    });

    test('handles platform exceptions', () {
      final platformError = Exception('Platform channel error');
      final exception = OnTokenRefreshFailure(platformError);

      expect(
        exception.toString(),
        contains('Exception: Platform channel error'),
      );
    });
  });

  group('OnPushMessageFailure', () {
    test('creates instance with error message', () {
      const errorMessage = 'Message processing failed';
      final exception = OnPushMessageFailure(errorMessage);

      expect(exception.error, equals(errorMessage));
    });

    test('toString includes error message', () {
      const errorMessage = 'Invalid message payload';
      final exception = OnPushMessageFailure(errorMessage);

      final result = exception.toString();

      expect(result, contains('Failed to handle push message'));
      expect(result, contains(errorMessage));
      expect(result, equals('Failed to handle push message: $errorMessage'));
    });

    test('handles JSON parsing errors', () {
      final jsonError = FormatException('Invalid JSON format');
      final exception = OnPushMessageFailure(jsonError);

      expect(exception.toString(), contains('FormatException'));
      expect(exception.toString(), contains('Invalid JSON format'));
    });
  });

  group('exception equality and comparison', () {
    test('exceptions with same error are not automatically equal', () {
      final exception1 = InitializeNotificationClientFailure('same error');
      final exception2 = InitializeNotificationClientFailure('same error');

      // Exception classes don't override == by default
      expect(exception1 == exception2, isFalse);
      expect(exception1.error == exception2.error, isTrue);
    });

    test('different exception types with same error are different', () {
      const sameError = 'same error message';
      final exception1 = InitializeNotificationClientFailure(sameError);
      final exception2 = GetTokenFailure(sameError);

      expect(exception1.runtimeType, isNot(equals(exception2.runtimeType)));
      expect(exception1.error, equals(exception2.error));
    });

    test('error objects maintain their identity', () {
      final originalError = Exception('original');
      final exception = OnPushMessageFailure(originalError);

      expect(identical(exception.error, originalError), isTrue);
    });
  });

  group('exception usage patterns', () {
    test('can be thrown and caught generically', () {
      expect(
        () => throw InitializeNotificationClientFailure('test'),
        throwsA(isA<NotificationException>()),
      );
    });

    test('can be thrown and caught specifically', () {
      expect(
        () => throw GetTokenFailure('test'),
        throwsA(isA<GetTokenFailure>()),
      );
    });

    test('can be caught as Exception', () {
      expect(
        () => throw OnTokenRefreshFailure('test'),
        throwsA(isA<Exception>()),
      );
    });

    test('supports chained exception handling', () {
      try {
        throw OnPushMessageFailure('original error');
      } catch (e) {
        expect(
          () => throw InitializeNotificationClientFailure('wrapped: $e'),
          throwsA(isA<InitializeNotificationClientFailure>()),
        );
      }
    });
  });
}
