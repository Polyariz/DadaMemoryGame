import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/leaderboard_entry.dart';
import '../services/firebase_service.dart';

/// Диалог результатов игры с таблицей лидеров
class ResultDialog extends StatefulWidget {
  final UserModel user;
  final int score;
  final VoidCallback onPlayAgain;
  final bool isFirstGame;

  const ResultDialog({
    Key? key,
    required this.user,
    required this.score,
    required this.onPlayAgain,
    required this.isFirstGame,
  }) : super(key: key);

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  final FirebaseService _firebaseService = FirebaseService();
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLeaderboard();
  }

  Future<void> _initializeLeaderboard() async {
    try {
      if (widget.isFirstGame) {
        // Первая игра - сохраняем результат
        await _firebaseService.saveScore(
          user: widget.user,
          score: widget.score,
        );
      } else {
        // Не первая игра - обновляем если результат лучше
        await _firebaseService.updateScoreIfBetter(
          user: widget.user,
          newScore: widget.score,
        );
      }

      // Получаем таблицу лидеров
      final leaderboard = await _firebaseService.getLeaderboard();
      setState(() {
        _leaderboard = leaderboard;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке таблицы лидеров: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePlayAgain() {
    Navigator.of(context).pop();
    widget.onPlayAgain();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: [
                  const TextSpan(text: 'Поздравляем '),
                  TextSpan(
                    text: widget.user.name,
                    style: const TextStyle(color: Color(0xFFBA68C8)),
                  ),
                  const TextSpan(text: ', вы завершили игру!'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Таблица лидеров
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBA68C8)),
                ),
                child: Column(
                  children: [
                    // Заголовок таблицы
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFBA68C8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Таблица лидеров',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Заголовки колонок
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Имя',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Очки',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Список лидеров
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: _leaderboard.length,
                              itemBuilder: (context, index) {
                                final entry = _leaderboard[index];
                                final isCurrentUser = entry.id == widget.user.id;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? const Color(0xFFE1BEE7)
                                        : Colors.transparent,
                                    border: Border(
                                      top: BorderSide(
                                        color: const Color(0xFFBA68C8).withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Место
                                      Text(
                                        '${index + 1}. ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Имя
                                      Expanded(
                                        child: Text(
                                          entry.name,
                                          style: TextStyle(
                                            fontWeight: isCurrentUser
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      // Очки
                                      Text(
                                        '${entry.score}',
                                        style: TextStyle(
                                          fontWeight: isCurrentUser
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // Результат текущего пользователя
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBA68C8),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.score}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Кнопка "Играть снова"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handlePlayAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA68C8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Играть снова',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
