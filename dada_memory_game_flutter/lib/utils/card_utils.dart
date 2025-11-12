import 'dart:math';
import '../models/card_model.dart';

/// Утилиты для работы с картами
class CardUtils {
  /// Список названий всех карт (15 уникальных изображений)
  static const List<String> cardNames = [
    "card1", // tgb1s5de1dc2tgbc5j9yu8j1n
    "card2", // tgb1s5de1dc2tgcbjj9yu8j1n
    "card3", // tgb1s5de1dc2asbc5j9yu8j1n
    "card4", // tgb1s5de1dc2jhunmj9yu8j1n
    "card5", // tgb1s5de1dc2nhyt3j9yu8j1n
    "card6", // tgb1s5de1dc2er5yhj9yu8j1n
    "card7", // tgb1s5de1dc2cd5thj9yu8j1n
    "card8", // tgb1s5de1dc2er3yhj9yu8j1n
    "card9", // tgb1s5de1dc2vg2jbj9yu8j1n
    "card10", // tgb1s5de1dc2liuy5j9yu8j1n
    "card11", // tgb1s5de1dc2xs2fgj9yu8j1n
    "card12", // tgb1s5de1dc2we2fhj9yu8j1n
    "card13", // tgb1s5de1dc2ds1hlj9yu8j1n
    "card14", // tgb1s5de1dc2bfghlj9yu8j1n
    "card15", // tgb1s5de1dc2er2gcj9yu8j1n
  ];

  /// Перемешивание массива (Fisher-Yates shuffle)
  static List<T> shuffle<T>(List<T> array) {
    final random = Random();
    final List<T> shuffled = List.from(array);

    int currentIndex = shuffled.length;

    // Пока есть элементы для перемешивания
    while (currentIndex != 0) {
      // Выбираем случайный элемент
      int randomIndex = random.nextInt(currentIndex);
      currentIndex--;

      // Меняем местами текущий элемент со случайным
      T temp = shuffled[currentIndex];
      shuffled[currentIndex] = shuffled[randomIndex];
      shuffled[randomIndex] = temp;
    }

    return shuffled;
  }

  /// Создание списка карт для игры (30 карт - по 2 каждой)
  static List<CardModel> createCardList() {
    List<CardModel> list = [];

    // Создаем карты из названий
    for (String name in cardNames) {
      list.add(CardModel(name: name));
    }

    // Дублируем список (каждая карта должна быть в двух экземплярах)
    List<CardModel> doubledList = [...list, ...list];

    // Перемешиваем
    return shuffle(doubledList);
  }

  /// Получить дату в формате YYYY-M-D/H:M
  static String getFormattedDate() {
    final DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}/${now.hour}:${now.minute}';
  }
}
