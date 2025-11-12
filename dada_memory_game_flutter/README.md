# Dada Memory Game - Flutter версия

## О проекте

Это полный порт игры **Dada Memory Game** с React/Redux на **Flutter/Dart**. Классическая игра на запоминание, где нужно находить пары одинаковых карточек.

### Оригинальный проект
- Автор: Suleyman Dadashov
- Оригинальная версия: React + Redux
- Демо: [dadamemorygame.netlify.app](https://dadamemorygame.netlify.app/)

### Портированная версия
- Платформа: Flutter
- Язык: Dart
- Управление состоянием: Provider
- База данных: Firebase Realtime Database

---

## Возможности

✅ **Полная функциональность оригинала**
- Игровая механика с 30 карточками (15 пар)
- Система очков (старт 200, +50 за совпадение, -10 за ошибку)
- Анимация переворота карт
- Таблица лидеров с топ-10 игроков
- Адаптивный дизайн для разных размеров экрана

✅ **Дополнительно**
- Поддержка Android и iOS
- Офлайн работа (кроме таблицы лидеров)
- Современный Material Design
- Плавные анимации

---

## Установка и запуск

### Требования

1. **Flutter SDK** (версия 3.0.0 или выше)
   - Установка: https://docs.flutter.dev/get-started/install

2. **Dart SDK** (обычно идет с Flutter)

3. **Visual Studio Code** или **Android Studio**
   - VS Code: https://code.visualstudio.com/
   - Расширение Flutter для VS Code: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

4. **Firebase проект** (уже настроен, но можно заменить на свой)

### Шаг 1: Установка зависимостей

Откройте терминал в папке проекта и выполните:

```bash
cd dada_memory_game_flutter
flutter pub get
```

Эта команда установит все необходимые пакеты из `pubspec.yaml`:
- `provider` - управление состоянием
- `firebase_core` и `firebase_database` - работа с Firebase
- `uuid` - генерация уникальных ID
- `font_awesome_flutter` - иконки
- `google_fonts` - шрифты

### Шаг 2: Настройка Firebase (опционально)

Проект уже настроен для работы с Firebase проекта оригинального автора. Если хотите использовать свою базу данных:

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/)
2. Включите **Realtime Database** в режиме test mode
3. Скачайте конфигурационные файлы:
   - Для Android: `google-services.json` → `android/app/`
   - Для iOS: `GoogleService-Info.plist` → `ios/Runner/`
4. Обновите `lib/services/firebase_config.dart` своими данными

### Шаг 3: Запуск на эмуляторе/устройстве

#### Для Android:

```bash
# Проверить доступные устройства
flutter devices

# Запустить на эмуляторе/устройстве Android
flutter run
```

#### Для iOS (только на macOS):

```bash
# Установить CocoaPods зависимости
cd ios
pod install
cd ..

# Запустить на симуляторе/устройстве iOS
flutter run
```

#### Для Web:

```bash
flutter run -d chrome
```

### Шаг 4: Запуск в VS Code

1. Откройте папку `dada_memory_game_flutter` в VS Code
2. Убедитесь, что установлено расширение Flutter
3. Выберите устройство в правом нижнем углу
4. Нажмите `F5` или `Run > Start Debugging`

---

## Структура проекта

```
dada_memory_game_flutter/
├── lib/
│   ├── main.dart                      # Точка входа приложения
│   ├── models/                        # Модели данных
│   │   ├── card_model.dart           # Модель карты
│   │   ├── user_model.dart           # Модель пользователя
│   │   └── leaderboard_entry.dart    # Модель записи таблицы лидеров
│   ├── providers/                     # Управление состоянием
│   │   └── game_provider.dart        # Провайдер игры (аналог Redux)
│   ├── services/                      # Сервисы
│   │   ├── firebase_config.dart      # Конфигурация Firebase
│   │   └── firebase_service.dart     # Работа с Realtime Database
│   ├── utils/                         # Утилиты
│   │   └── card_utils.dart           # Функции для карт и перемешивания
│   ├── widgets/                       # Переиспользуемые виджеты
│   │   ├── game_card.dart            # Виджет карты с анимацией
│   │   ├── login_dialog.dart         # Диалог входа
│   │   └── result_dialog.dart        # Диалог результатов
│   └── screens/                       # Экраны приложения
│       └── game_screen.dart          # Главный экран игры
├── assets/
│   └── images/                        # Изображения карт
│       ├── logo.png
│       ├── card1.png ... card15.png
├── pubspec.yaml                       # Зависимости и ресурсы
└── README.md                          # Эта инструкция
```

---

## Описание компонентов

### Models (Модели данных)

#### CardModel (`lib/models/card_model.dart`)
```dart
class CardModel {
  final String name;    // Имя изображения
  bool isOpen;          // Открыта ли карта
  bool isFind;          // Найдена ли пара
}
```

#### UserModel (`lib/models/user_model.dart`)
```dart
class UserModel {
  final String name;    // Имя игрока
  final String id;      // Уникальный ID
}
```

#### LeaderboardEntry (`lib/models/leaderboard_entry.dart`)
```dart
class LeaderboardEntry {
  final String name;    // Имя игрока
  final int score;      // Очки
  final String id;      // ID игрока
  final String date;    // Дата и время
}
```

### Provider (Управление состоянием)

#### GameProvider (`lib/providers/game_provider.dart`)

Центральный провайдер игры, аналог Redux CardSlice из оригинала.

**Состояние:**
- `cards` - список из 30 карт
- `selected` - имя первой выбранной карты
- `selectedId` - ID первой выбранной карты
- `totalSelect` - количество выбранных карт (0, 1 или 2)
- `point` - текущий счет (начальный: 200)
- `found` - количество найденных пар (0-15)

**Методы:**
- `selectCard(name, id)` - выбор карты
- `compareCards(name, id)` - сравнение двух карт
- `closeCard(id)` - закрытие открытой карты
- `closeAllCards()` - закрытие всех карт
- `reloadGame()` - перезапуск игры

### Services (Сервисы)

#### FirebaseService (`lib/services/firebase_service.dart`)

Работа с Firebase Realtime Database.

**Методы:**
- `saveScore()` - сохранение результата
- `updateScoreIfBetter()` - обновление если новый результат лучше
- `getLeaderboard()` - получение топ-10
- `watchLeaderboard()` - прослушивание изменений в реальном времени

### Widgets (Виджеты)

#### GameCard (`lib/widgets/game_card.dart`)
Виджет карты с анимацией переворота 3D.

#### LoginDialog (`lib/widgets/login_dialog.dart`)
Диалог ввода имени пользователя при первом запуске.

#### ResultDialog (`lib/widgets/result_dialog.dart`)
Диалог результатов с таблицей лидеров и кнопкой "Играть снова".

### Screens (Экраны)

#### GameScreen (`lib/screens/game_screen.dart`)
Главный экран игры, объединяющий все компоненты.

---

## Как играть

1. **Запуск игры**
   - При первом запуске введите ваше имя
   - Нажмите "Войти"

2. **Игровой процесс**
   - Нажимайте на закрытые карты (с вопросительным знаком)
   - Открывайте по две карты за раз
   - Если карты совпадают - они остаются открытыми (+50 очков)
   - Если не совпадают - они закрываются через 1 секунду (-10 очков)
   - Цель: найти все 15 пар

3. **Счет**
   - Начальный счет: 200 очков
   - Правильное совпадение: +50 очков
   - Неправильное совпадение: -10 очков
   - Минимальный счет: 0 (не может быть отрицательным)

4. **Перезагрузка**
   - Нажмите кнопку "Перезагрузить игру" для начала новой игры
   - Карты перемешаются, счет сбросится до 200

5. **Завершение игры**
   - После нахождения всех 15 пар появится диалог с результатами
   - Увидите таблицу лидеров (топ-10 игроков)
   - Ваш результат будет выделен цветом
   - Нажмите "Играть снова" для новой игры

---

## Отличия от оригинала

### Что портировано 1:1

✅ Вся игровая логика
✅ Система очков
✅ Алгоритм перемешивания (Fisher-Yates)
✅ Анимация переворота карт
✅ Таблица лидеров с Firebase
✅ Цветовая схема и дизайн
✅ Все 15 изображений карт

### Изменения

🔄 **Управление состоянием**: Redux → Provider
- Provider более естественен для Flutter
- Меньше boilerplate кода
- Лучшая интеграция с Flutter

🔄 **UI фреймворк**: React → Flutter
- Material Design виджеты
- Адаптивная сетка GridView
- Встроенные анимации Flutter

🔄 **Анимация карт**: CSS transform → Flutter AnimatedSwitcher
- 3D переворот с использованием Transform и Matrix4
- Более плавная анимация

🔄 **Названия файлов**: Изображения переименованы в card1.png - card15.png
- Проще в использовании
- Лучше для поддержки

🔄 **Язык интерфейса**: Английский → Русский
- Все тексты переведены на русский
- Сохранена оригинальная структура

### Что не портировано

❌ **Footer с социальными ссылками**
- Оставлен только текст авторства
- Можно добавить через url_launcher пакет

❌ **Styled Components**
- Заменено на встроенные Flutter виджеты и темы
- Более производительно

---

## Проблемы и решения

### Проблема: Firebase не подключается

**Решение:**
1. Проверьте интернет-соединение
2. Убедитесь, что в Firebase Console включен Realtime Database
3. Проверьте правильность конфигурации в `firebase_config.dart`
4. Для Android: убедитесь что `google-services.json` находится в `android/app/`

### Проблема: Изображения не загружаются

**Решение:**
1. Проверьте что папка `assets/images/` содержит все 16 файлов
2. Убедитесь что в `pubspec.yaml` правильно указаны пути к assets
3. Выполните `flutter clean` и `flutter pub get`
4. Перезапустите приложение

### Проблема: Ошибка при сборке

**Решение:**
```bash
# Очистить кэш
flutter clean

# Переустановить зависимости
flutter pub get

# Обновить зависимости
flutter pub upgrade

# Пересобрать
flutter run
```

### Проблема: Медленная анимация

**Решение:**
1. Запустите в Release режиме: `flutter run --release`
2. Debug режим всегда медленнее из-за дополнительных проверок

---

## Сборка для релиза

### Android APK

```bash
# Собрать APK
flutter build apk --release

# APK будет в: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (для Google Play)

```bash
# Собрать App Bundle
flutter build appbundle --release

# Bundle будет в: build/app/outputs/bundle/release/app-release.aab
```

### iOS App (только на macOS)

```bash
# Собрать iOS приложение
flutter build ios --release

# Открыть Xcode для архивации
open ios/Runner.xcworkspace
```

---

## Дальнейшее развитие

### Возможные улучшения

- 🎵 Добавить звуковые эффекты
- 🎨 Темная тема
- 🌍 Мультиязычность (i18n)
- 📱 Вибрация при совпадении/ошибке
- ⏱️ Таймер игры
- 🏆 Больше статистики (время игры, количество попыток)
- 💾 Локальное сохранение рекордов
- 🎮 Различные уровни сложности (больше/меньше карт)
- 👥 Мультиплеер режим
- 📊 Графики прогресса

---

## Технические детали

### Архитектура

Проект следует чистой архитектуре с разделением на слои:

```
Presentation Layer (UI)
    ↓
Business Logic Layer (Providers)
    ↓
Data Layer (Services, Models)
```

### Управление состоянием

Использует паттерн Provider:
- `GameProvider` - ChangeNotifier для реактивного обновления UI
- `Consumer<GameProvider>` - виджеты подписываются на изменения
- Автоматическое обновление UI при вызове `notifyListeners()`

### Работа с Firebase

```dart
// Структура данных в Firebase:
leadership/
  {userId}/
    name: "John"
    score: 450
    id: "uuid-here"
    date: "2024-1-15/14:30"
```

### Производительность

- Виджеты максимально разбиты на мелкие компоненты
- Используются `const` конструкторы где возможно
- Минимум перерисовок благодаря Provider
- Оптимизированные изображения (PNG, 2-8KB каждое)

---

## Лицензия

Этот проект является портом оригинальной работы Suleyman Dadashov.

- **Оригинальный проект**: https://github.com/Suleyman1406/DadaMemoryGame
- **Автор оригинала**: Suleyman Dadashov
- **Порт на Flutter**: Claude AI (2024)

---

## Контакты и поддержка

### Оригинальный автор
- GitHub: [@Suleyman1406](https://github.com/Suleyman1406)
- LinkedIn: [Suleyman Dadashov](https://www.linkedin.com/in/dadashow/)
- Сайт: [dadashow.me](https://dadashow.me/)

### Вопросы по Flutter версии
Создайте Issue в репозитории проекта.

---

## Благодарности

- **Suleyman Dadashov** - за оригинальную идею и реализацию
- **Flutter Team** - за отличный фреймворк
- **Firebase** - за бесплатный Realtime Database

---

**Приятной игры! 🎮🎉**
