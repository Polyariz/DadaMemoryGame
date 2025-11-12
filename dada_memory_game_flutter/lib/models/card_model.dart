/// Модель карты для игры Memory
class CardModel {
  final String name; // Имя/ID изображения карты
  bool isOpen; // Открыта ли карта
  bool isFind; // Найдена ли пара для этой карты

  CardModel({
    required this.name,
    this.isOpen = false,
    this.isFind = false,
  });

  /// Создание копии карты с измененными параметрами
  CardModel copyWith({
    String? name,
    bool? isOpen,
    bool? isFind,
  }) {
    return CardModel(
      name: name ?? this.name,
      isOpen: isOpen ?? this.isOpen,
      isFind: isFind ?? this.isFind,
    );
  }

  /// Конвертация в Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isOpen': isOpen,
      'isFind': isFind,
    };
  }

  /// Создание из Map
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      name: map['name'] ?? '',
      isOpen: map['isOpen'] ?? false,
      isFind: map['isFind'] ?? false,
    );
  }

  @override
  String toString() {
    return 'CardModel(name: $name, isOpen: $isOpen, isFind: $isFind)';
  }
}
