# GLPI Advanced Client

An advanced multiplatform GLPI client developed with Flutter, featuring AI integration, local awareness, and geographic location support.

## 🌟 Features

### Core Features
- **Multiplatform Support**: Windows, Web, Android, iOS
- **Modern UI**: Material 3 design with light/dark themes
- **Secure Authentication**: Token-based authentication with secure storage
- **Real-time Data**: Live ticket updates and notifications

### Advanced Features
- **AI Integration**: Intelligent ticket analysis and suggestions
- **Local Awareness**: Personalized workflow recommendations
- **Geographic Location**: Location-based ticket management
- **Offline Support**: Local caching with sync capabilities

### Technical Features
- **Clean Architecture**: Domain-driven design with Riverpod
- **Type Safety**: Full null safety and type checking
- **Performance**: Optimized with lazy loading and caching
- **Testing**: Comprehensive unit and widget tests

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.24.0 or higher
- Dart SDK 3.5.0 or higher
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/glpi_client_advanced.git
   cd glpi_client_advanced
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d windows
   flutter run -d chrome
   flutter run -d android
   flutter run -d ios
   ```

### Configuration

1. **Update API Configuration**
   Edit `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'https://your-glpi-server.com/apirest.php';
   ```

2. **Set up AI Service**
   Edit `lib/core/constants/app_constants.dart`:
   ```dart
   static const String aiApiKey = 'your-openai-api-key';
   ```

3. **Configure App Tokens**
   Get your App Token from GLPI:
   - Go to GLPI Setup > General > API
   - Generate or view your App Token

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Windows  | ✅ Full | Native desktop support |
| Web      | ✅ Full | PWA ready |
| Android  | ✅ Full | Mobile optimized |
| iOS      | ✅ Full | Mobile optimized |
| macOS    | 🚧 Planned | Coming soon |
| Linux    | 🚧 Planned | Coming soon |

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/           # Core functionality
│   ├── constants/  # App constants
│   ├── errors/     # Error handling
│   ├── services/   # External services
│   ├── themes/     # UI themes
│   └── utils/      # Utility functions
│
├── domain/         # Business logic
│   ├── entities/   # Domain models
│   ├── repositories/ # Repository interfaces
│   └── usecases/   # Use cases
│
├── data/           # Data layer
│   ├── datasources/ # Data sources
│   ├── models/     # Data models
│   └── repositories/ # Repository implementations
│
├── presentation/   # UI layer
│   ├── pages/      # Screens
│   ├── widgets/    # Reusable widgets
│   ├── providers/  # State management
│   └── navigation/ # Navigation
│
└── generated/      # Generated code
```

### State Management

- **Riverpod**: Primary state management solution
- **Providers**: Authentication, tickets, settings
- **Notifiers**: Business logic and state updates
- **Selectors**: Optimized widget rebuilds

### Key Technologies

- **Flutter**: UI framework
- **Dart**: Programming language
- **Riverpod**: State management
- **Dio**: HTTP client
- **SQLite**: Local database
- **Geolocator**: Location services
- **OpenAI**: AI integration

## 🎯 Usage

### Authentication

The app supports two authentication methods:

1. **User Token**: Recommended for security
   - Generate user token in GLPI user preferences
   - Use token for authentication

2. **Username/Password**: Traditional login
   - Use GLPI credentials
   - Less secure but convenient

### Ticket Management

- **View Tickets**: Browse all tickets with filters
- **Search**: Full-text search with suggestions
- **Filter**: By status, priority, category, date
- **Create**: New tickets with AI assistance
- **Update**: Modify existing tickets
- **Delete**: Remove tickets (with confirmation)

### AI Assistant

The AI assistant can help with:

- **Ticket Analysis**: Content improvement suggestions
- **Category Suggestions**: Automatic categorization
- **Similar Tickets**: Find related issues
- **Response Generation**: Draft responses
- **Solution Suggestions**: Provide solutions

### Location Features

- **Current Location**: Use device GPS
- **Address Search**: Find coordinates by address
- **Map View**: Visualize ticket locations
- **Distance Calculation**: Measure distances
- **Location Filtering**: Filter tickets by proximity

## 🔧 Development

### Code Generation

```bash
# Generate JSON serialization
flutter pub run build_runner build

# Watch for changes
flutter pub run build_runner watch

# Clean generated files
flutter pub run build_runner clean
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/login_test.dart
```

### Building

```bash
# Build for production
flutter build windows
flutter build web
flutter build apk
flutter build ios

# Build with flavor
flutter build apk --flavor production
```

## 🌍 Internationalization

The app supports multiple languages:

- **English** (en)
- **Spanish** (es)
- **More languages** coming soon

### Adding New Languages

1. Create ARB file in `lib/l10n/`
2. Add locale to `l10n.yaml`
3. Run code generation
4. Update supported locales in `main.dart`

## 🔐 Security

### Authentication
- Secure token storage using Flutter Secure Storage
- Automatic token refresh
- Session management

### Data Protection
- Local database encryption
- Secure API communication
- Input validation and sanitization

### Privacy
- GDPR compliant
- Local data processing
- Minimal data collection

## 📊 Performance

### Optimizations
- **Lazy Loading**: Load data on demand
- **Caching**: Intelligent data caching
- **Image Optimization**: Compressed images
- **Memory Management**: Efficient memory usage

### Monitoring
- Performance metrics
- Error tracking
- User analytics (anonymous)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Development Guidelines

- Follow Flutter best practices
- Use clean architecture
- Write comprehensive tests
- Document your code
- Follow code style guidelines

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Documentation
- [User Guide](docs/user_guide.md)
- [Developer Guide](docs/developer_guide.md)
- [API Documentation](docs/api.md)

### Community
- [GitHub Issues](https://github.com/yourusername/glpi_client_advanced/issues)
- [Discussions](https://github.com/yourusername/glpi_client_advanced/discussions)

### Commercial Support
Available upon request.

## 🙏 Acknowledgments

- GLPI Project for the excellent API
- Flutter team for the amazing framework
- OpenAI for AI capabilities
- All contributors and testers

## 📈 Roadmap

### Version 2.1.0
- [ ] Advanced reporting
- [ ] Push notifications
- [ ] Team collaboration features

### Version 2.2.0
- [ ] Offline-first architecture
- [ ] Advanced search with filters
- [ ] Custom fields support

### Future Versions
- [ ] Voice commands
- [ ] AR/VR integration
- [ ] Advanced analytics

---

**Made with ❤️ by the GLPI Client Team**