// Добавляем JSON-serializable класс в конец файла после других классов
import 'package:flutter/foundation.dart';

@immutable
class JsonSerializableUser {
  const JsonSerializableUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory JsonSerializableUser.fromJson(Map<String, dynamic> json) =>
      JsonSerializableUser(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
      );

  final int id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsonSerializableUser &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}

// Добавляем класс с проблемным toJson
class FailingJsonUser {
  Map<String, dynamic> toJson() {
    throw Exception('toJson failed');
  }
}
