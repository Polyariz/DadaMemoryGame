import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

/// Виджет карты игры с анимацией переворота
class GameCard extends StatelessWidget {
  final String cardName;
  final bool isOpen;
  final bool isFind;
  final VoidCallback onTap;

  const GameCard({
    Key? key,
    required this.cardName,
    required this.isOpen,
    required this.isFind,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(isOpen) != child!.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt *= isUnder ? -1.0 : 1.0;
              final value = isUnder ? math.min(rotateAnim.value, math.pi / 2) : rotateAnim.value;
              return Transform(
                transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: isOpen
            ? _buildOpenCard()
            : _buildClosedCard(),
      ),
    );
  }

  /// Закрытая карта (с вопросительным знаком)
  Widget _buildClosedCard() {
    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.question,
          color: const Color(0xFFBA68C8),
          size: 30,
        ),
      ),
    );
  }

  /// Открытая карта (с изображением)
  Widget _buildOpenCard() {
    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        color: isFind ? const Color(0xFF00C853) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/$cardName.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Если изображение не найдено, показываем placeholder
            return const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 30,
            );
          },
        ),
      ),
    );
  }
}
