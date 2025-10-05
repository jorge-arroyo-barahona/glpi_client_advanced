import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/themes/app_theme.dart';
import 'package:glpi_client_advanced/presentation/providers/auth_provider.dart';
import 'package:glpi_client_advanced/presentation/pages/login_page.dart';
import 'package:glpi_client_advanced/presentation/pages/home_page.dart';
import 'package:glpi_client_advanced/presentation/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager for desktop
  await windowManager.ensureInitialized();

  // Configure window options
  windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setTitle(AppConstants.appName);
  });

  runApp(
    const ProviderScope(
      child: GlpiClientApp(),
    ),
  );
}

class GlpiClientApp extends ConsumerWidget {
  const GlpiClientApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],

      // Navigation
      home: authState.isAuthenticated ? const HomePage() : const LoginPage(),
      onGenerateRoute: AppRouter.generateRoute,

      // Builder for responsive design
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },

      // Error handling
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const UnknownRoutePage(),
        );
      },
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
