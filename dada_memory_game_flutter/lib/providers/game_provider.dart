import 'package:flutter/foundation.dart';
import '../models/card_model.dart';
import '../models/user_model.dart';
import '../utils/card_utils.dart';

/// Провайдер управления состоянием игры (аналог Redux CardSlice)
class GameProvider with ChangeNotifier {
  // Состояние игры
  List<CardModel> _cards = [];
  String _selected = '';
  int _selectedId = 0;
  int _totalSelect = 0;
  int _point = 200;
  int _found = 0;

  // Геттеры
  List<CardModel> get cards => _cards;
  String get selected => _selected;
  int get selectedId => _selectedId;
  int get totalSelect => _totalSelect;
  int get point => _point;
  int get found => _found;

  /// Инициализация игры
  GameProvider() {
    _cards = CardUtils.createCardList();
  }

  /// Выбор карты (аналог select action)
  void selectCard(String name, int id) {
    _cards[id].isOpen = true;

    if (_selected.isEmpty) {
      // Это первая выбранная карта
      _selected = name;
      _selectedId = id;
      _totalSelect = 1;
    } else {
      // Это вторая выбранная карта
      _totalSelect = 2;
    }

    notifyListeners();
  }

  /// Сравнение двух карт (аналог compare action)
  void compareCards(String name, int id) {
    if (_selected == name) {
      // Карты совпадают
      _cards[_selectedId].isFind = true;
      _cards[id].isFind = true;
      _point += 50;
      _found += 1;
    } else {
      // Карты не совпадают
      _cards[_selectedId].isOpen = false;
      _cards[id].isOpen = false;
      if (_point > 0) {
        _point -= 10;
      }
    }

    // Сброс выбора
    _selected = '';
    _selectedId = 0;
    _totalSelect = 0;

    notifyListeners();
  }

  /// Закрытие открытой карты (аналог close action)
  void closeCard(int id) {
    _cards[id].isOpen = false;
    _selected = '';
    _selectedId = 0;
    if (_point > 0) {
      _point -= 10;
    }

    notifyListeners();
  }

  /// Закрытие всех карт (аналог closeAll action)
  void closeAllCards() {
    for (var card in _cards) {
      card.isOpen = false;
      card.isFind = false;
    }

    notifyListeners();
  }

  /// Перезагрузка игры (аналог reload action)
  void reloadGame() {
    _selectedId = 0;
    _selected = '';
    _cards = CardUtils.shuffle([..._cards]);
    _point = 200;
    _found = 0;

    notifyListeners();
  }

  /// Проверка завершения игры
  bool get isGameFinished => _found == 15;
}
