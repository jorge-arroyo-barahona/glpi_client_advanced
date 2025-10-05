# GLPI Advanced Client - Quick Start Guide

## 🚀 Quick Setup

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Dart SDK 3.5.0 or higher
- Git

### Automatic Setup (Recommended)

```bash
# Clone the repository
git clone https://github.com/yourusername/glpi_client_advanced.git
cd glpi_client_advanced

# Run the setup script
./setup.sh
```

### Manual Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

### Using Makefile

```bash
# Setup everything
make setup

# Run the app
make run

# Run tests
make test

# Build for production
make build
```

## 🔧 Configuration

### 1. API Configuration

Edit `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'https://your-glpi-server.com/apirest.php';
  // ... other constants
}
```

### 2. AI Service Configuration

Edit `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // AI Configuration
  static const String aiApiKey = 'your-openai-api-key-here';
  // ... other constants
}
```

### 3. GLPI App Token

Get your App Token from GLPI:
1. Go to GLPI Setup > General > API
2. Generate or view your App Token
3. Use it during login

## 📱 Running on Different Platforms

### Desktop (Windows/macOS/Linux)

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Web

```bash
flutter run -d chrome
# or
flutter run -d web-server --web-port 8080
```

### Mobile

```bash
# Android
flutter run -d android

# iOS (macOS only)
flutter run -d ios
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/domain/usecases/get_tickets_test.dart
```

## 🏗️ Building for Production

### Web

```bash
flutter build web --release
```

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

### Mobile

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🐛 Troubleshooting

### Common Issues

1. **Dependencies not resolving**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build errors**
   ```bash
   flutter pub run build_runner clean
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Platform-specific issues**
   ```bash
   # Android
   cd android && ./gradlew clean
   
   # iOS
   cd ios && pod install
   ```

### Getting Help

- Check the [User Guide](docs/user_guide.md)
- Check the [Developer Guide](docs/developer_guide.md)
- Create an issue on GitHub
- Contact support

## 📚 Documentation

- [User Guide](docs/user_guide.md) - Complete user documentation in English and Spanish
- [Developer Guide](docs/developer_guide.md) - Developer documentation and coding standards
- [API Documentation](docs/api.md) - API integration guide

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- GLPI Project for the excellent API
- Flutter team for the amazing framework
- OpenAI for AI capabilities
- All contributors and testers

---

**Happy coding! 🚀**