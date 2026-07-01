# Enterprise Todo App

A Flutter project built with an enterprise-style architecture, including environment management and CI/CD pipelines.

## 🚀 Environment & Flavors

The app is split into three environments (flavors) to separate API, Firebase, and Crashlytics configurations:

| Environment | Flavor | Bundle ID | Configuration data (`--dart-define`) |
| --- | --- | --- | --- |
| **Development** | `dev` | `com.example.flutter_application_2.dev` | `env/dev.json` |
| **Staging** | `staging` | `com.example.flutter_application_2.staging` | `env/staging.json` |
| **Production** | `prod` | `com.example.flutter_application_2` | `env/prod.json` |

> **Note**: The `env/*.json` files contain sensitive information and are ignored by Git. To run the project for the first time, copy the contents from `env/*.example.json` to `env/*.json` and update the values accordingly.

## 🛠 Run & Build

Use the `Makefile` for quick project commands. Open a terminal at the project root and run:

### Run the App
- `make dev` — Run the app in the Development environment
- `make staging` — Run the app in the Staging environment
- `make prod` — Run the app in the Production environment

### Build APK
- `make build-apk-dev`
- `make build-apk-staging`
- `make build-apk-prod` (Release)

### Code Quality
- `make analyze` — Run linting and format checks
- `make test` — Run unit tests and coverage
- `make gen` — Run `build_runner` to generate code for Freezed, Retrofit, and related tools

## 🔄 CI/CD Pipelines (GitHub Actions)

The project includes GitHub Actions CI/CD pipelines for the following workflows:

1. **CI Pipeline** (`ci.yml`):
   - Runs when a pull request is opened or code is pushed to `main`, `staging`, or `develop`.
   - Steps: `Static Analysis` -> `Dart Format Check` -> `Unit Tests (Coverage >= 60%)` -> `Build Android Dev APK`.

2. **CD Staging** (`cd_staging.yml`):
   - Runs when code is pushed to the `staging` branch.
   - Builds the release APK with the `staging` flavor and uploads it to **Firebase App Distribution** for testers.

3. **CD Production** (`cd_production.yml`):
   - Runs when tags matching `v*.*.*` are pushed, for example `v1.0.0`.
   - Builds the Android App Bundle (`.aab`) and uploads it to the **Google Play Console** internal track.
   - Builds the iOS IPA and uploads it to **TestFlight** through App Store Connect.

### Required GitHub Secrets
To make the pipelines work, go to **Settings > Secrets and variables > Actions** and create the following keys:
- `CODECOV_TOKEN` (test coverage reporting)
- `FIREBASE_TOKEN`, `FIREBASE_APP_ID_STAGING_ANDROID`
- `KEYSTORE_BASE64`, `STORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS` (for Android release builds)
- `GOOGLE_PLAY_SERVICE_ACCOUNT` (JSON base64)
- API variables: `DEV_API_BASE_URL`, `STAGING_API_BASE_URL`, `PROD_API_BASE_URL`

## 📦 Architecture

- **State Management**: Riverpod (`flutter_riverpod`)
- **Network**: Dio + Retrofit
- **Local Storage**: Hive
- **Routing**: Go Router
- **Code Generation**: Freezed, json_serializable
