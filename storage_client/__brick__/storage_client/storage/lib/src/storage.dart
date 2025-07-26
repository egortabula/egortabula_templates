import 'package:equatable/equatable.dart';

/// {@template storage_exception}
/// Exception thrown if a storage operation fails.
/// {@endtemplate}
class StorageException extends Equatable implements Exception {
  /// {@macro storage_exception}
  const StorageException(this.error);

  /// Error thrown during the storage operation.
  final Object error;

  @override
  List<Object?> get props => [error];

  @override
  String toString() {
    return 'StorageException: $error';
  }
}

/// A Dart Storage Client Interface
abstract interface class Storage {

  {{#include_read}}
  /// Returns value for the provided [key].
  /// Read returns `null` if no value is found for the given [key].
  /// * Throws a [StorageException] if the read fails.
  Future<T?> read<T>({required String key});
  {{/include_read}}

  {{#include_write}}
  /// Writes the provided [key], [value] pair asynchronously.
  /// * Throws a [StorageException] if the write fails.
  Future<void> write({required String key, required dynamic value});
  {{/include_write}}
  
  {{#include_delete}}
  /// Removes the value for the provided [key] asynchronously.
  /// * Throws a [StorageException] if the delete fails.
  Future<void> delete({required String key});
  {{/include_delete}}

  {{#include_clear}}
  /// Removes all key, value pairs asynchronously.
  /// * Throws a [StorageException] if the delete fails.
  Future<void> clear();
  {{/include_clear}}

  {{#include_containsKey}}
  /// Check if [key] exists
  Future<bool> containsKey(String key);
  {{/include_containsKey}}

}
