import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/game_provider.dart';
import '../models/user_model.dart';
import '../widgets/game_card.dart';
import '../widgets/login_dialog.dart';
import '../widgets/result_dialog.dart';

/// Главный экран игры
class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  UserModel? _user;
  bool _isOpen = true;
  bool _isFirstGame = true;

  @override
  void initState() {
    super.initState();
    // Показываем диалог входа при первом запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoginDialog();
    });
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoginDialog(
        onUserCreated: (user) {
          setState(() {
            _user = user;
          });
        },
      ),
    );
  }

  void _showResultDialog(int score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        user: _user!,
        score: score,
        isFirstGame: _isFirstGame,
        onPlayAgain: _handleReloadGame,
      ),
    );

    if (_isFirstGame) {
      setState(() {
        _isFirstGame = false;
      });
    }
  }

  void _handleCardClick(GameProvider gameProvider, String name, int id) {
    if (!_isOpen) return;

    final selectedBefore = gameProvider.selected;
    gameProvider.selectCard(name, id);

    if (selectedBefore.isNotEmpty) {
      setState(() {
        _isOpen = false;
      });

      Future.delayed(const Duration(milliseconds: 1000), () {
        gameProvider.compareCards(name, id);
        setState(() {
          _isOpen = true;
        });

        // Проверяем завершение игры
        if (gameProvider.isGameFinished) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showResultDialog(gameProvider.point);
          });
        }
      });
    }
  }

  void _handleReloadGame() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.closeAllCards();

    setState(() {
      _isOpen = false;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      gameProvider.reloadGame();
      setState(() {
        _isOpen = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6CEFF).withOpacity(0.7),
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  children: [
                    if (_user != null)
                      TextSpan(text: 'Привет ${_user!.name}, д')
                    else
                      const TextSpan(text: 'Д'),
                    const TextSpan(text: 'обро пожаловать в '),
                    const TextSpan(
                      text: 'Dada',
                      style: TextStyle(color: Color(0xFFBA68C8)),
                    ),
                    const TextSpan(text: ' Memory Game'),
                  ],
                ),
              ),
            ),

            // Панель счета
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Текущий счет
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: 'Ваш счет: '),
                            TextSpan(
                              text: '${gameProvider.point}',
                              style: const TextStyle(
                                color: Color(0xFFBA68C8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Правила
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          children: [
                            TextSpan(text: 'Начальный счет 200. Каждое совпадение дает '),
                            TextSpan(
                              text: '50',
                              style: TextStyle(
                                color: Color(0xFF00C853),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' очков, каждая ошибка забирает '),
                            TextSpan(
                              text: '10',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' очков.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Кнопка перезагрузки
                      ElevatedButton.icon(
                        onPressed: _handleReloadGame,
                        icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
                        label: const Text('Перезагрузить игру'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFEB3B),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Сетка карт
            Expanded(
              child: Consumer<GameProvider>(
                builder: (context, gameProvider, child) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 600;
                      final cardHeight = isSmallScreen ? 55.0 : 90.0;

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: constraints.maxWidth / (cardHeight * 6),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: gameProvider.cards.length,
                        itemBuilder: (context, index) {
                          final card = gameProvider.cards[index];
                          final canClick = gameProvider.totalSelect < 2 &&
                              _isOpen &&
                              index != gameProvider.selectedId;

                          return GameCard(
                            cardName: card.name,
                            isOpen: card.isOpen,
                            isFind: card.isFind,
                            onTap: () {
                              if (card.isOpen && !card.isFind && _isOpen) {
                                // Закрываем уже открытую карту
                                gameProvider.closeCard(index);
                              } else if (canClick && !card.isFind) {
                                // Открываем новую карту
                                _handleCardClick(gameProvider, card.name, index);
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Футер
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Designed & Built by Suleyman Dadashov\nПортировано на Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
