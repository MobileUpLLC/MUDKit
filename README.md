# MUDKit

**MUDKit** — iOS-фреймворк, разработанный для упрощения разработки и отладки приложений. Он предоставляет набор инструментов для логирования, управления фича-тогглами, настройки окружений, обработки диплинков, работы с файловой системой и хранилищем, а также интеграцию с Pulse для мониторинга сетевых запросов.

## Возможности

- **Логирование**: Гибкая система логирования с поддержкой уровней (debug, info, error, fault) и интеграцией с Pulse.
- **Фича-тогглы**: Управление функциональностью приложения с возможностью переопределения настроек через UserDefaults.
- **Окружения**: Поддержка нескольких окружений (например, dev, prod) с выбором активного окружения.
- **Диплинки**: Обработка диплинков с использованием конфигурируемого обработчика.
- **Файловая система**: Просмотр, удаление и воспроизведение файлов (текст, изображения, видео, аудио, HTML/JSON/XML).
- **Хранилище**: Упрощённая работа с UserDefaults и Keychain для сохранения и удаления данных.
- **Pulse**: Логирование сетевых запросов с использованием Alamofire и Pulse.
- **UI для отладки**: Интуитивно понятный интерфейс через `MUDKitView` для доступа ко всем функциям.

## Требования

- iOS 15.0 и выше
- Xcode 13.0 и выше
- Swift 5.5 и выше
- Зависимости: Pulse, Alamofire, KeychainSwift

## Установка

MUDKit можно установить через Swift Package Manager. Добавьте следующий пакет в ваш `Package.swift` или через интерфейс Xcode:

```swift
dependencies: [
    .package(url: "https://github.com/MobileUpLLC/MUDKit.git", .upToNextMajor(from: "1.0.0"))
]
```

В Xcode:
1. Перейдите в `File > Add Packages`.
2. Введите URL репозитория: `https://github.com/MobileUpLLC/MUDKit.git`.
3. Выберите подходящую версию и добавьте пакет.

## Использование

### Инициализация MUDKit

Настройте фреймворк с помощью `MUDKitConfigurator`. Пример настройки с поддержкой Pulse, фича-тогглов, диплинков и окружений:

```swift
import MUDKit

let configuration = await MUDKitConfigurator.setup(
    pulseConfiguration: PulseConfiguration(
        configuration: .default,
        sessionDelegate: SessionDelegate(),
        delegateQueue: OperationQueue()
    ),
    featureToggleConfiguration: FeatureToggleConfiguration(featureToggles: [
        FeatureToggle(name: "newFeature", convenientName: "Новая фича", isEnabled: false)
    ]),
    deeplinkConfiguration: DeeplinkConfiguration { url in
        print("Получен диплинк: \(url)")
    },
    environmentConfiguration: EnvironmentConfiguration(
        environments: [
            Environment(name: "dev", parameters: ["api": "https://dev.api.com"]),
            Environment(name: "prod", parameters: ["api": "https://prod.api.com"])
        ],
        defaultEnvironmentName: "dev"
    )
)
```

### Проверка фича-тогглов

Проверьте, включена ли определённая функция:

```swift
if MUDKitService.isFeatureToggleOn(name: "newFeature") {
    print("Новая функция включена")
} else {
    print("Новая функция отключена")
}
```

### Логирование

Используйте `Log` для записи сообщений с разными уровнями:

```swift
let logger = Log(subsystem: "com.yourapp", category: "network")
logger.info(logEntry: .text("Запрос начат"))
logger.error(logEntry: .detailed(text: "Запрос завершился с ошибкой", parameters: ["code": 404]))
```

### Работа с UI для отладки

Добавьте `MUDKitView` в ваше приложение для доступа к инструментам отладки:

```swift
import SwiftUI
import MUDKit

struct ContentView: View {
    var body: some View {
        MUDKitView()
    }
}
```

`MUDKitView` предоставляет доступ к следующим инструментам:
- **Pulse**: Просмотр сетевых логов.
- **Feature Toggles**: Управление фича-тогглами.
- **UserDefaults**: Просмотр и удаление данных UserDefaults.
- **Keychain**: Управление данными в Keychain.
- **Deeplink**: Тестирование диплинков.
- **Environments**: Переключение окружений.
- **File System**: Просмотр и удаление файлов.
