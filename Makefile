# GLPI Advanced Client - Makefile
# Use this Makefile for common development tasks

.PHONY: help setup clean build test run analyze format generate deploy

# Default target
.DEFAULT_GOAL := help

# Variables
FLUTTER := flutter
PUB := $(FLUTTER) pub
BUILD_RUNNER := $(PUB) run build_runner
DART_FORMAT := dart format
DART_ANALYZE := dart analyze

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)GLPI Advanced Client - Development Commands$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make $(GREEN)<target>$(NC)\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(BLUE)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development Setup

setup: ## Initial project setup
	@echo "$(BLUE)Setting up project...$(NC)"
	@$(FLUTTER) pub get
	@$(BUILD_RUNNER) build --delete-conflicting-outputs
	@echo "$(GREEN)Setup complete!$(NC)"

setup-clean: ## Clean setup (removes all generated files)
	@echo "$(BLUE)Clean setup...$(NC)"
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@$(BUILD_RUNNER) build --delete-conflicting-outputs
	@echo "$(GREEN)Clean setup complete!$(NC)"

##@ Code Generation

generate: ## Generate code (models, serialization, etc.)
	@echo "$(BLUE)Generating code...$(NC)"
	@$(BUILD_RUNNER) build --delete-conflicting-outputs
	@echo "$(GREEN)Code generation complete!$(NC)"

generate-watch: ## Watch for changes and generate code
	@echo "$(BLUE)Watching for changes...$(NC)"
	@$(BUILD_RUNNER) watch --delete-conflicting-outputs

##@ Code Quality

analyze: ## Run static analysis
	@echo "$(BLUE)Running static analysis...$(NC)"
	@$(DART_ANALYZE)
	@echo "$(GREEN)Analysis complete!$(NC)"

format: ## Format code
	@echo "$(BLUE)Formatting code...$(NC)"
	@$(DART_FORMAT) . --set-exit-if-changed
	@echo "$(GREEN)Formatting complete!$(NC)"

format-fix: ## Format and fix code
	@echo "$(BLUE)Formatting and fixing code...$(NC)"
	@$(DART_FORMAT) .
	@echo "$(GREEN)Formatting complete!$(NC)"

lint: analyze format ## Run all code quality checks

##@ Testing

test: ## Run all tests
	@echo "$(BLUE)Running tests...$(NC)"
	@$(FLUTTER) test
	@echo "$(GREEN)Tests complete!$(NC)"

test-unit: ## Run unit tests
	@echo "$(BLUE)Running unit tests...$(NC)"
	@$(FLUTTER) test test/unit/
	@echo "$(GREEN)Unit tests complete!$(NC)"

test-widget: ## Run widget tests
	@echo "$(BLUE)Running widget tests...$(NC)"
	@$(FLUTTER) test test/widget/
	@echo "$(GREEN)Widget tests complete!$(NC)"

test-integration: ## Run integration tests
	@echo "$(BLUE)Running integration tests...$(NC)"
	@$(FLUTTER) test integration_test/
	@echo "$(GREEN)Integration tests complete!$(NC)"

test-coverage: ## Run tests with coverage
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	@$(FLUTTER) test --coverage
	@echo "$(GREEN)Tests with coverage complete!$(NC)"
	@echo "$(YELLOW)Coverage report generated in coverage/lcov.info$(NC)"

##@ Building

build: ## Build for current platform
	@echo "$(BLUE)Building application...$(NC)"
	@$(FLUTTER) build
	@echo "$(GREEN)Build complete!$(NC)"

build-windows: ## Build for Windows
	@echo "$(BLUE)Building for Windows...$(NC)"
	@$(FLUTTER) build windows --release
	@echo "$(GREEN)Windows build complete!$(NC)"

build-web: ## Build for Web
	@echo "$(BLUE)Building for Web...$(NC)"
	@$(FLUTTER) build web --release
	@echo "$(GREEN)Web build complete!$(NC)"

build-android: ## Build APK for Android
	@echo "$(BLUE)Building APK for Android...$(NC)"
	@$(FLUTTER) build apk --release
	@echo "$(GREEN)Android APK build complete!$(NC)"

build-aab: ## Build App Bundle for Android
	@echo "$(BLUE)Building App Bundle for Android...$(NC)"
	@$(FLUTTER) build appbundle --release
	@echo "$(GREEN)Android App Bundle build complete!$(NC)"

build-ios: ## Build for iOS
	@echo "$(BLUE)Building for iOS...$(NC)"
	@$(FLUTTER) build ios --release
	@echo "$(GREEN)iOS build complete!$(NC)"

build-macos: ## Build for macOS
	@echo "$(BLUE)Building for macOS...$(NC)"
	@$(FLUTTER) build macos --release
	@echo "$(GREEN)macOS build complete!$(NC)"

build-linux: ## Build for Linux
	@echo "$(BLUE)Building for Linux...$(NC)"
	@$(FLUTTER) build linux --release
	@echo "$(GREEN)Linux build complete!$(NC)"

##@ Development

run: ## Run the application
	@echo "$(BLUE)Running application...$(NC)"
	@$(FLUTTER) run

run-windows: ## Run on Windows
	@$(FLUTTER) run -d windows

run-web: ## Run on Web
	@$(FLUTTER) run -d chrome

run-android: ## Run on Android
	@$(FLUTTER) run -d android

run-ios: ## Run on iOS
	@$(FLUTTER) run -d ios

run-macos: ## Run on macOS
	@$(FLUTTER) run -d macos

run-linux: ## Run on Linux
	@$(FLUTTER) run -d linux

##@ Maintenance

clean: ## Clean build artifacts
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	@$(FLUTTER) clean
	@rm -rf .dart_tool/
	@rm -rf build/
	@echo "$(GREEN)Clean complete!$(NC)"

clean-all: clean ## Clean everything including dependencies
	@echo "$(BLUE)Cleaning everything...$(NC)"
	@rm -rf .packages
	@rm -rf .flutter-plugins
	@rm -rf .flutter-plugins-dependencies
	@rm -rf pubspec.lock
	@echo "$(GREEN)Complete clean complete!$(NC)"

reset: clean-all setup ## Reset project to clean state

##@ Utilities

doctor: ## Run flutter doctor
	@$(FLUTTER) doctor

version: ## Show Flutter version
	@$(FLUTTER) --version

upgrade: ## Upgrade Flutter
	@$(FLUTTER) upgrade

pub-upgrade: ## Upgrade dependencies
	@$(PUB) upgrade

pub-outdated: ## Check for outdated dependencies
	@$(PUB) outdated

##@ CI/CD

ci-setup: setup ## CI/CD setup
	@echo "$(BLUE)CI/CD setup complete!$(NC)"

ci-test: lint test ## CI/CD test pipeline
	@echo "$(BLUE)CI/CD test pipeline complete!$(NC)"

ci-build: build ## CI/CD build pipeline
	@echo "$(BLUE)CI/CD build pipeline complete!$(NC)"

##@ Documentation

docs: ## Generate documentation
	@echo "$(BLUE)Generating documentation...$(NC)"
	@dart doc .
	@echo "$(GREEN)Documentation generated!$(NC)"

##@ Docker (if using Docker)

docker-build: ## Build Docker image
	@echo "$(BLUE)Building Docker image...$(NC)"
	@docker build -t glpi-client .
	@echo "$(GREEN)Docker image built!$(NC)"

docker-run: ## Run Docker container
	@echo "$(BLUE)Running Docker container...$(NC)"
	@docker run -p 8080:8080 glpi-client
	@echo "$(GREEN)Docker container running!$(NC)"

##@ Git Hooks (optional)
install-hooks: ## Install git hooks
	@echo "$(BLUE)Installing git hooks...$(NC)"
	@cp scripts/pre-commit .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "$(GREEN)Git hooks installed!$(NC)"

##@ Release

release-patch: ## Create patch release
	@echo "$(BLUE)Creating patch release...$(NC)"
	@npm version patch
	@echo "$(GREEN)Patch release created!$(NC)"

release-minor: ## Create minor release
	@echo "$(BLUE)Creating minor release...$(NC)"
	@npm version minor
	@echo "$(GREEN)Minor release created!$(NC)"

release-major: ## Create major release
	@echo "$(BLUE)Creating major release...$(NC)"
	@npm version major
	@echo "$(GREEN)Major release created!$(NC)"

##@ Platform specific

# Android specific
android-clean: ## Clean Android build
	@echo "$(BLUE)Cleaning Android build...$(NC)"
	@cd android && ./gradlew clean
	@echo "$(GREEN)Android clean complete!$(NC)"

android-build: ## Build Android APK
	@$(MAKE) build-android

# iOS specific
ios-clean: ## Clean iOS build
	@echo "$(BLUE)Cleaning iOS build...$(NC)"
	@rm -rf ios/DerivedData/
	@rm -rf ios/build/
	@echo "$(GREEN)iOS clean complete!$(NC)"

ios-pod-install: ## Install iOS pods
	@echo "$(BLUE)Installing iOS pods...$(NC)"
	@cd ios && pod install
	@echo "$(GREEN)iOS pods installed!$(NC)"

# Web specific
web-serve: ## Serve web build locally
	@echo "$(BLUE)Serving web build...$(NC)"
	@cd build/web && python3 -m http.server 8080
	@echo "$(GREEN)Web server running on http://localhost:8080$(NC)"

##@ Development shortcuts

dev: setup generate lint test run ## Full development cycle

quick-test: generate lint test ## Quick test cycle

quick-build: clean setup generate build ## Quick build cycle

# Alias for common commands
i: setup ## Install dependencies
t: test ## Run tests
l: lint ## Run linting
r: run ## Run app
b: build ## Build app
c: clean ## Clean project

# Show help by default
.DEFAULT:
	@$(MAKE) help