import 'dart:convert';

import 'package:notifications_client/notifications_client.dart';

/// Extension for converting AppMetrica notification payload strings
/// to [PushNotification] objects.
///
/// AppMetrica SDK returns notification data as a JSON string, which needs
/// to be parsed and processed to extract title, body, and custom data.
extension PushNotificationMapper on String? {
  /// Converts a JSON string from AppMetrica SDK to a [PushNotification].
  ///
  /// This method handles the parsing of AppMetrica's string-based notification
  /// payload and extracts the notification components according to the
  /// following logic:
  ///
  /// 1. **JSON Parsing**: Attempts to parse the string as JSON
  /// 2. **Title/Body Extraction**: If `title` and `body` fields exist in the
  ///    JSON, they are extracted and assigned to the notification
  /// 3. **Data Cleaning**: The `title` and `body` fields are removed from the
  ///    data payload to avoid duplication. If no fields remain after cleaning,
  ///    the original JSON data is preserved.
  /// 4. **Error Handling**: Throws detailed exceptions with guidance for
  ///    troubleshooting AppMetrica configuration issues
  ///
  /// **Example usage:**
  /// ```dart
  /// // AppMetrica payload with title and body
  /// final payload1 = '{"title": "New Message", "body": "Hello!",
  ///     "messageId": "123"}';
  /// final notification1 = payload1.toPushNotification();
  /// // Result: title="New Message", body="Hello!", data={"messageId": "123"}
  ///
  /// // AppMetrica payload without title/body
  /// final payload2 = '{"messageId": "456", "senderId": "user789"}';
  /// final notification2 = payload2.toPushNotification();
  /// // Result: title=null, body=null,
  /// //         data={"messageId": "456", "senderId": "user789"}
  /// ```
  ///
  /// **Throws:**
  /// - [FormatException]: When JSON parsing fails or the payload format is
  ///   invalid. The error message includes guidance for checking AppMetrica
  ///   console configuration.
  /// - [Exception]: For any other unexpected errors during processing.
  ///
  /// **Returns:**
  /// A [PushNotification] with properly extracted title, body, and cleaned
  /// data payload. The `receivedAt` field is automatically set to the current
  /// timestamp.
  PushNotification  toPushNotification() {
    try {
      if (this == null || this!.isEmpty) {
        return PushNotification.empty();
      }
      // Парсим JSON строку в Map
      final dynamic decodedData = json.decode(this!);

      // Проверяем, что результат парсинга - это Map
      if (decodedData is! Map<String, dynamic>) {
        throw FormatException(
          'AppMetrica notification payload parsing failed: '
          'Expected JSON object but got ${decodedData.runtimeType}. '
          'Please check your push notification data encoding in '
          'AppMetrica console or server.',
        );
      }

      final jsonData = decodedData;

      // Извлекаем title и body если они есть
      final title = jsonData['title'] as String?;
      final body = jsonData['body'] as String?;

      // Создаем копию данных для очистки
      final cleanedData = Map<String, dynamic>.from(jsonData);

      // Если title и body присутствуют, удаляем их из данных
      if (title != null) {
        cleanedData.remove('title');
      }
      if (body != null) {
        cleanedData.remove('body');
      }

      return PushNotification(
        title: title,
        body: body,
        data: cleanedData.isNotEmpty ? cleanedData : jsonData,
        receivedAt: DateTime.now(),
      );
    } on FormatException catch (e) {
      // Если парсинг JSON не удался, перебрасываем ошибку с подробным описанием
      throw FormatException(
        'AppMetrica notification payload parsing failed: '
        'Invalid JSON format in notification data. '
        'Please verify your push notification data encoding in '
        'AppMetrica console or server. '
        'Original error: ${e.message}',
      );
    } catch (e) {
      // Обрабатываем любые другие неожиданные ошибки
      throw Exception(
        'AppMetrica notification processing failed: '
        'Unexpected error occurred while parsing notification payload. '
        'Please check your notification data format. '
        'Error: $e',
      );
    }
  }
}
