import 'package:flutter/material.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';
import 'package:glpi_client_advanced/presentation/pages/login_page.dart';
import 'package:glpi_client_advanced/presentation/pages/home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      
      case '/create-ticket':
        return MaterialPageRoute(
          builder: (_) => const CreateTicketPage(),
          settings: settings,
        );
      
      case '/ticket':
        final args = settings.arguments;
        if (args is Ticket) {
          return MaterialPageRoute(
            builder: (_) => TicketDetailPage(ticket: args),
            settings: settings,
          );
        }
        return _errorRoute();
      
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      
      default:
        if (settings.name?.startsWith('/ticket/') == true) {
          final ticketId = settings.name?.split('/').last;
          if (ticketId != null && int.tryParse(ticketId) != null) {
            return MaterialPageRoute(
              builder: (_) => TicketDetailPage(ticketId: int.parse(ticketId)),
              settings: settings,
            );
          }
        }
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class CreateTicketPage extends StatelessWidget {
  const CreateTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ticket'),
      ),
      body: const Center(
        child: Text('Create Ticket Page - Coming Soon'),
      ),
    );
  }
}

class TicketDetailPage extends StatelessWidget {
  final Ticket? ticket;
  final int? ticketId;

  const TicketDetailPage({
    super.key,
    this.ticket,
    this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${ticket?.id ?? ticketId ?? 'Unknown'}'),
      ),
      body: Center(
        child: Text('Ticket Detail Page - Coming Soon\n'
                   'Ticket: ${ticket?.name ?? 'Loading...'}'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Page - Coming Soon'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Page - Coming Soon'),
      ),
    );
  }
}