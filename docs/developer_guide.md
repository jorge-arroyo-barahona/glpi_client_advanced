# GLPI Advanced Client - Developer Guide

*Guía del desarrollador en español más abajo*

## English Version

### Table of Contents
1. [Development Setup](#development-setup)
2. [Project Structure](#project-structure)
3. [Architecture](#architecture)
4. [Coding Standards](#coding-standards)
5. [Testing](#testing)
6. [Building](#building)
7. [Deployment](#deployment)
8. [Contributing](#contributing)

---

## Development Setup

### Prerequisites

- **Flutter SDK**: 3.24.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Git**: Latest version
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Operating System**: Windows 10+, macOS 10.15+, or Linux

### Initial Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/glpi_client_advanced.git
   cd glpi_client_advanced
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

### Development Tools

#### Recommended VS Code Extensions

```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "usernamehw.errorlens",
    "ms-vscode.vscode-eslint"
  ]
}
```

#### Flutter Doctor

Run `flutter doctor` to verify your setup:

```bash
flutter doctor
```

Expected output:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.24.0, on macOS 14.0)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device (3 available)
```

---

## Project Structure

```
glpi_client_advanced/
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── web/                     # Web-specific code
├── windows/                 # Windows-specific code
├── lib/                     # Main application code
│   ├── core/                # Core functionality
│   │   ├── constants/       # App constants
│   │   ├── errors/          # Error handling
│   │   ├── services/        # External services
│   │   ├── themes/          # UI themes
│   │   └── utils/           # Utility functions
│   │
│   ├── domain/              # Business logic
│   │   ├── entities/        # Domain models
│   │   ├── repositories/    # Repository interfaces
│   │   └── usecases/        # Use cases
│   │
│   ├── data/                # Data layer
│   │   ├── datasources/     # Data sources
│   │   ├── models/          # Data models
│   │   └── repositories/    # Repository implementations
│   │
│   ├── presentation/        # UI layer
│   │   ├── pages/           # Screens
│   │   ├── widgets/         # Reusable widgets
│   │   ├── providers/       # State management
│   │   └── navigation/      # Navigation
│   │
│   └── generated/           # Generated code
│
├── test/                    # Test files
│   ├── unit/                # Unit tests
│   ├── widget/              # Widget tests
│   └── integration/         # Integration tests
│
├── assets/                  # Assets (images, fonts)
├── docs/                    # Documentation
├── scripts/                 # Build and deployment scripts
└── pubspec.yaml             # Project configuration
```

### Key Files

- **`pubspec.yaml`**: Project dependencies and configuration
- **`analysis_options.yaml`**: Code analysis rules
- **`l10n.yaml`**: Localization configuration
- **`main.dart`**: Application entry point
- **`app_theme.dart`**: Theme definitions
- **`app_router.dart`**: Navigation configuration

---

## Architecture

### Clean Architecture Principles

1. **Dependency Rule**: Dependencies point inward
2. **Separation of Concerns**: Clear layer boundaries
3. **Testability**: Each layer independently testable
4. **Framework Independence**: Business logic isolated

### Layer Responsibilities

#### Core Layer (`lib/core/`)

- **Constants**: App-wide constants and configuration
- **Errors**: Custom exception classes
- **Services**: External service interfaces
- **Themes**: UI theme definitions
- **Utils**: Utility functions and helpers

#### Domain Layer (`lib/domain/`)

- **Entities**: Business objects and value objects
- **Repositories**: Repository interfaces (contracts)
- **Use Cases**: Application business rules

#### Data Layer (`lib/data/`)

- **Data Sources**: API clients, database access
- **Models**: Data transfer objects
- **Repositories**: Repository implementations

#### Presentation Layer (`lib/presentation/`)

- **Pages**: Screens and views
- **Widgets**: Reusable UI components
- **Providers**: State management with Riverpod
- **Navigation**: Routing configuration

### State Management

#### Riverpod Architecture

```dart
// Provider definition
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    apiClient: ref.watch(apiClientProvider),
    sharedPreferencesHelper: ref.watch(sharedPreferencesHelperProvider),
  );
});

// State notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.apiClient,
    required this.sharedPreferencesHelper,
  }) : super(const AuthState());

  // State and methods...
}

// Usage in widget
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: () {
        ref.read(authProvider.notifier).login(
          appToken: 'token',
          userToken: 'user_token',
        );
      },
      child: const Text('Login'),
    );
  }
}
```

### API Client Architecture

```dart
class GlpiApiClient {
  final Dio _dio;
  
  Future<TicketModel> getTicket(int id) async {
    try {
      final response = await _dio.get('/Ticket/$id');
      return TicketModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException error) {
    // Error handling logic
  }
}
```

---

## Coding Standards

### Code Style

We use the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide with custom rules defined in `analysis_options.yaml`:

```yaml
linter:
  rules:
    - always_declare_return_types
    - always_require_non_null_named_parameters
    - annotate_overrides
    - avoid_bool_literals_in_conditional_expressions
    # ... more rules
```

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `TicketCard`)
- **Variables**: `camelCase` (e.g., `ticketId`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `API_BASE_URL`)
- **Files**: `snake_case.dart` (e.g., `ticket_card.dart`)
- **Folders**: `snake_case` (e.g., `ticket_management/`)

### Code Organization

#### Widget Structure

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('My Widget'));
  }

  Widget _buildBody() {
    return Center(child: Text('Content'));
  }

  FloatingActionButton _buildFab() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}
```

#### State Management Pattern

```dart
// State class
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    String? sessionToken,
    Failure? error,
  }) = _AuthState;
}

// Notifier class
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.repository}) : super(const AuthState());
  
  final AuthRepository repository;
  
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await repository.login(username, password);
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure,
      ),
      (session) => state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        sessionToken: session.token,
      ),
    );
  }
}
```

---

## Testing

### Test Structure

```
test/
├── unit/                    # Unit tests
│   ├── core/               # Core layer tests
│   ├── domain/             # Domain layer tests
│   └── data/               # Data layer tests
├── widget/                 # Widget tests
│   ├── pages/              # Page widget tests
│   └── widgets/            # Component widget tests
└── integration/            # Integration tests
    └── app_test.dart       # App integration tests
```

### Unit Testing

```dart
// test/unit/domain/usecases/get_tickets_test.dart
void main() {
  late GetTickets usecase;
  late MockTicketRepository mockRepository;

  setUp(() {
    mockRepository = MockTicketRepository();
    usecase = GetTickets(mockRepository);
  });

  group('GetTickets', () {
    test('should get tickets from repository', () async {
      // Arrange
      final tickets = [TestData.ticket1, TestData.ticket2];
      when(mockRepository.getTickets())
          .thenAnswer((_) async => Right(tickets));

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, Right(tickets));
      verify(mockRepository.getTickets());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

### Widget Testing

```dart
// test/widget/ticket_card_test.dart
void main() {
  testWidgets('TicketCard displays ticket information', (tester) async {
    // Arrange
    final ticket = TestData.ticket1;

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TicketCard(ticket: ticket),
        ),
      ),
    );

    // Assert
    expect(find.text(ticket.name), findsOneWidget);
    expect(find.text('#${ticket.id}'), findsOneWidget);
    expect(find.byType(StatusChip), findsOneWidget);
  });
}
```

### Integration Testing

```dart
// test/integration/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app flow', (tester) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(find.byKey('app_token_field'), 'test_token');
    await tester.enterText(find.byKey('user_token_field'), 'user_token');
    await tester.tap(find.byKey('login_button'));
    await tester.pumpAndSettle();

    // Verify home page loaded
    expect(find.text('GLPI Tickets'), findsOneWidget);
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/domain/usecases/get_tickets_test.dart

# Run widget tests
flutter test test/widget/

# Run integration tests
flutter test integration_test/
```

---

## Building

### Development Build

```bash
# Build for current platform
flutter build

# Build for specific platform
flutter build windows
flutter build web
flutter build apk
flutter build ios
```

### Production Build

```bash
# Clean previous builds
flutter clean
flutter pub get

# Build with optimization
flutter build --release

# Build with flavor
flutter build apk --flavor production --release
```

### Build Configurations

#### Android

```gradle
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.glpi_client"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt')
        }
    }
}
```

#### iOS

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleIdentifier</key>
<string>com.yourcompany.glpiClient</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
<key>CFBundleShortVersionString</key>
<string>1.0</string>
```

#### Web

```html
<!-- web/index.html -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GLPI Advanced Client</title>
</head>
<body>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

---

## Deployment

### Web Deployment

#### Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting

# Build for web
flutter build web

# Deploy
firebase deploy
```

#### Netlify

```bash
# Build for web
flutter build web

# Deploy to Netlify
netlify deploy --prod --dir=build/web
```

#### GitHub Pages

```bash
# Build for web
flutter build web

# Deploy to GitHub Pages
gh-pages -d build/web
```

### Mobile Deployment

#### Android (Google Play Store)

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Upload to Play Store
# Use Google Play Console or CI/CD pipeline
```

#### iOS (App Store)

```bash
# Build for iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace

# Archive and upload to App Store
# Use Xcode or CI/CD pipeline
```

### Desktop Deployment

#### Windows

```bash
# Build Windows app
flutter build windows --release

# Create installer
# Use tools like Inno Setup or WiX
```

#### macOS

```bash
# Build macOS app
flutter build macos --release

# Create DMG
# Use tools like create-dmg
```

#### Linux

```bash
# Build Linux app
flutter build linux --release

# Create package
# Use tools like dpkg or rpm
```

---

## Contributing

### Development Workflow

1. **Fork the Repository**
   ```bash
   git fork https://github.com/yourusername/glpi_client_advanced.git
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow coding standards
   - Add tests for new functionality
   - Update documentation

4. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

6. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes
- **refactor**: Code refactoring
- **test**: Test-related changes
- **chore**: Build process or auxiliary tool changes

#### Examples

```bash
feat: add AI assistant integration
fix: resolve ticket loading issue
docs: update API documentation
style: format code with dartfmt
refactor: reorganize widget structure
test: add unit tests for auth provider
chore: update dependencies
```

### Code Review Process

1. **Create Pull Request**: Submit your changes
2. **Automated Checks**: CI/CD pipeline runs
3. **Code Review**: Team members review
4. **Feedback**: Address review comments
5. **Approval**: Get approval from maintainers
6. **Merge**: Changes are merged to main

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

---

## 🌟 Guía del Desarrollador - Versión en Español

### Configuración de Desarrollo

#### Requisitos Previos

- **Flutter SDK**: 3.24.0 o superior
- **Dart SDK**: 3.5.0 o superior
- **Git**: Última versión
- **IDE**: VS Code, Android Studio o IntelliJ IDEA
- **Sistema Operativo**: Windows 10+, macOS 10.15+ o Linux

#### Configuración Inicial

1. **Clonar el Repositorio**
   ```bash
   git clone https://github.com/yourusername/glpi_client_advanced.git
   cd glpi_client_advanced
   ```

2. **Instalar Dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar Código**
   ```bash
   flutter pub run build_runner build
   ```

4. **Ejecutar la Aplicación**
   ```bash
   flutter run
   ```

### Estructura del Proyecto

```
glpi_client_advanced/
├── android/                 # Código específico de Android
├── ios/                     # Código específico de iOS
├── web/                     # Código específico de Web
├── windows/                 # Código específico de Windows
├── lib/                     # Código principal de la aplicación
│   ├── core/                # Funcionalidad central
│   │   ├── constants/       # Constantes de la app
│   │   ├── errors/          # Manejo de errores
│   │   ├── services/        # Servicios externos
│   │   ├── themes/          # Temas de UI
│   │   └── utils/           # Funciones de utilidad
│   │
│   ├── domain/              # Lógica de negocio
│   │   ├── entities/        # Modelos de dominio
│   │   ├── repositories/    # Interfaces de repositorio
│   │   └── usecases/        # Casos de uso
│   │
│   ├── data/                # Capa de datos
│   │   ├── datasources/     # Fuentes de datos
│   │   ├── models/          # Modelos de datos
│   │   └── repositories/    # Implementaciones de repositorio
│   │
│   ├── presentation/        # Capa de presentación
│   │   ├── pages/           # Pantallas
│   │   ├── widgets/         # Componentes UI reutilizables
│   │   ├── providers/       # Gestión de estado
│   │   └── navigation/      # Navegación
│   │
│   └── generated/           # Código generado
│
├── test/                    # Archivos de prueba
│   ├── unit/                # Pruebas unitarias
│   ├── widget/              # Pruebas de widget
│   └── integration/         # Pruebas de integración
│
├── assets/                  # Recursos (imágenes, fuentes)
├── docs/                    # Documentación
├── scripts/                 # Scripts de construcción y despliegue
└── pubspec.yaml             # Configuración del proyecto
```

### Arquitectura

#### Principios de Arquitectura Limpia

1. **Regla de Dependencia**: Las dependencias apuntan hacia adentro
2. **Separación de Preocupaciones**: Límites claros de capa
3. **Testabilidad**: Cada capa independientemente testeable
4. **Independencia del Framework**: Lógica de negocio aislada

#### Responsabilidades de Capa

##### Capa Core (`lib/core/`)

- **Constantes**: Constantes y configuración de toda la aplicación
- **Errores**: Clases de excepción personalizadas
- **Servicios**: Interfaces de servicios externos
- **Temas**: Definiciones de temas de UI
- **Utilidades**: Funciones de utilidad y ayudantes

##### Capa de Dominio (`lib/domain/`)

- **Entidades**: Objetos de negocio y objetos de valor
- **Repositorios**: Interfaces de repositorio (contratos)
- **Casos de Uso**: Reglas de negocio de la aplicación

##### Capa de Datos (`lib/data/`)

- **Fuentes de Datos**: Clientes API, acceso a base de datos
- **Modelos**: Objetos de transferencia de datos
- **Repositorios**: Implementaciones de repositorio

##### Capa de Presentación (`lib/presentation/`)

- **Páginas**: Pantallas y vistas
- **Widgets**: Componentes UI reutilizables
- **Proveedores**: Gestión de estado con Riverpod
- **Navegación**: Configuración de enrutamiento

### Estándares de Codificación

#### Estilo de Código

Usamos la [guía de estilo Effective Dart](https://dart.dev/guides/language/effective-dart) con reglas personalizadas definidas en `analysis_options.yaml`:

#### Convenciones de Nomenclatura

- **Clases**: `PascalCase` (ej., `TicketCard`)
- **Variables**: `camelCase` (ej., `ticketId`)
- **Constantes**: `SCREAMING_SNAKE_CASE` (ej., `API_BASE_URL`)
- **Archivos**: `snake_case.dart` (ej., `ticket_card.dart`)
- **Carpetas**: `snake_case` (ej., `ticket_management/`)

### Pruebas

#### Estructura de Pruebas

```
test/
├── unit/                    # Pruebas unitarias
│   ├── core/               # Pruebas de capa core
│   ├── domain/             # Pruebas de capa de dominio
│   └── data/               # Pruebas de capa de datos
├── widget/                 # Pruebas de widget
│   ├── pages/              # Pruebas de widget de página
│   └── widgets/            # Pruebas de widget de componente
└── integration/            # Pruebas de integración
    └── app_test.dart       # Pruebas de integración de la app
```

#### Ejecutar Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar con cobertura
flutter test --coverage

# Ejecutar archivo de prueba específico
flutter test test/unit/domain/usecases/get_tickets_test.dart

# Ejecutar pruebas de widget
flutter test test/widget/

# Ejecutar pruebas de integración
flutter test integration_test/
```

### Construcción

#### Construcción de Desarrollo

```bash
# Construir para plataforma actual
flutter build

# Construir para plataforma específica
flutter build windows
flutter build web
flutter build apk
flutter build ios
```

#### Construcción de Producción

```bash
# Limpiar construcciones anteriores
flutter clean
flutter pub get

# Construir con optimización
flutter build --release

# Construir con sabor
flutter build apk --flavor production --release
```

### Despliegue

#### Despliegue Web

##### Firebase Hosting

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Inicializar Firebase
firebase init hosting

# Construir para web
flutter build web

# Desplegar
firebase deploy
```

#### Despliegue Móvil

##### Android (Google Play Store)

```bash
# Construir APK
flutter build apk --release

# Construir App Bundle
flutter build appbundle --release

# Subir a Play Store
# Usar Google Play Console o pipeline CI/CD
```

##### iOS (App Store)

```bash
# Construir para iOS
flutter build ios --release

# Abrir en Xcode
open ios/Runner.xcworkspace

# Archivar y subir a App Store
# Usar Xcode o pipeline CI/CD
```

### Contribuir

#### Flujo de Desarrollo

1. **Bifurcar el Repositorio**
   ```bash
   git fork https://github.com/yourusername/glpi_client_advanced.git
   ```

2. **Crear Rama de Característica**
   ```bash
   git checkout -b feature/nombre-de-su-característica
   ```

3. **Hacer Cambios**
   - Seguir estándares de codificación
   - Agregar pruebas para nueva funcionalidad
   - Actualizar documentación

4. **Probar Sus Cambios**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Confirmar Cambios**
   ```bash
   git add .
   git commit -m "feat: agregar nueva característica"
   ```

6. **Empujar y Crear PR**
   ```bash
   git push origin feature/nombre-de-su-característica
   ```

#### Convención de Mensajes de Confirmación

Seguimos la especificación [Commits Convencionales](https://www.conventionalcommits.org/):

```bash
feat: agregar integración del asistente de IA
fix: resolver problema de carga de ticket
docs: actualizar documentación de API
style: formatear código con dartfmt
refactor: reorganizar estructura de widget
test: agregar pruebas unitarias para proveedor de auth
chore: actualizar dependencias
```

---

**¡Gracias por contribuir al Cliente Avanzado GLPI!**