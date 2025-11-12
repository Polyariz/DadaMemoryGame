import 'package:firebase_database/firebase_database.dart';
import '../models/leaderboard_entry.dart';
import '../models/user_model.dart';
import '../utils/card_utils.dart';

/// Сервис для работы с Firebase Realtime Database
class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Сохранение результата в таблицу лидеров
  Future<void> saveScore({
    required UserModel user,
    required int score,
  }) async {
    try {
      final entry = LeaderboardEntry(
        name: user.name,
        score: score,
        id: user.id,
        date: CardUtils.getFormattedDate(),
      );

      await _database.child('leadership').child(user.id).set(entry.toMap());
    } catch (e) {
      print('Ошибка при сохранении результата: $e');
      rethrow;
    }
  }

  /// Обновление результата если новый счет лучше
  Future<void> updateScoreIfBetter({
    required UserModel user,
    required int newScore,
  }) async {
    try {
      final snapshot = await _database.child('leadership').child(user.id).get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final oldScore = data['score'] as int? ?? 0;

        if (newScore > oldScore) {
          final entry = LeaderboardEntry(
            name: user.name,
            score: newScore,
            id: user.id,
            date: CardUtils.getFormattedDate(),
          );

          await _database.child('leadership').child(user.id).set(entry.toMap());
        }
      }
    } catch (e) {
      print('Ошибка при обновлении результата: $e');
      rethrow;
    }
  }

  /// Получение таблицы лидеров (топ 10)
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final snapshot = await _database.child('leadership').get();

      if (!snapshot.exists) {
        return [];
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final List<LeaderboardEntry> entries = [];

      data.forEach((key, value) {
        final entryData = Map<String, dynamic>.from(value as Map);
        entries.add(LeaderboardEntry.fromMap(entryData));
      });

      // Сортировка по убыванию счета
      entries.sort((a, b) => b.score.compareTo(a.score));

      // Возвращаем топ 10
      return entries.take(10).toList();
    } catch (e) {
      print('Ошибка при получении таблицы лидеров: $e');
      return [];
    }
  }

  /// Прослушивание изменений в таблице лидеров
  Stream<List<LeaderboardEntry>> watchLeaderboard() {
    return _database.child('leadership').onValue.map((event) {
      if (!event.snapshot.exists) {
        return <LeaderboardEntry>[];
      }

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<LeaderboardEntry> entries = [];

      data.forEach((key, value) {
        final entryData = Map<String, dynamic>.from(value as Map);
        entries.add(LeaderboardEntry.fromMap(entryData));
      });

      // Сортировка по убыванию счета
      entries.sort((a, b) => b.score.compareTo(a.score));

      // Возвращаем топ 10
      return entries.take(10).toList();
    });
  }
}
