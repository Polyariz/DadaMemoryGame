/// Модель пользователя
class UserModel {
  final String name; // Имя пользователя
  final String id; // Уникальный ID

  UserModel({
    required this.name,
    required this.id,
  });

  /// Конвертация в Map для Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  /// Создание из Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, id: $id)';
  }
}
