# The-battle-of-the-intellects

**Битва интеллектов** — игра-викторина для двух команд: ведущий запускает чтение истории
вслух (TTS), а очки командам начисляются стрелками с клавиатуры.

A two-team quiz game: stories are read aloud via text-to-speech, teams score points
with the arrow keys.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)

> В `pubspec.yaml` пакет называется `uganda` — историческое имя проекта.
> The package is still named `uganda` in `pubspec.yaml` — the project's original name.

---

## 🇷🇺 Русский

### Описание

Настольная игра на чтение с пониманием для двух команд. На стартовом экране вводятся
названия команд и выбирается **пак заданий в формате ZIP** (внутри — текстовые файлы
`.txt`, по одному на задание). Если ZIP не выбран, берутся 7 встроенных историй из
`assets/texts/istoriya0..6.txt`.

Во время игры приложение озвучивает текст через `flutter_tts`. Ведущий клавишами
**←** и **→** начисляет очко команде 1 или команде 2 (и одновременно останавливает
чтение). Ведётся счёт команд, предусмотрено завершение игры.

### Возможности

- Ввод названий двух команд на стартовом экране
- Загрузка произвольного пака заданий (`.zip` с `.txt` внутри), fallback на встроенные тексты
- Озвучивание текста вслух (text-to-speech, русский язык)
- Клавиши **← / →** — очко команде 1 / команде 2 + остановка озвучки
- Учёт счёта двух команд, флаг окончания игры
- Полноэкранные фоны-иллюстрации

### Технологии

- **Flutter** (android, ios, windows, linux, macos, web)
- [flutter_tts](https://pub.dev/packages/flutter_tts) — синтез речи
- [archive](https://pub.dev/packages/archive) — распаковка ZIP с заданиями
- [file_picker](https://pub.dev/packages/file_picker), [path_provider](https://pub.dev/packages/path_provider)

### Структура проекта

```
The-battle-of-the-intellects/
├── lib/
│   ├── main.dart        # точка входа
│   ├── start_page.dart  # ввод команд, выбор пака заданий
│   └── game_page.dart   # игровой процесс: TTS, очки, клавиатура
├── assets/
│   ├── texts/           # встроенные истории (istoriya0..6.txt)
│   └── *.png            # фоны
└── pubspec.yaml
```

### Формат пака заданий

ZIP-архив, содержащий обычные `.txt` файлы (по файлу на задание/историю).
Кодировка — UTF-8.

### Запуск

```bash
flutter pub get
flutter run
```

---

## 🇬🇧 English

### Overview

A tabletop read-and-comprehend game for two teams. The start screen takes team names
and a **task pack as a ZIP file** (plain `.txt` files inside, one per task). When no
ZIP is picked, seven built-in stories from `assets/texts/istoriya0..6.txt` are used.

During the game the text is spoken aloud via `flutter_tts`. The host presses **←** or
**→** to give a point to team 1 or team 2 (which also stops the speech). Scores are
tracked for both teams and the game has an end state.

### Features

- Team names input on the start screen
- Custom task packs (`.zip` of `.txt` files) with a built-in fallback
- Text-to-speech read-aloud
- **← / →** keys — point to team 1 / team 2 + stop the speech
- Two-team scorekeeping, game-end flag
- Full-screen background art

### Tech stack

- **Flutter** (android, ios, windows, linux, macos, web)
- [flutter_tts](https://pub.dev/packages/flutter_tts) — speech synthesis
- [archive](https://pub.dev/packages/archive) — unpacking task ZIPs
- [file_picker](https://pub.dev/packages/file_picker), [path_provider](https://pub.dev/packages/path_provider)

### Project structure

```
The-battle-of-the-intellects/
├── lib/
│   ├── main.dart        # entry point
│   ├── start_page.dart  # team names, task pack selection
│   └── game_page.dart   # gameplay: TTS, scores, keyboard
├── assets/
│   ├── texts/           # built-in stories (istoriya0..6.txt)
│   └── *.png            # backgrounds
└── pubspec.yaml
```

### Task pack format

A ZIP archive with plain `.txt` files (one file per task/story), UTF-8 encoded.

### Getting started

```bash
flutter pub get
flutter run
```
