# 🌤️ Weather App (Flutter Clean Architecture)

A weather forecasting application built with **Flutter**, adhering strictly to **Clean Architecture** principles and incorporating state-of-the-art mobile development techniques. This project is designed not just as a functional app, but as a **standardized boilerplate/showcase** for learning and applying robust software architecture.

---

## ✨ Features
- 🌍 **Location Search:** Search for the weather of any city globally using the OpenWeatherMap Geocoding API.
- 🌡️ **Real-time Data:** Get accurate updates on temperature, humidity, wind speed, and sunrise/sunset times.
- 🎨 **Real-time Weather Effects (CustomPaint):** 
  Instead of using heavy GIFs or Lottie files, the app leverages the GPU's computational power via `CustomPaint` to render highly performant, 60 FPS animations:
  - ❄️ Snowflakes falling and swaying in the wind.
  - 💨 High-speed wind streams tearing through the sky.
  - ☀️ Radiant sun rays (using MaskFilter Blur for a glowing effect).
  - 🌧️ Realistic falling rain.
  - 🌫️ Volumetric fog floating in the background.

---

## 🛠 Tech Stack

The project utilizes industry-standard packages:
- **Framework:** Flutter
- **State Management:** `flutter_riverpod` (Utilizing the modern `AsyncNotifier`).
- **Architecture:** Clean Architecture (Domain - Data - Presentation).
- **Networking:** `dio` combined with `retrofit` for type-safe, code-generated API calls.
- **Data Modeling:** `freezed` & `json_serializable` for safe, immutable data parsing.
- **Routing:** `go_router` for navigation.
- **Animation:** `flutter_animate` for smooth UI transitions.

---

## 📂 Folder Structure

The project follows a **Feature-First** approach combined with **Clean Architecture**:

```text
lib/
├── core/                   # Core configurations (Network client, interceptors...)
├── env/                    # Environment variables (BaseURLs, API Keys)
├── router/                 # GoRouter configuration
├── theme/                  # Colors and typography
└── features/
    └── weather/            # Feature: Weather
        ├── domain/         # CORE: Entities (pure data) and UseCases (business rules)
        ├── data/           # DATA: Models (JSON), Mappers, Sources (Retrofit) and Repositories
        └── presentation/   # UI: Screens, Widgets (Views) and Providers (Riverpod)
```

---

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK (Latest version)
- A free API Key from [OpenWeatherMap](https://openweathermap.org/api)

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Code Generation
Because this project heavily relies on `Freezed` and `Retrofit`, you **must** run the build_runner command before running the app:
```bash
# Generate necessary boilerplate code
dart run build_runner build --delete-conflicting-outputs
```

### 4. Configure API Key
Open `lib/env/app_env.dart` and replace the placeholder with your actual API Key:
```dart
static const String owmApiKey = 'YOUR_API_KEY_HERE';
```

### 5. Run the App
```bash
flutter run
```

---

## 🧠 Design Philosophy
- **Single Source of Truth:** All API configurations and keys are centralized in `AppEnv`.
- **Fail Fast, Fail Safe:** Errors are caught early during Model parsing, and the Mapper shields the UI from invalid data, preventing red-screen crashes.
- **Separation of Concerns:** The UI layer only renders `Entities`. It has zero knowledge of API endpoints, URLs, or JSON mapping. Everything is handled seamlessly by the Data and Domain layers.

---
*This project was built and analyzed with AI assistance for research and advanced Flutter learning purposes.*
