import 'package:equatable/equatable.dart';

/// {@template push_notification}
/// Represents a push notification message received by the application.
///
/// A push notification contains the basic information sent from a push
/// notification service to display to the user or handle programmatically.
/// This class encapsulates the common fields found in most push notification
/// implementations across different platforms and providers.
///
/// The notification can contain:
/// - Visual elements (title, body) for user display
/// - Custom data payload for application-specific handling
/// - Metadata about when the notification was received
///
/// Example usage:
/// ```dart
/// final notification = PushNotification(
///   title: 'New Message',
///   body: 'You have received a new message from John',
///   data: {
///     'messageId': '12345',
///     'senderId': 'user_67890',
///     'chatId': 'chat_abc123',
///   },
///   receivedAt: DateTime.now(),
/// );
///
/// // Handle the notification
/// if (notification.data?['messageId'] != null) {
///   // Navigate to specific message
/// }
/// ```
/// {@endtemplate}
class PushNotification extends Equatable {
  /// {@macro push_notification}
  ///
  /// Creates a new [PushNotification] instance.
  ///
  /// All parameters are optional, allowing for flexible notification types:
  /// - [title]: The notification title displayed to the user
  /// - [body]: The notification body/message content
  /// - [data]: Custom data payload for application handling
  /// - [receivedAt]: Timestamp when the notification was received
  const PushNotification({
    this.title,
    this.body,
    this.data,
    this.receivedAt,
  });

  /// Creates an empty [PushNotification] with the current timestamp.
  factory PushNotification.empty() {
    return PushNotification(receivedAt: DateTime.now());
  }

  /// The title of the push notification.
  ///
  /// This is typically displayed prominently in the system notification UI
  /// and serves as the main heading for the notification. The title should
  /// be concise and descriptive of the notification's purpose.
  ///
  /// Can be `null` in several cases:
  /// - Data-only notifications that don't require visual display to the user
  /// - When using SDKs that don't return title/body parameters (e.g., AppMetrica)
  /// - When the push notification service doesn't provide this field
  ///
  /// **Note**: If your SDK doesn't provide title/body fields but you need them,
  /// consider including this information in the [data] payload instead:
  /// ```dart
  /// // When SDK only provides payload
  /// final notification = PushNotification(
  ///   title: null, // SDK doesn't provide
  ///   body: null,  // SDK doesn't provide
  ///   data: {
  ///     'title': 'New Message',      // Custom title in payload
  ///     'body': 'You have a message', // Custom body in payload
  ///     'messageId': '12345',
  ///   },
  /// );
  /// ```
  ///
  /// Example values:
  /// - "New Message"
  /// - "Order Update"
  /// - "Breaking News"
  /// - "Friend Request"
  final String? title;

  /// The body text of the push notification.
  ///
  /// This contains the main content/message of the notification that provides
  /// detailed information to the user. The body text is usually displayed
  /// below the title in the system notification UI.
  ///
  /// Can be `null` in several cases:
  /// - Notifications that only need a title or are data-only notifications
  /// - When using SDKs that don't return title/body parameters (e.g., AppMetrica)
  /// - When the push notification service doesn't provide this field
  ///
  /// **Note**: If your SDK doesn't provide title/body fields but you need them,
  /// consider including this information in the [data] payload instead:
  /// ```dart
  /// // Extract title/body from payload when SDK doesn't provide them
  /// final title = notification.title ??
  ///     notification.data?['title'] as String?;
  /// final body = notification.body ??
  ///     notification.data?['body'] as String?;
  /// ```
  ///
  /// Example values:
  /// - "You have received a new message from John Smith"
  /// - "Your order #12345 has been shipped and is on the way"
  /// - "Breaking: Important news update available"
  /// - "Sarah wants to connect with you"
  final String? body;

  /// Custom data payload attached to the push notification.
  ///
  /// This field contains application-specific data that can be used to
  /// handle the notification programmatically. The data is typically used
  /// for navigation, state updates, or other business logic when the user
  /// interacts with the notification.
  ///
  /// Common use cases:
  /// - Navigation parameters (screen routes, IDs)
  /// - Business entity identifiers (user IDs, order numbers)
  /// - Action triggers (refresh flags, update indicators)
  /// - Metadata (source, category, priority)
  ///
  /// Can be `null` for simple display-only notifications.
  ///
  /// Example structure:
  /// ```dart
  /// {
  ///   'type': 'message',
  ///   'messageId': '12345',
  ///   'senderId': 'user_67890',
  ///   'chatId': 'chat_abc123',
  ///   'action': 'open_chat'
  /// }
  /// ```
  final Map<String, dynamic>? data;

  /// The timestamp when the push notification was received by the application.
  ///
  /// This field captures when the notification was processed by the local
  /// application, which may differ from when it was sent by the server.
  /// Useful for:
  ///
  /// - Sorting notifications chronologically
  /// - Implementing notification expiration logic
  /// - Analytics and debugging timing issues
  /// - Displaying "time ago" information to users
  ///
  /// Can be `null` if the timestamp is not available or not relevant
  /// for the specific notification type.
  ///
  /// Note: This represents local receipt time, not the server send time.
  final DateTime? receivedAt;

  /// Checks if the [PushNotification] is empty.
  bool get isEmpty => this == PushNotification.empty();

  /// List of properties used for equality comparison.
  ///
  /// This getter defines which fields are used when comparing two
  /// [PushNotification] instances for equality. Two notifications are
  /// considered equal if all their properties match.
  ///
  /// Used by the [Equatable] mixin to implement `==` operator and `hashCode`.
  @override
  List<Object?> get props => [
    title,
    body,
    data,
    receivedAt,
  ];

  /// String representation of the [PushNotification].
  ///
  /// Returns a formatted string containing all the notification properties,
  /// useful for debugging, logging, and development purposes.
  ///
  /// Example output:
  /// ```dart
  /// PushNotification(title: New Message, body: You have a new message,
  /// data: {messageId: 123, senderId: user_456},
  /// receivedAt: 2024-01-15 10:30:00.000)
  /// ```
  @override
  String toString() {
    return 'PushNotification'
        '(title: $title, body: $body, data: $data, receivedAt: $receivedAt)';
  }
}
