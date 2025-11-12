/// Модель записи в таблице лидеров
class LeaderboardEntry {
  final String name; // Имя игрока
  final int score; // Очки
  final String id; // ID игрока
  final String date; // Дата и время

  LeaderboardEntry({
    required this.name,
    required this.score,
    required this.id,
    required this.date,
  });

  /// Конвертация в Map для Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
      'id': id,
      'date': date,
    };
  }

  /// Создание из Map
  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      name: map['name'] ?? '',
      score: map['score'] ?? 0,
      id: map['id'] ?? '',
      date: map['date'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LeaderboardEntry(name: $name, score: $score, id: $id, date: $date)';
  }
}
