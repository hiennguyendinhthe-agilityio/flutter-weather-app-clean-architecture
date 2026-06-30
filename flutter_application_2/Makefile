# ═══════════════════════════════════════════════════════════════════════════
#  Enterprise Todo App — Makefile
#  Usage: make <target>
# ═══════════════════════════════════════════════════════════════════════════

APP_ENTRY = lib/main_enterprise_todo.dart

.PHONY: help dev staging prod \
        build-apk-dev build-apk-staging build-apk-prod \
        build-aab-prod build-ios-dev build-ios-staging build-ios-prod \
        test analyze gen clean setup

# ─── Help ──────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "  Enterprise Todo App — Available Commands"
	@echo "  ─────────────────────────────────────────"
	@echo "  🟢  make dev              Run app in Dev flavor"
	@echo "  🟡  make staging          Run app in Staging flavor"
	@echo "  🔴  make prod             Run app in Production flavor"
	@echo ""
	@echo "  📦  make build-apk-dev    Build APK (Dev)"
	@echo "  📦  make build-apk-staging  Build APK (Staging)"
	@echo "  📦  make build-apk-prod   Build APK release (Prod)"
	@echo "  📦  make build-aab-prod   Build App Bundle (Prod, for Play Store)"
	@echo ""
	@echo "  🍎  make build-ios-dev    Build IPA (Dev)"
	@echo "  🍎  make build-ios-prod   Build IPA (Prod)"
	@echo ""
	@echo "  🧪  make test             Run all tests with coverage"
	@echo "  🔍  make analyze          Run flutter analyze + dart format check"
	@echo "  ⚙️   make gen              Run build_runner (codegen)"
	@echo "  🧹  make clean            Clean & get packages"
	@echo "  🚀  make setup            Full setup (clean + get + gen)"
	@echo ""

# ─── Run ───────────────────────────────────────────────────────────────────
dev:
	flutter run \
		--dart-define-from-file=env/dev.json \
		--flavor dev \
		-t $(APP_ENTRY)

staging:
	flutter run \
		--dart-define-from-file=env/staging.json \
		--flavor staging \
		-t $(APP_ENTRY)

prod:
	flutter run \
		--dart-define-from-file=env/prod.json \
		--flavor prod \
		-t $(APP_ENTRY)

# ─── Build Android APK ────────────────────────────────────────────────────
build-apk-dev:
	flutter build apk \
		--dart-define-from-file=env/dev.json \
		--flavor dev \
		-t $(APP_ENTRY)

build-apk-staging:
	flutter build apk \
		--dart-define-from-file=env/staging.json \
		--flavor staging \
		-t $(APP_ENTRY)

build-apk-prod:
	flutter build apk \
		--release \
		--dart-define-from-file=env/prod.json \
		--flavor prod \
		--obfuscate \
		--split-debug-info=debug-info/ \
		-t $(APP_ENTRY)

# ─── Build Android App Bundle (Play Store) ────────────────────────────────
build-aab-prod:
	flutter build appbundle \
		--release \
		--dart-define-from-file=env/prod.json \
		--flavor prod \
		--obfuscate \
		--split-debug-info=debug-info/ \
		-t $(APP_ENTRY)

# ─── Build iOS ────────────────────────────────────────────────────────────
build-ios-dev:
	flutter build ipa \
		--dart-define-from-file=env/dev.json \
		--flavor dev \
		-t $(APP_ENTRY)

build-ios-staging:
	flutter build ipa \
		--dart-define-from-file=env/staging.json \
		--flavor staging \
		-t $(APP_ENTRY)

build-ios-prod:
	flutter build ipa \
		--release \
		--dart-define-from-file=env/prod.json \
		--flavor prod \
		--obfuscate \
		--split-debug-info=debug-info/ \
		-t $(APP_ENTRY)

# ─── Quality ──────────────────────────────────────────────────────────────
test:
	flutter test --coverage
	@echo "✅ Tests passed. Coverage at coverage/lcov.info"

analyze:
	flutter analyze
	dart format --set-exit-if-changed .
	@echo "✅ Analysis passed"

# ─── Code Generation ──────────────────────────────────────────────────────
gen:
	dart run build_runner build --delete-conflicting-outputs
	@echo "✅ Code generation complete"

gen-watch:
	dart run build_runner watch --delete-conflicting-outputs

# ─── Setup ────────────────────────────────────────────────────────────────
clean:
	flutter clean
	flutter pub get
	@echo "✅ Clean done"

setup: clean gen
	@echo "🚀 Project setup complete"
