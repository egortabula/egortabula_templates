/// {@template push_provider}
/// Enumeration representing different push notification service providers.
///
/// This enum defines the supported push notification services that can be used
/// to deliver notifications to mobile devices. Each provider has its own
/// specific implementation and requirements.
/// {@endtemplate}
enum PushProvider {
  /// Firebase Cloud Messaging (FCM) - Google's cross-platform messaging solution.
  ///
  /// FCM is a free service that allows you to send messages and notifications
  /// to users across platforms like Android, iOS, and web applications.
  firebase('firebase'),

  /// Apple Push Notification Service (APNs) - Apple's push notification service.
  ///
  /// APNs is the centerpiece of the remote notifications feature. It is a robust,
  /// secure, and highly efficient service for app developers to propagate
  /// information to iOS, tvOS, watchOS, and macOS devices.
  apns('apns'),

  /// Huawei Mobile Services (HMS) Push Kit - Huawei's push notification service.
  ///
  /// HMS Push Kit is a messaging service provided by Huawei for developers.
  /// It establishes a messaging channel from the cloud to devices, allowing
  /// you to send messages to your apps on users' devices in real time.
  hms('hms'),

  /// RuStore Push Service - Russian app store push notification service.
  ///
  /// RuStore Push is the push notification service for applications
  /// distributed through the RuStore marketplace, providing messaging
  /// capabilities for Russian market applications.
  rustore('rustore');

  /// {@macro push_provider}
  const PushProvider(this.value);

  /// The string value associated with the push provider.
  ///
  /// This value is used for serialization and identification purposes
  /// when working with external APIs or storing provider information.
  final String value;
}

/// {@template push_token}
/// Represents a push notification token for a specific device and provider.
///
/// A push token is a unique identifier that allows push notification services
/// to deliver messages to a specific app installation on a device. Each token
/// is associated with a specific push notification provider and contains
/// metadata about when it was created.
///
/// Example usage:
/// ```dart
/// final token = PushToken(
///   value: 'abc123def456...',
///   provider: PushProvider.firebase,
///   createdAt: DateTime.now(),
/// );
///
/// // Convert to map for storage or API calls
/// final tokenData = token.toMap();
/// ```
/// {@endtemplate}
class PushToken {
  /// {@macro push_token}
  ///
  /// Creates a new [PushToken] instance with the specified parameters.
  ///
  /// All parameters are required:
  /// - [value]: The actual push token string from the provider
  /// - [provider]: The push notification service provider
  /// - [createdAt]: When this token was generated/received
  const PushToken({
    required this.value,
    required this.provider,
    required this.createdAt,
  });

  /// Creates a [PushToken] for Firebase Cloud Messaging (FCM).
  factory PushToken.firebase(String token) {
    return PushToken(
      value: token,
      provider: PushProvider.firebase,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a [PushToken] for Apple Push Notification Service (APNs).
  factory PushToken.apns(String token) {
    return PushToken(
      value: token,
      provider: PushProvider.apns,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a [PushToken] for Huawei Mobile Services (HMS).
  factory PushToken.hms(String token) {
    return PushToken(
      value: token,
      provider: PushProvider.hms,
      createdAt: DateTime.now(),
    );
  }

  /// Creates a [PushToken] for RuStore Push Service.
  factory PushToken.rustore(String token) {
    return PushToken(
      value: token,
      provider: PushProvider.rustore,
      createdAt: DateTime.now(),
    );
  }

  /// The push token value.
  ///
  /// This is the unique identifier string provided by the push notification
  /// service (FCM, APNs, HMS, etc.) that allows the service to route
  /// notifications to the specific device and app installation.
  ///
  /// The format and length of this value varies by provider:
  /// - FCM tokens are typically 152+ characters
  /// - APNs tokens are 64 hexadecimal characters
  /// - HMS tokens vary in length
  /// - RuStore tokens follow their specific format
  final String value;

  /// The provider of the push token.
  ///
  /// This indicates which push notification service generated this token
  /// and should be used when sending notifications. The provider determines
  /// the API endpoints, authentication methods, and message formats to use.
  ///
  /// See [PushProvider] for available options.
  final PushProvider provider;

  /// The date and time when the push token was created or received.
  ///
  /// This timestamp is useful for:
  /// - Token freshness validation (tokens can expire)
  /// - Debugging token-related issues
  /// - Analytics and monitoring
  /// - Determining when to refresh tokens
  final DateTime createdAt;

  /// Converts the [PushToken] to a [Map] representation.
  ///
  /// This method serializes the push token data into a map format
  /// that can be easily stored in databases, sent over APIs, or
  /// converted to JSON.
  ///
  /// Returns a map with the following keys:
  /// - `'token'`: The token value as a string
  /// - `'provider'`: The provider name as a string
  /// - `'createdAt'`: The creation timestamp in ISO 8601 format
  ///
  /// Example output:
  /// ```dart
  /// {
  ///   'token': 'abc123def456...',
  ///   'provider': 'firebase',
  ///   'createdAt': '2024-01-15T10:30:00.000Z'
  /// }
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'token': value,
      'provider': provider.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
