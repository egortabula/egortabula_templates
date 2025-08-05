import 'package:notifications_client/notifications_client.dart';

/// Extension for converting AppMetrica push token data to [PushToken] objects.
///
/// AppMetrica SDK returns push token information as a Map with potentially
/// multiple tokens, but we only process the first one since real-world testing
/// shows that AppMetrica always returns a single token per call.
extension PushTokenMapper on Map<String, dynamic> {
  /// Converts AppMetrica push token data to a [PushToken].
  ///
  /// This method processes the first token from the AppMetrica token data.
  /// In practice, AppMetrica always returns a single token, unlike Firebase
  /// which returns a simple string.
  ///
  /// **Expected format:**
  /// ```dart
  /// {'firebase': 'abc123def456...'}
  /// {'apns': 'deadbeefcafe...'}
  /// {'hms': 'xyz789uvw...'}
  /// {'rustore': 'token123...'}
  /// ```
  ///
  /// **Throws:**
  /// - [FormatException]: When token data is invalid
  ///   or provider is unsupported. Preserves original stack trace
  ///   for debugging.
  ///
  /// **Returns:**
  /// A [PushToken] with the appropriate provider and current timestamp.
  PushToken toPushToken() {
    try {
      if (isEmpty) {
        throw const FormatException(
          'Push token data is empty. Please ensure the AppMetrica Push service '
          'is properly configured.',
        );
      }
      final key = keys.first;
      final value = this[keys.first] as String?;

      if (value == null || value.isEmpty) {
        throw const FormatException(
          'Push token value is null or empty. Please ensure '
          'the AppMetrica Push service is properly configured '
          'and the token is available.',
        );
      }

      switch (key.toLowerCase()) {
        case 'firebase':
          return PushToken.firebase(value);
        case 'apns':
          return PushToken.apns(value);
        case 'hms':
        case 'huawei':
          return PushToken.hms(value);
        case 'rustore':
          return PushToken.rustore(value);
        default:
          throw FormatException(
            'Unknown push token provider: $key. '
            'Supported providers are: firebase, apns, hms, rustore.',
          );
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
