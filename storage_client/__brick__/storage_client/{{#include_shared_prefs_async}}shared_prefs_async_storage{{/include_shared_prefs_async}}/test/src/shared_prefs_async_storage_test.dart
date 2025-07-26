import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefs_async_storage/shared_prefs_async_storage.dart';
import 'package:storage/storage.dart';
import '../test_data/test_data.dart';

class MockSharedPreferencesAsync extends Mock
    implements SharedPreferencesAsync {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferencesAsync mockSharedPreferences;
  late SharedPrefsAsyncStorage storage;

  setUp(() {
    mockSharedPreferences = MockSharedPreferencesAsync();
    storage = SharedPrefsAsyncStorage(
      sharedPreferences: mockSharedPreferences,
    );
  });
  group('SharedPrefsAsyncStorage', () {
    group('constructor', () {
      test('should use provided SharedPreferencesAsync instance', () {
        final mockPrefs = MockSharedPreferencesAsync();
        final storage = SharedPrefsAsyncStorage(sharedPreferences: mockPrefs);

        // Проверяем что экземпляр создался успешно
        expect(storage, isA<SharedPrefsAsyncStorage>());
      });
    });

    {{#include_clear}}
    group('clear', () {
      test('should clear all data successfully', () async {
        when(() => mockSharedPreferences.clear()).thenAnswer((_) async {});

        await storage.clear();

        verify(() => mockSharedPreferences.clear()).called(1);
      });

      test('should throw StorageException when clear fails', () async {
        final exception = Exception('Clear failed');
        when(() => mockSharedPreferences.clear()).thenThrow(exception);

        expect(
          () => storage.clear(),
          throwsA(
            isA<StorageException>().having(
              (e) => e.error,
              'error',
              equals(exception),
            ),
          ),
        );
      });
    });
    {{/include_clear}}

    {{#include_containsKey}}
    group('containsKey', () {
      test('should return true when key exists', () async {
        const key = 'test_key';
        when(
          () => mockSharedPreferences.containsKey(key),
        ).thenAnswer((_) async => true);

        final result = await storage.containsKey(key);

        expect(result, isTrue);
        verify(() => mockSharedPreferences.containsKey(key)).called(1);
      });

      test('should return false when key does not exist', () async {
        const key = 'test_key';
        when(
          () => mockSharedPreferences.containsKey(key),
        ).thenAnswer((_) async => false);

        final result = await storage.containsKey(key);

        expect(result, isFalse);
      });

      test('should throw StorageException when containsKey fails', () async {
        const key = 'test_key';
        final exception = Exception('ContainsKey failed');
        when(
          () => mockSharedPreferences.containsKey(key),
        ).thenThrow(exception);

        expect(
          () => storage.containsKey(key),
          throwsA(
            isA<StorageException>().having(
              (e) => e.error,
              'error',
              equals(exception),
            ),
          ),
        );
      });
    });
    {{/include_containsKey}}

    {{#include_delete}}
    group('delete', () {
      test('should delete key successfully', () async {
        const key = 'test_key';
        when(
          () => mockSharedPreferences.remove(key),
        ).thenAnswer((_) async => true);

        await storage.delete(key: key);

        verify(() => mockSharedPreferences.remove(key)).called(1);
      });

      test('should throw StorageException when delete fails', () async {
        const key = 'test_key';
        final exception = Exception('Delete failed');
        when(
          () => mockSharedPreferences.remove(key),
        ).thenThrow(exception);

        expect(
          () => storage.delete(key: key),
          throwsA(
            isA<StorageException>().having(
              (e) => e.error,
              'error',
              equals(exception),
            ),
          ),
        );
      });
    });
    {{/include_delete}}

    {{#include_read}}
    group('read', () {
      group('bool', () {
        test('should read bool value successfully', () async {
          const key = 'bool_key';
          const value = true;
          when(
            () => mockSharedPreferences.getBool(key),
          ).thenAnswer((_) async => value);

          final result = await storage.read<bool>(key: key);

          expect(result, equals(value));
          verify(() => mockSharedPreferences.getBool(key)).called(1);
        });

        test('should return null when bool key does not exist', () async {
          const key = 'bool_key';
          when(
            () => mockSharedPreferences.getBool(key),
          ).thenAnswer((_) async => null);

          final result = await storage.read<bool>(key: key);

          expect(result, isNull);
        });
      });

      group('double', () {
        test('should read double value successfully', () async {
          const key = 'double_key';
          const value = 3.14;
          when(
            () => mockSharedPreferences.getDouble(key),
          ).thenAnswer((_) async => value);

          final result = await storage.read<double>(key: key);

          expect(result, equals(value));
          verify(() => mockSharedPreferences.getDouble(key)).called(1);
        });

        test('should return null when double key does not exist', () async {
          const key = 'double_key';
          when(
            () => mockSharedPreferences.getDouble(key),
          ).thenAnswer((_) async => null);

          final result = await storage.read<double>(key: key);

          expect(result, isNull);
        });
      });

      group('int', () {
        test('should read int value successfully', () async {
          const key = 'int_key';
          const value = 42;
          when(
            () => mockSharedPreferences.getInt(key),
          ).thenAnswer((_) async => value);

          final result = await storage.read<int>(key: key);

          expect(result, equals(value));
          verify(() => mockSharedPreferences.getInt(key)).called(1);
        });

        test('should return null when int key does not exist', () async {
          const key = 'int_key';
          when(
            () => mockSharedPreferences.getInt(key),
          ).thenAnswer((_) async => null);

          final result = await storage.read<int>(key: key);

          expect(result, isNull);
        });
      });
      group('String', () {
        test('should read String value successfully', () async {
          const key = 'string_key';
          const value = 'Hello World';
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => value);

          final result = await storage.read<String>(key: key);

          expect(result, equals(value));
        });
      });

      group('List', () {
        test('should read List value successfully', () async {
          const key = 'list_key';
          const value = [1, 2, 3];
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => jsonEncode(value));

          final result = await storage.read<List<dynamic>>(key: key);

          expect(result, equals(value));
        });
      });

      group('List<String>', () {
        test('should read List<String> value successfully', () async {
          const key = 'string_list_key';
          const value = ['hello', 'world', 'flutter'];
          when(
            () => mockSharedPreferences.getStringList(key),
          ).thenAnswer((_) async => value);

          final result = await storage.read<List<String>>(key: key);

          expect(result, equals(value));
          verify(() => mockSharedPreferences.getStringList(key)).called(1);
        });

        test(
          'should return null when List<String> key does not exist',
          () async {
            const key = 'string_list_key';
            when(
              () => mockSharedPreferences.getStringList(key),
            ).thenAnswer((_) async => null);

            final result = await storage.read<List<String>>(key: key);

            expect(result, isNull);
          },
        );
      });
      group('Map', () {
        test('should read Map value successfully', () async {
          const key = 'map_key';
          const value = {'name': 'John', 'age': 30};
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => jsonEncode(value));

          final result = await storage.read<Map<String, dynamic>>(key: key);

          expect(result, equals(value));
        });

        test('should read basic Map type successfully', () async {
          const key = 'map_key';
          const value = {'name': 'John', 'age': 30};
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => jsonEncode(value));

          final result = await storage.read<Map>(key: key);

          expect(result, equals(value));
        });
      });

      group('DateTime', () {
        test('should read DateTime value successfully', () async {
          const key = 'datetime_key';
          final value = DateTime(2023, 12, 25);
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => value.toIso8601String());

          final result = await storage.read<DateTime>(key: key);

          expect(result, equals(value));
        });
      });

      group('Uri', () {
        test('should read Uri value successfully', () async {
          const key = 'uri_key';
          final value = Uri.parse('https://example.com/path?param=value');
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => value.toString());

          final result = await storage.read<Uri>(key: key);

          expect(result, equals(value));
        });

        test('should return null when Uri key does not exist', () async {
          const key = 'uri_key';
          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => null);

          final result = await storage.read<Uri>(key: key);

          expect(result, isNull);
        });
      });

      group('Set', () {
        group('Set<String>', () {
          test('should read Set<String> value successfully', () async {
            const key = 'set_string_key';
            const value = {'item1', 'item2', 'item3'};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<String>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<String>>());
            expect(result!.length, equals(3));
          });

          test('should handle empty Set<String> correctly', () async {
            const key = 'empty_set_string_key';
            const value = <String>{};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<String>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<String>>());
            expect(result!.isEmpty, isTrue);
          });

          test(
            'should return null when Set<String> key does not exist',
            () async {
              const key = 'set_string_key';
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => null);

              final result = await storage.read<Set<String>>(key: key);

              expect(result, isNull);
            },
          );
        });

        group('Set<int>', () {
          test('should read Set<int> value successfully', () async {
            const key = 'set_int_key';
            const value = {1, 2, 3, 4, 5};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<int>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<int>>());
            expect(result!.length, equals(5));
          });

          test('should handle empty Set<int> correctly', () async {
            const key = 'empty_set_int_key';
            const value = <int>{};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<int>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<int>>());
            expect(result!.isEmpty, isTrue);
          });

          test('should return null when Set<int> key does not exist', () async {
            const key = 'set_int_key';
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => null);

            final result = await storage.read<Set<int>>(key: key);

            expect(result, isNull);
          });
        });

        group('Set<double>', () {
          test('should read Set<double> value successfully', () async {
            const key = 'set_double_key';
            final value = {1.5, 2.7, 3.14, 4.0};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<double>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<double>>());
            expect(result!.length, equals(4));
          });

          test('should handle empty Set<double> correctly', () async {
            const key = 'empty_set_double_key';
            const value = <double>{};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<double>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<double>>());
            expect(result!.isEmpty, isTrue);
          });

          test(
            'should return null when Set<double> key does not exist',
            () async {
              const key = 'set_double_key';
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => null);

              final result = await storage.read<Set<double>>(key: key);

              expect(result, isNull);
            },
          );
        });

        group('Set<bool>', () {
          test('should read Set<bool> value successfully', () async {
            const key = 'set_bool_key';
            const value = {true, false};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<bool>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<bool>>());
            expect(result!.length, equals(2));
          });

          test('should handle single value Set<bool> correctly', () async {
            const key = 'single_bool_set_key';
            const value = {true};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<bool>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<bool>>());
            expect(result!.length, equals(1));
            expect(result.first, isTrue);
          });

          test('should handle empty Set<bool> correctly', () async {
            const key = 'empty_set_bool_key';
            const value = <bool>{};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<bool>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<bool>>());
            expect(result!.isEmpty, isTrue);
          });
        });

        group('Set<dynamic>', () {
          test('should read Set<dynamic> value successfully', () async {
            const key = 'set_dynamic_key';
            final value = {1, 'string', true, 3.14};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<dynamic>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<dynamic>>());
            expect(result!.length, equals(4));
          });

          test(
            'should handle complex Set<dynamic> with nested structures',
            () async {
              const key = 'complex_set_dynamic_key';
              final value = {
                1,
                'string',
                [1, 2, 3],
                {'nested': 'map'},
              };
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => jsonEncode(value.toList()));

              final result = await storage.read<Set<dynamic>>(key: key);

              expect(result, isA<Set<dynamic>>());
              expect(result!.length, equals(4));
              expect(result.contains(1), isTrue);
              expect(result.contains('string'), isTrue);
            },
          );

          test('should handle empty Set<dynamic> correctly', () async {
            const key = 'empty_set_dynamic_key';
            const value = <dynamic>{};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<dynamic>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<dynamic>>());
            expect(result!.isEmpty, isTrue);
          });
        });

        group('Set edge cases', () {
          test('should handle Set with duplicate values correctly', () async {
            const key = 'duplicate_set_key';
            // Set автоматически убирает дубликаты
            final originalValue = {'item1', 'item2', 'item1', 'item3', 'item2'};
            const expectedValue = {'item1', 'item2', 'item3'};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(originalValue.toList()));

            final result = await storage.read<Set<String>>(key: key);

            expect(result, equals(expectedValue));
            expect(result!.length, equals(3));
          });

          test('should handle Set with null values in Set<dynamic>', () async {
            const key = 'null_values_set_key';
            final value = {1, null, 'string', null};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<dynamic>>(key: key);

            expect(result, isA<Set<dynamic>>());
            expect(result!.contains(null), isTrue);
            expect(result.contains(1), isTrue);
            expect(result.contains('string'), isTrue);
          });

          test('should handle very large Set correctly', () async {
            const key = 'large_set_key';
            final largeSet = List.generate(
              1000,
              (index) => 'item$index',
            ).toSet();
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(largeSet.toList()));

            final result = await storage.read<Set<String>>(key: key);

            expect(result, isA<Set<String>>());
            expect(result!.length, equals(1000));
            expect(result.contains('item0'), isTrue);
            expect(result.contains('item999'), isTrue);
          });

          test('should handle Set with special characters', () async {
            const key = 'special_chars_set_key';
            const value = {'🚀', '🎯', '✅', '❌', '🔥'};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(value.toList()));

            final result = await storage.read<Set<String>>(key: key);

            expect(result, equals(value));
            expect(result, isA<Set<String>>());
            expect(result!.length, equals(5));
          });
        });

        group('Set error handling', () {
          test('should throw StorageException for non-List data', () async {
            const key = 'invalid_set_key';
            final invalidData = {'not': 'a list', 'but': 'an object'};
            when(
              () => mockSharedPreferences.getString(key),
            ).thenAnswer((_) async => jsonEncode(invalidData));

            await expectLater(
              () => storage.read<Set<String>>(key: key),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error.toString(),
                  'error message',
                  allOf([
                    contains('Cannot convert'),
                    contains('to Set'),
                    contains('Expected List'),
                  ]),
                ),
              ),
            );
          });

          test(
            'should throw StorageException for type cast errors in Set<String>',
            () async {
              const key = 'invalid_cast_set_key';
              final mixedData = [1, 'string', true, 3.14];
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => jsonEncode(mixedData));

              await expectLater(
                () => storage.read<Set<String>>(key: key),
                throwsA(isA<StorageException>()),
              );
            },
          );

          test(
            'should throw StorageException for type cast errors in Set<int>',
            () async {
              const key = 'invalid_int_set_key';
              final invalidIntData = ['not', 'integers', 'here'];
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => jsonEncode(invalidIntData));

              await expectLater(
                () => storage.read<Set<int>>(key: key),
                throwsA(isA<StorageException>()),
              );
            },
          );

          test(
            'should throw StorageException for type cast errors in Set<double>',
            () async {
              const key = 'invalid_double_set_key';
              final invalidDoubleData = ['not', 'doubles', 'here'];
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => jsonEncode(invalidDoubleData));

              await expectLater(
                () => storage.read<Set<double>>(key: key),
                throwsA(isA<StorageException>()),
              );
            },
          );

          test(
            'should throw StorageException for type cast errors in Set<bool>',
            () async {
              const key = 'invalid_bool_set_key';
              final invalidBoolData = ['not', 'booleans', 'here'];
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => jsonEncode(invalidBoolData));

              await expectLater(
                () => storage.read<Set<bool>>(key: key),
                throwsA(isA<StorageException>()),
              );
            },
          );

          test(
            'should throw StorageException when JSON decode fails',
            () async {
              const key = 'invalid_json_set_key';
              const invalidJson = 'invalid json string {[';
              when(
                () => mockSharedPreferences.getString(key),
              ).thenAnswer((_) async => invalidJson);

              await expectLater(
                () => storage.read<Set<String>>(key: key),
                throwsA(isA<StorageException>()),
              );
            },
          );

          test('should throw StorageException when getString fails', () async {
            const key = 'failing_set_key';
            final exception = Exception('GetString failed');
            when(
              () => mockSharedPreferences.getString(key),
            ).thenThrow(exception);

            await expectLater(
              () => storage.read<Set<String>>(key: key),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error,
                  'error',
                  equals(exception),
                ),
              ),
            );
          });
        });
      });
      group('unsupported types', () {
        test('should throw StorageException for unsupported type', () async {
          const key = 'custom_key';

          expect(
            () => storage.read<Duration>(key: key),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(), // Используем error поле
                'error message',
                contains('Cannot read value of type Duration'),
              ),
            ),
          );
        });

        test('should throw StorageException for custom class type', () async {
          const key = 'user_key';

          expect(
            () => storage.read<CustomUser>(key: key),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(),
                'error message',
                contains('Cannot read value of type CustomUser'),
              ),
            ),
          );
        });

        test('should throw StorageException for BigInt type', () async {
          const key = 'bigint_key';

          expect(
            () => storage.read<BigInt>(key: key),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(),
                'error message',
                contains('Cannot read value of type BigInt'),
              ),
            ),
          );
        });

        test('should throw StorageException for Enum type', () async {
          const key = 'enum_key';

          expect(
            () => storage.read<TestEnum>(key: key),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(),
                'error message',
                contains('Cannot read value of type TestEnum'),
              ),
            ),
          );
        });
      });

      // В группе read тестов
      group('JSON serializable objects in read', () {
        test('should read JSON data back as Map', () async {
          const key = 'json_user_key';
          const user = JsonSerializableUser(
            id: 1,
            name: 'John Doe',
            email: 'john@example.com',
          );
          final userJson = user.toJson();

          when(
            () => mockSharedPreferences.getString(key),
          ).thenAnswer((_) async => jsonEncode(userJson));

          final result = await storage.read<Map<String, dynamic>>(key: key);

          expect(result, equals(userJson));

          // Проверяем что можно восстановить объект
          if (result != null) {
            final restoredUser = JsonSerializableUser.fromJson(result);
            expect(restoredUser, equals(user));
          }
        });
      });
    });
    {{/include_read}}
    
    {{#include_write}}
    group('write', () {
      group('null value', () {
        test('should remove key when value is null', () async {
          const key = 'test_key';
          when(
            () => mockSharedPreferences.remove(key),
          ).thenAnswer((_) async => true);

          await storage.write(key: key, value: null);

          verify(() => mockSharedPreferences.remove(key)).called(1);
        });
      });

      group('bool', () {
        test('should write bool value successfully', () async {
          const key = 'bool_key';
          const value = true;
          when(
            () => mockSharedPreferences.setBool(key, value),
          ).thenAnswer((_) async {});

          await storage.write(key: key, value: value);

          verify(() => mockSharedPreferences.setBool(key, value)).called(1);
        });
      });

      group('String', () {
        test('should write String value successfully', () async {
          const key = 'string_key';
          const value = 'Hello World';
          when(
            () => mockSharedPreferences.setString(key, value),
          ).thenAnswer((_) async {});

          await storage.write(key: key, value: value);

          verify(() => mockSharedPreferences.setString(key, value)).called(1);
        });
      });

      group('Map', () {
        test('should write Map value successfully', () async {
          const key = 'map_key';
          const value = {'name': 'John', 'age': 30};
          when(
            () => mockSharedPreferences.setString(key, any()),
          ).thenAnswer((_) async {});

          await storage.write(key: key, value: value);

          verify(
            () => mockSharedPreferences.setString(key, jsonEncode(value)),
          ).called(1);
        });
      });

      group('DateTime', () {
        test('should write DateTime value successfully', () async {
          const key = 'datetime_key';
          final value = DateTime(2023, 12, 25);
          when(
            () => mockSharedPreferences.setString(key, any()),
          ).thenAnswer((_) async {});

          await storage.write(key: key, value: value);

          verify(
            () => mockSharedPreferences.setString(
              key,
              value.toIso8601String(),
            ),
          ).called(1);
        });
      });

      group('Set', () {
        group('Set<String>', () {
          test('should write Set<String> value successfully', () async {
            const key = 'set_string_key';
            const value = {'item1', 'item2', 'item3'};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test('should write empty Set<String> successfully', () async {
            const key = 'empty_set_string_key';
            const value = <String>{};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });
        });

        group('Set<int>', () {
          test('should write Set<int> value successfully', () async {
            const key = 'set_int_key';
            const value = {1, 2, 3, 4, 5};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test('should write empty Set<int> successfully', () async {
            const key = 'empty_set_int_key';
            const value = <int>{};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });
        });

        group('Set<double>', () {
          test('should write Set<double> value successfully', () async {
            const key = 'set_double_key';
            final value = {1.5, 2.7, 3.14};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test('should write empty Set<double> successfully', () async {
            const key = 'empty_set_double_key';
            const value = <double>{};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });
        });

        group('Set<bool>', () {
          test('should write Set<bool> value successfully', () async {
            const key = 'set_bool_key';
            const value = {true, false};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test('should write single value Set<bool> successfully', () async {
            const key = 'single_bool_set_key';
            const value = {true};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });
        });

        group('Set<dynamic>', () {
          test('should write Set<dynamic> value successfully', () async {
            const key = 'set_dynamic_key';
            final value = {1, 'string', true, 3.14};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test(
            'should write complex Set<dynamic> with nested structures successfully',
            () async {
              const key = 'complex_set_dynamic_key';
              final value = {
                1,
                'string',
                [1, 2, 3],
                {'nested': 'map'},
              };
              when(
                () => mockSharedPreferences.setString(key, any()),
              ).thenAnswer((_) async {});

              await storage.write(key: key, value: value);

              verify(
                () => mockSharedPreferences.setString(
                  key,
                  jsonEncode(value.toList()),
                ),
              ).called(1);
            },
          );
        });

        group('Set edge cases', () {
          test('should write Set with duplicate values correctly', () async {
            const key = 'duplicate_set_key';
            // Set автоматически убирает дубликаты при создании
            final value = {'item1', 'item2', 'item1', 'item3', 'item2'};
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: value);

            // Проверяем что сохранилось без дубликатов
            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(value.toList()),
              ),
            ).called(1);
          });

          test(
            'should write Set with null values in Set<dynamic> successfully',
            () async {
              const key = 'null_values_set_key';
              final value = {1, null, 'string', null};
              when(
                () => mockSharedPreferences.setString(key, any()),
              ).thenAnswer((_) async {});

              await storage.write(key: key, value: value);

              verify(
                () => mockSharedPreferences.setString(
                  key,
                  jsonEncode(value.toList()),
                ),
              ).called(1);
            },
          );

          test('should write very large Set successfully', () async {
            const key = 'large_set_key';
            final largeSet = List.generate(
              1000,
              (index) => 'item$index',
            ).toSet();
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            await storage.write(key: key, value: largeSet);

            verify(
              () => mockSharedPreferences.setString(
                key,
                jsonEncode(largeSet.toList()),
              ),
            ).called(1);
          });

          test(
            'should write Set with special characters successfully',
            () async {
              const key = 'special_chars_set_key';
              const value = {'🚀', '🎯', '✅', '❌', '🔥'};
              when(
                () => mockSharedPreferences.setString(key, any()),
              ).thenAnswer((_) async {});

              await storage.write(key: key, value: value);

              verify(
                () => mockSharedPreferences.setString(
                  key,
                  jsonEncode(value.toList()),
                ),
              ).called(1);
            },
          );
        });

        group('Set error handling', () {
          test('should throw StorageException when setString fails', () async {
            const key = 'failing_write_set_key';
            const value = {'item1', 'item2'};
            final exception = Exception('SetString failed');
            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenThrow(exception);

            await expectLater(
              () => storage.write(key: key, value: value),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error,
                  'error',
                  equals(exception),
                ),
              ),
            );
          });

          test(
            'should throw StorageException when JSON encoding fails',
            () async {
              const key = 'circular_set_key';
              // Создаем объект с циклической ссылкой
              final circularMap = <String, dynamic>{};
              circularMap['self'] = circularMap;
              final circularSet = {circularMap};

              expect(
                () => storage.write(key: key, value: circularSet),
                throwsA(isA<StorageException>()),
              );
            },
          );
        });
      });

      group('JSON serializable objects', () {
        test(
          'should throw UnsupportedError for non-serializable object',
          () async {
            const key = 'custom_key';
            final value = Object();

            expect(
              () => storage.write(key: key, value: value),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error.toString(),
                  'error message',
                  contains('Cannot serialize value of type Object'),
                ),
              ),
            );
          },
        );
        test('should throw UnsupportedError for custom class', () async {
          const key = 'user_key';
          const user = CustomUser(id: 1, name: 'John');

          expect(
            () => storage.write(key: key, value: user),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(),
                'error message',
                contains('Cannot serialize value of type CustomUser'),
              ),
            ),
          );
        });
        test(
          'should throw UnsupportedError for JSON serializable object',
          () async {
            const key = 'json_user_key';
            const user = JsonSerializableUser(
              id: 1,
              name: 'John Doe',
              email: 'john@example.com',
            );

            expect(
              () => storage.write(key: key, value: user),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error.toString(),
                  'error message',
                  contains(
                    'Cannot serialize value of type JsonSerializableUser',
                  ),
                ),
              ),
            );
          },
        );

        test(
          'should write JSON serializable object as Map successfully',
          () async {
            const key = 'user_map_key';
            const user = JsonSerializableUser(
              id: 1,
              name: 'John Doe',
              email: 'john@example.com',
            );
            final userMap = user.toJson();

            when(
              () => mockSharedPreferences.setString(key, any()),
            ).thenAnswer((_) async {});

            // Вместо передачи объекта, передаем его toJson()
            await storage.write(key: key, value: userMap);

            verify(
              () => mockSharedPreferences.setString(key, jsonEncode(userMap)),
            ).called(1);
          },
        );

        test(
          'should throw UnsupportedError for complex nested object with toJson',
          () async {
            const key = 'complex_key';
            const complexUser = JsonSerializableUser(
              id: 1,
              name: 'John',
              email: 'john@example.com',
            );

            expect(
              () => storage.write(key: key, value: complexUser),
              throwsA(
                isA<StorageException>().having(
                  (e) => e.error.toString(),
                  'error message',
                  contains(
                    'Cannot serialize value of type JsonSerializableUser',
                  ),
                ),
              ),
            );
          },
        );

        test('should handle object with failing toJson method', () async {
          const key = 'failing_json_key';
          final failingObject = FailingJsonUser();

          expect(
            () => storage.write(key: key, value: failingObject),
            throwsA(
              isA<StorageException>().having(
                (e) => e.error.toString(),
                'error message',
                contains('Cannot serialize value of type FailingJsonUser'),
              ),
            ),
          );
        });
      });

      test('should throw StorageException when write fails', () async {
        const key = 'test_key';
        const value = 'test_value';
        final exception = Exception('Write failed');
        when(
          () => mockSharedPreferences.setString(key, value),
        ).thenThrow(exception);

        expect(
          () => storage.write(key: key, value: value),
          throwsA(
            isA<StorageException>().having(
              (e) => e.error,
              'error',
              equals(exception),
            ),
          ),
        );
      });
    });
    {{/include_write}}
  });
}




