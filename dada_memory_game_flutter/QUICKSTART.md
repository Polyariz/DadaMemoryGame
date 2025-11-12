# Быстрый старт - Dada Memory Game (Flutter)

## Минимальная инструкция для запуска

### 1. Предварительные требования

Убедитесь, что установлено:
- ✅ Flutter SDK 3.0.0+
- ✅ Visual Studio Code + расширение Flutter
- ✅ Android Studio / Xcode (для эмуляторов)

### 2. Установка зависимостей

```bash
cd dada_memory_game_flutter
flutter pub get
```

### 3. Запуск приложения

#### В Visual Studio Code:
1. Откройте папку `dada_memory_game_flutter`
2. Нажмите `F5` или выберите `Run > Start Debugging`
3. Выберите устройство (эмулятор/физическое устройство)

#### Из командной строки:
```bash
# Просмотр доступных устройств
flutter devices

# Запуск на выбранном устройстве
flutter run

# Запуск в релиз режиме (быстрее)
flutter run --release
```

### 4. Первый запуск

1. Введите ваше имя
2. Начните играть!

---

## Структура файлов (кратко)

```
lib/
├── main.dart                 # Точка входа
├── models/                   # Модели данных
├── providers/                # Управление состоянием (Provider)
│   └── game_provider.dart   # Главный провайдер игры
├── services/                 # Firebase и конфигурация
├── widgets/                  # UI компоненты
├── screens/                  # Экраны приложения
└── utils/                    # Вспомогательные функции
```

---

## Основные команды

```bash
# Установка зависимостей
flutter pub get

# Запуск приложения
flutter run

# Сборка релиза (Android)
flutter build apk --release

# Сборка релиза (iOS)
flutter build ios --release

# Очистка кэша
flutter clean

# Анализ кода
flutter analyze

# Форматирование кода
dart format .
```

---

## Решение типичных проблем

### Проблема: "Flutter command not found"
**Решение:** Добавьте Flutter в PATH или укажите полный путь
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Проблема: Изображения не загружаются
**Решение:**
```bash
flutter clean
flutter pub get
flutter run
```

### Проблема: Firebase не подключается
**Решение:** Проверьте интернет-соединение. Firebase уже настроен и должен работать.

---

## Горячие клавиши в VS Code

- `F5` - Запуск в debug режиме
- `Shift + F5` - Остановка приложения
- `Ctrl + F5` - Запуск без отладки
- `r` в терминале - Hot reload (обновление без перезапуска)
- `R` в терминале - Hot restart (полная перезагрузка)

---

## Что делать дальше?

1. 📖 Прочитайте полный [README.md](README.md) для детальной информации
2. 📋 Изучите [PORTING_CHECKLIST.md](PORTING_CHECKLIST.md) для понимания архитектуры
3. 🎮 Начните играть и наслаждайтесь!

---

**Удачи! 🎮**
