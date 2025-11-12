# API Reference - Справочник классов и методов

## Модели данных (Models)

### CardModel
**Файл**: `lib/models/card_model.dart`

Модель карты для игры.

#### Свойства
```dart
String name        // Имя/ID изображения карты
bool isOpen        // Открыта ли карта в данный момент
bool isFind        // Найдена ли пара для этой карты
```

#### Методы
```dart
CardModel copyWith({String? name, bool? isOpen, bool? isFind})
// Создает копию карты с измененными параметрами

Map<String, dynamic> toMap()
// Конвертирует модель в Map

CardModel.fromMap(Map<String, dynamic> map)
// Создает модель из Map
```

---

### UserModel
**Файл**: `lib/models/user_model.dart`

Модель пользователя.

#### Свойства
```dart
String name        // Имя пользователя
String id          // Уникальный ID (UUID)
```

#### Методы
```dart
Map<String, dynamic> toMap()
// Конвертирует модель в Map для Firebase

UserModel.fromMap(Map<String, dynamic> map)
// Создает модель из Map
```

---

### LeaderboardEntry
**Файл**: `lib/models/leaderboard_entry.dart`

Модель записи в таблице лидеров.

#### Свойства
```dart
String name        // Имя игрока
int score          // Количество очков
String id          // ID игрока
String date        // Дата и время (формат: YYYY-M-D/H:M)
```

#### Методы
```dart
Map<String, dynamic> toMap()
// Конвертирует модель в Map для Firebase

LeaderboardEntry.fromMap(Map<String, dynamic> map)
// Создает модель из Map
```

---

## Провайдер (Provider)

### GameProvider
**Файл**: `lib/providers/game_provider.dart`

Центральный провайдер управления состоянием игры (аналог Redux CardSlice).

#### Приватные свойства
```dart
List<CardModel> _cards = []      // Список из 30 карт
String _selected = ''            // Имя первой выбранной карты
int _selectedId = 0              // ID первой выбранной карты
int _totalSelect = 0             // Количество выбранных карт (0, 1 или 2)
int _point = 200                 // Текущий счет (начальный: 200)
int _found = 0                   // Количество найденных пар (0-15)
```

#### Геттеры
```dart
List<CardModel> get cards        // Получить список карт
String get selected              // Получить имя выбранной карты
int get selectedId               // Получить ID выбранной карты
int get totalSelect              // Получить количество выбранных карт
int get point                    // Получить текущий счет
int get found                    // Получить количество найденных пар
bool get isGameFinished          // Проверка завершения игры (found == 15)
```

#### Методы

##### selectCard(String name, int id)
Выбор карты игроком.
```dart
void selectCard(String name, int id)
```
- Открывает карту
- Если это первая карта - сохраняет её данные
- Если вторая - увеличивает totalSelect до 2
- Вызывает notifyListeners()

##### compareCards(String name, int id)
Сравнение двух выбранных карт.
```dart
void compareCards(String name, int id)
```
- Если карты совпадают:
  - Помечает обе как найденные (isFind = true)
  - Добавляет 50 очков
  - Увеличивает счетчик найденных пар
- Если не совпадают:
  - Закрывает обе карты (isOpen = false)
  - Вычитает 10 очков (минимум 0)
- Сбрасывает выбор
- Вызывает notifyListeners()

##### closeCard(int id)
Закрытие открытой карты при клике на нее.
```dart
void closeCard(int id)
```
- Закрывает указанную карту
- Вычитает 10 очков
- Сбрасывает выбор
- Вызывает notifyListeners()

##### closeAllCards()
Закрытие всех карт (для анимации перезагрузки).
```dart
void closeAllCards()
```
- Устанавливает для всех карт isOpen = false и isFind = false
- Вызывает notifyListeners()

##### reloadGame()
Перезапуск игры.
```dart
void reloadGame()
```
- Перемешивает карты
- Сбрасывает счет до 200
- Сбрасывает счетчик найденных пар
- Вызывает notifyListeners()

---

## Сервисы (Services)

### FirebaseConfig
**Файл**: `lib/services/firebase_config.dart`

Конфигурация Firebase для проекта.

#### Свойства
```dart
static const FirebaseOptions firebaseOptions
// Параметры подключения к Firebase
```

#### Методы

##### initialize()
Инициализация Firebase.
```dart
static Future<void> initialize()
```
- Вызывается в main() перед запуском приложения
- Инициализирует Firebase с заданными параметрами

---

### FirebaseService
**Файл**: `lib/services/firebase_service.dart`

Сервис для работы с Firebase Realtime Database.

#### Методы

##### saveScore({required UserModel user, required int score})
Сохранение результата в таблицу лидеров.
```dart
Future<void> saveScore({
  required UserModel user,
  required int score,
})
```
- Создает запись LeaderboardEntry
- Сохраняет в Firebase по пути `leadership/{userId}`
- Используется при первой игре

##### updateScoreIfBetter({required UserModel user, required int newScore})
Обновление результата если новый счет лучше старого.
```dart
Future<void> updateScoreIfBetter({
  required UserModel user,
  required int newScore,
})
```
- Проверяет существующий результат
- Если новый счет больше - обновляет запись
- Используется при повторных играх

##### getLeaderboard()
Получение таблицы лидеров (топ 10).
```dart
Future<List<LeaderboardEntry>> getLeaderboard()
```
- Загружает все записи из Firebase
- Сортирует по убыванию счета
- Возвращает топ-10 игроков

##### watchLeaderboard()
Прослушивание изменений в таблице лидеров в реальном времени.
```dart
Stream<List<LeaderboardEntry>> watchLeaderboard()
```
- Возвращает Stream с обновлениями
- Автоматически обновляется при изменениях в Firebase
- Можно использовать с StreamBuilder

---

## Утилиты (Utils)

### CardUtils
**Файл**: `lib/utils/card_utils.dart`

Вспомогательные функции для работы с картами.

#### Константы
```dart
static const List<String> cardNames
// Список из 15 названий карт: ["card1", "card2", ..., "card15"]
```

#### Методы

##### shuffle<T>(List<T> array)
Перемешивание массива (алгоритм Fisher-Yates).
```dart
static List<T> shuffle<T>(List<T> array)
```
- Универсальная функция для любого типа данных
- Случайное перемешивание элементов
- Возвращает новый перемешанный список

##### createCardList()
Создание списка карт для игры.
```dart
static List<CardModel> createCardList()
```
- Создает 15 уникальных карт
- Дублирует список (каждая карта × 2 = 30 карт)
- Перемешивает и возвращает готовый список

##### getFormattedDate()
Получение текущей даты в формате для Firebase.
```dart
static String getFormattedDate()
```
- Формат: `YYYY-M-D/H:M`
- Пример: `2024-11-12/15:30`
- Используется при сохранении результатов

---

## Виджеты (Widgets)

### GameCard
**Файл**: `lib/widgets/game_card.dart`

Виджет карты с анимацией переворота.

#### Параметры конструктора
```dart
GameCard({
  required String cardName,      // Имя изображения
  required bool isOpen,          // Открыта ли карта
  required bool isFind,          // Найдена ли пара
  required VoidCallback onTap,   // Обработчик нажатия
})
```

#### Особенности
- Анимация переворота 3D (500ms)
- Показывает вопросительный знак когда закрыта
- Показывает изображение когда открыта
- Зеленый фон для найденных пар
- Белый фон для остальных

---

### LoginDialog
**Файл**: `lib/widgets/login_dialog.dart`

Диалог ввода имени пользователя.

#### Параметры конструктора
```dart
LoginDialog({
  required Function(UserModel) onUserCreated,  // Callback при создании пользователя
})
```

#### Особенности
- Валидация имени (не может быть пустым)
- Ограничение длины (максимум 15 символов)
- Генерация UUID для пользователя
- Автоматическое закрытие после ввода

---

### ResultDialog
**Файл**: `lib/widgets/result_dialog.dart`

Диалог результатов игры с таблицей лидеров.

#### Параметры конструктора
```dart
ResultDialog({
  required UserModel user,         // Данные игрока
  required int score,              // Набранный счет
  required VoidCallback onPlayAgain,  // Callback для повторной игры
  required bool isFirstGame,       // Первая ли это игра
})
```

#### Особенности
- Автоматическое сохранение результата в Firebase
- Отображение топ-10 игроков
- Выделение текущего игрока цветом
- Кнопка "Играть снова"
- Индикатор загрузки данных

---

## Экраны (Screens)

### GameScreen
**Файл**: `lib/screens/game_screen.dart`

Главный экран игры.

#### Внутреннее состояние
```dart
UserModel? _user              // Данные пользователя
bool _isOpen = true           // Разрешены ли клики по картам
bool _isFirstGame = true      // Первая ли это игра
```

#### Методы

##### initState()
Инициализация экрана.
- Показывает диалог входа при первом запуске

##### _showLoginDialog()
Показать диалог ввода имени.
- Модальное окно (нельзя закрыть нажатием вне области)
- Сохраняет пользователя в состояние после ввода

##### _showResultDialog(int score)
Показать диалог результатов.
- Передает текущий счет
- Обновляет флаг _isFirstGame после первого показа

##### _handleCardClick(GameProvider gameProvider, String name, int id)
Обработка клика по карте.
```dart
void _handleCardClick(GameProvider gameProvider, String name, int id)
```
- Проверяет разрешены ли клики (_isOpen)
- Вызывает selectCard в провайдере
- Если это вторая карта - ждет 1 секунду и сравнивает
- Проверяет завершение игры после сравнения

##### _handleReloadGame()
Обработка перезагрузки игры.
```dart
void _handleReloadGame()
```
- Закрывает все карты с анимацией
- Ждет 1 секунду
- Перезагружает игру через провайдер

#### Компоненты UI
- Заголовок с приветствием
- Панель счета с правилами
- Кнопка перезагрузки
- Сетка карт (GridView)
- Футер

---

## Главный файл

### main.dart
**Файл**: `lib/main.dart`

Точка входа приложения.

#### Функция main()
```dart
void main() async
```
- Инициализирует Flutter Bindings
- Инициализирует Firebase
- Запускает приложение

#### DadaMemoryGameApp
Корневой виджет приложения.
```dart
class DadaMemoryGameApp extends StatelessWidget
```
- Оборачивает в ChangeNotifierProvider с GameProvider
- Настраивает MaterialApp
- Устанавливает тему (цвета, шрифты)
- Задает GameScreen как домашний экран

---

## Использование Provider в виджетах

### Чтение данных
```dart
// В методе build
Consumer<GameProvider>(
  builder: (context, gameProvider, child) {
    return Text('Счет: ${gameProvider.point}');
  },
)
```

### Вызов методов
```dart
// Получение провайдера без listen
final gameProvider = Provider.of<GameProvider>(context, listen: false);
gameProvider.selectCard('card1', 0);

// Или через context
context.read<GameProvider>().selectCard('card1', 0);
```

---

## Примеры использования

### Создание новой игры
```dart
final gameProvider = GameProvider();
// Автоматически создается 30 перемешанных карт
// Счет устанавливается в 200
```

### Выбор карты
```dart
gameProvider.selectCard('card1', 0);  // Первая карта
gameProvider.selectCard('card2', 1);  // Вторая карта - totalSelect = 2
```

### Сравнение карт
```dart
await Future.delayed(Duration(milliseconds: 1000));
gameProvider.compareCards('card2', 1);  // Сравнить с первой картой
```

### Сохранение результата
```dart
final firebaseService = FirebaseService();
await firebaseService.saveScore(
  user: UserModel(name: 'Иван', id: 'uuid-here'),
  score: 450,
);
```

### Получение таблицы лидеров
```dart
final firebaseService = FirebaseService();
final leaderboard = await firebaseService.getLeaderboard();
// leaderboard содержит топ-10 игроков
```

---

## Константы и настройки

### Цвета
```dart
const primaryPurple = Color(0xFFBA68C8);      // Основной фиолетовый
const background = Color(0xFFE6CEFF);         // Фон
const successGreen = Color(0xFF00C853);       // Успех (найденные карты)
const reloadYellow = Color(0xFFFFEB3B);       // Кнопка перезагрузки
```

### Игровые константы
```dart
const initialScore = 200;         // Начальный счет
const matchBonus = 50;            // Бонус за совпадение
const mismatchPenalty = 10;       // Штраф за ошибку
const totalPairs = 15;            // Всего пар для победы
const totalCards = 30;            // Всего карт (15 × 2)
```

### Анимация
```dart
const cardFlipDuration = Duration(milliseconds: 500);   // Переворот карты
const compareDelay = Duration(milliseconds: 1000);      // Задержка сравнения
const reloadDelay = Duration(milliseconds: 1000);       // Задержка перезагрузки
```

---

## Firebase структура данных

### Путь в базе данных
```
leadership/
  {userId}/
    name: "Иван"
    score: 450
    id: "uuid-here"
    date: "2024-11-12/15:30"
```

### Правила безопасности (рекомендуемые)
```json
{
  "rules": {
    "leadership": {
      "$userId": {
        ".write": "auth != null || true",
        ".read": true
      }
    }
  }
}
```

---

*Справочник создан для проекта Dada Memory Game (Flutter)*
