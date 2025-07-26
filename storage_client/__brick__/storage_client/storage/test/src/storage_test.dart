// This package is just an abstraction.
// See shared_prefs_async_storage for a concrete implementation for example

import 'package:storage/storage.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';

// Storage is exported and can be implemented
class FakeStorage extends Fake implements Storage {}

void main() {
  test('Storage can be implemented', () {
    expect(FakeStorage.new, returnsNormally);
  });

  test('exports StorageException', () {
    expect(() => const StorageException('oops'), returnsNormally);
  });
}
