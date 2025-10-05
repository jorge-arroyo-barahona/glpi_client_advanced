import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/presentation/providers/auth_provider.dart';
import 'package:glpi_client_advanced/presentation/widgets/loading_indicator.dart';
import 'package:glpi_client_advanced/presentation/widgets/error_message.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _appTokenController = TextEditingController();
  final _userTokenController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _useUserToken = true;

  @override
  void initState() {
    super.initState();
    // Load saved app token if available
    _loadSavedAppToken();
  }

  @override
  void dispose() {
    _appTokenController.dispose();
    _userTokenController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedAppToken() async {
    final savedToken = await ref.read(sharedPreferencesHelperProvider).getAppToken();
    if (savedToken != null) {
      _appTokenController.text = savedToken;
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appToken = _appTokenController.text.trim();
    
    if (_useUserToken) {
      final userToken = _userTokenController.text.trim();
      if (userToken.isNotEmpty) {
        await ref.read(authProvider.notifier).login(
          appToken: appToken,
          userToken: userToken,
        );
      }
    } else {
      final login = _loginController.text.trim();
      final password = _passwordController.text.trim();
      if (login.isNotEmpty && password.isNotEmpty) {
        await ref.read(authProvider.notifier).login(
          appToken: appToken,
          login: login,
          password: password,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    // Navigate to home if authenticated
    if (authState.isAuthenticated) {
      Future.microtask(() {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title
                    Icon(
                      Icons.work_outline,
                      size: 80,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'GLPI Client',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Advanced Multiplatform Client',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding * 3),
                    
                    // App Token Field
                    TextFormField(
                      controller: _appTokenController,
                      decoration: InputDecoration(
                        labelText: 'App Token',
                        hintText: 'Enter your GLPI App Token',
                        prefixIcon: const Icon(Icons.key),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'App token is required';
                        }
                        return null;
                      },
                      enabled: !authState.isLoading,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    // Authentication Method Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _useUserToken = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _useUserToken
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                                ),
                                child: Text(
                                  'User Token',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: _useUserToken
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                    fontWeight: _useUserToken ? FontWeight.bold : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _useUserToken = false;
                                });
                              },
                              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_useUserToken
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                                ),
                                child: Text(
                                  'Username/Password',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: !_useUserToken
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurface,
                                    fontWeight: !_useUserToken ? FontWeight.bold : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    // User Token or Login Fields
                    if (_useUserToken) ...[
                      TextFormField(
                        controller: _userTokenController,
                        decoration: InputDecoration(
                          labelText: 'User Token',
                          hintText: 'Enter your GLPI User Token',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'User token is required';
                          }
                          return null;
                        },
                        enabled: !authState.isLoading,
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _loginController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your GLPI username',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                        enabled: !authState.isLoading,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your GLPI password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        enabled: !authState.isLoading,
                      ),
                    ],
                    const SizedBox(height: AppConstants.defaultPadding * 2),
                    
                    // Login Button
                    ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                        ),
                      ),
                      child: authState.isLoading
                          ? const LoadingIndicator(size: 24)
                          : const Text('Login'),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    // Error Message
                    if (authState.error != null)
                      ErrorMessage(
                        message: authState.error!.message,
                        details: authState.error!.details,
                        showIcon: false,
                      ),
                    
                    // Version Info
                    const SizedBox(height: AppConstants.defaultPadding * 2),
                    Text(
                      'Version ${AppConstants.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}