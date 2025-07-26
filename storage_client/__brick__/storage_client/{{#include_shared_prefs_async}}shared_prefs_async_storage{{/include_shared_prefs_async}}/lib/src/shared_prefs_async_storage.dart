import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

/// {@template shared_prefs_async_storage}
/// Async storage implementation that saves data in device's persistent memory
/// using SharedPreferences.
///
/// This storage client provides type-safe operations for storing and retrieving
/// various data types including primitives, collections, and special objects.
/// All operations are asynchronous and throw [StorageException] on errors.
///
/// ## Features:
/// * Type-safe read/write operations
/// * Automatic JSON serialization for complex types
/// * Native SharedPreferences optimization for primitives
/// * Null-safe operations
/// * Comprehensive error handling
///
/// ## Usage:
/// ```dart
/// final storage = SharedPrefsAsyncStorage();
///
/// // Store data
/// await storage.write(key: 'user_name', value: 'John');
/// await storage.write(key: 'settings', value: {'theme': 'dark'});
///
/// // Read data
/// final name = await storage.read<String>('user_name');
/// final settings = await storage.read<Map<String, dynamic>>('settings');
/// ```
/// {@endtemplate}
class SharedPrefsAsyncStorage implements Storage {
  /// {@macro shared_prefs_async_storage}
  SharedPrefsAsyncStorage({SharedPreferencesAsync? sharedPreferences})
    : _sharedPreferences = sharedPreferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _sharedPreferences;

  /// Supported primitive types for storage operations.
  static const _supportedTypes = {
    'bool',
    'double',
    'int',
    'String',
    'DateTime',
    'Uri',
    'List<String>',
  };

  /// Checks if the provided type is supported for storage operations.
  static bool _isTypeSupported(String typeString) {
    return _supportedTypes.contains(typeString) ||
        typeString.startsWith('List') ||
        typeString.startsWith('Map') ||
        typeString.startsWith('Set');
  }

  {{#include_clear}}
  /// Removes all key, value pairs from storage.
  ///
  /// Throws a [StorageException] if the clear fails.
  @override
  Future<void> clear() async {
    try {
      await _sharedPreferences.clear();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
  {{/include_clear}}

  {{#include_containsKey}}
  @override
  Future<bool> containsKey(String key) async {
    try {
      return await _sharedPreferences.containsKey(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
  {{/include_containsKey}}

  {{#include_delete}}
  @override
  Future<void> delete({required String key}) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
  {{/include_delete}}

 {{#include_read}}
  /// Reads a value from storage by [key].
  ///
  /// Returns the stored value cast to type [T], or `null`
  /// if the key doesn't exist.
  ///
  /// ## Supported Types:
  /// * **Primitives**: `bool`, `double`, `int`, `String`
  /// * **Collections**: `List<String>`, `List`, `Map`, `Set`
  /// * **Special Types**: `DateTime`, `Uri`
  ///
  /// ## Type-Specific Behavior:
  /// * **bool, double, int, String, List<String>**: Uses native
  /// SharedPreferences methods
  /// * **DateTime**: Stored as ISO8601 string, parsed back to DateTime
  /// * **Uri**: Stored as string, parsed back to Uri
  /// * **List, Map**: Stored as JSON string, decoded back to original type
  /// * **Set**: Stored as JSON array, converted back to Set
  ///
  /// ## Examples:
  /// ```dart
  /// // Primitives
  /// final name = await storage.read<String>('user_name'); // 'John'
  /// final age = await storage.read<int>('user_age'); // 25
  /// final isActive = await storage.read<bool>('is_active'); // true
  ///
  /// // Collections
  /// final tags = await storage.read<List<String>>('tags'); // ['flutter', 'dart']
  /// final numbers = await storage.read<List<int>>('numbers'); // [1, 2, 3]
  /// final userData = await storage.read<Map<String, dynamic>>('user'); // {'name': 'John'}
  /// final uniqueIds = await storage.read<Set<String>>('ids'); // {'id1', 'id2'}
  ///
  /// // Special types
  /// final birthday = await storage.read<DateTime>('birthday'); // DateTime object
  /// final website = await storage.read<Uri>('website'); // Uri object
  /// ```
  ///
  /// ## Throws:
  /// * [StorageException] if the type [T] is not supported
  /// * [StorageException] if reading fails or data is corrupted
  @override
  Future<T?> read<T>({required String key}) async {
    try {
      final typeString = T.toString();

      if (!_isTypeSupported(typeString)) {
        throw UnsupportedError(
          'Cannot read value of type $T. '
          'Supported types: bool, double, int, String, List<String>, '
          'List, Map, Set, DateTime, Uri.',
        );
      }

      // Для примитивных типов используем native методы
      if (T == bool) {
        final value = await _sharedPreferences.getBool(key);
        return value as T?;
      } else if (T == double) {
        final value = await _sharedPreferences.getDouble(key);
        return value as T?;
      } else if (T == int) {
        final value = await _sharedPreferences.getInt(key);
        return value as T?;
      } else if (T == String) {
        final value = await _sharedPreferences.getString(key);
        return value as T?;
      } else if (T.toString() == 'List<String>') {
        final value = await _sharedPreferences.getStringList(key);
        return value as T?;
      } else if (T == DateTime) {
        final stringValue = await _sharedPreferences.getString(key);
        final value = stringValue != null ? DateTime.parse(stringValue) : null;
        return value as T?;
      } else if (T == Uri) {
        final stringValue = await _sharedPreferences.getString(key);
        final value = stringValue != null ? Uri.parse(stringValue) : null;
        return value as T?;
      }

      // Для сложных типов через JSON
      final stringValue = await _sharedPreferences.getString(key);
      if (stringValue == null) return null;

      final decodedValue = jsonDecode(stringValue);

      // Для Set конвертируем из List
      if (typeString.startsWith('Set')) {
        if (decodedValue is! List) {
          throw FormatException(
            'Cannot convert ${decodedValue.runtimeType} to Set. Expected List.',
          );
        }

        // Используем Set.from для создания Set с правильными типами
        switch (typeString) {
          case 'Set<String>':
            return Set<String>.from(decodedValue.cast<String>()) as T?;
          case 'Set<int>':
            return Set<int>.from(decodedValue.cast<int>()) as T?;
          case 'Set<double>':
            return Set<double>.from(decodedValue.cast<double>()) as T?;
          case 'Set<bool>':
            return Set<bool>.from(decodedValue.cast<bool>()) as T?;
          default:
            // Для Set<dynamic> и других generic типов
            return Set<dynamic>.from(decodedValue) as T?;
        }
      }

      return decodedValue as T?;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
  {{/include_read}}

  {{#include_write}}
  /// Writes a [value] to storage with the given [key].
  ///
  /// If [value] is `null`, the key will be removed from storage.
  ///
  /// ## Supported Types:
  /// * **Primitives**: `bool`, `double`, `int`, `String`
  /// * **Collections**: `List<String>`, `List`, `Map`, `Set`
  /// * **Special Types**: `DateTime`, `Uri`
  /// * **JSON Serializable**: Objects with `toJson()` method
  ///
  /// ## Type-Specific Behavior:
  /// * **bool, double, int, String, List<String>**: Uses native
  /// SharedPreferences methods
  /// * **DateTime**: Converts to ISO8601 string for storage
  /// * **Uri**: Converts to string for storage
  /// * **List, Map**: Encodes as JSON string
  /// * **Set**: Converts to List, then encodes as JSON
  /// * **Custom Objects**: Must implement `toJson()` method
  /// or be JSON serializable
  ///
  /// ## Examples:
  /// ```dart
  /// // Primitives
  /// await storage.write(key: 'user_name', value: 'John');
  /// await storage.write(key: 'user_age', value: 25);
  /// await storage.write(key: 'is_active', value: true);
  ///
  /// // Collections
  /// await storage.write(key: 'tags', value: ['flutter', 'dart']);
  /// await storage.write(key: 'numbers', value: [1, 2, 3]);
  /// await storage.write(key: 'user', value: {'name': 'John', 'age': 25});
  /// await storage.write(key: 'ids', value: {'id1', 'id2', 'id3'});
  ///
  /// // Special types
  /// await storage.write(key: 'birthday', value: DateTime.now());
  /// await storage.write(key: 'website', value: Uri.parse('https://example.com'));
  ///
  /// // JSON serializable object
  /// await storage.write(key: 'user_model', value: user.toJson());
  ///
  /// // Remove key
  /// await storage.write(key: 'temp_data', value: null);
  /// ```
  ///
  /// ## Throws:
  /// * [StorageException] if the value type is not supported
  /// * [StorageException] if the object is not JSON serializable
  /// * [StorageException] if writing to storage fails
  @override
  Future<void> write({required String key, required dynamic value}) async {
    try {
      // Обработка null
      if (value == null) {
        await _sharedPreferences.remove(key);
        return;
      }

      await switch (value) {
        bool() => _sharedPreferences.setBool(key, value),
        double() => _sharedPreferences.setDouble(key, value),
        int() => _sharedPreferences.setInt(key, value),
        String() => _sharedPreferences.setString(key, value),
        List<String>() => _sharedPreferences.setStringList(key, value),
        // Для остальных списков используем JSON
        List() => _sharedPreferences.setString(key, jsonEncode(value)),
        Map() => _sharedPreferences.setString(key, jsonEncode(value)),
        Set() => _sharedPreferences.setString(key, jsonEncode(value.toList())),
        // Для специальных типов
        DateTime() => _sharedPreferences.setString(
          key,
          value.toIso8601String(),
        ),
        Uri() => _sharedPreferences.setString(key, value.toString()),
        // Для всех остальных пытаемся JSON или toString
        _ => throw UnsupportedError(
          'Cannot serialize value of type ${value.runtimeType}. '
          'Supported types: bool, double, int, String, List<String>, '
          'List, Map, Set, DateTime, Uri.',
        ),
      };
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
  {{/include_write}}
}
