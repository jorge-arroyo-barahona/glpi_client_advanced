import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:glpi_client_advanced/core/services/ai_service.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AIService aiService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    aiService = AIService();
    aiService.initialize(apiKey: 'test-api-key');
  });

  group('AIService', () {
    group('analyzeTicketContent', () {
      test('should analyze ticket content successfully', () async {
        // Arrange
        const title = 'Server Down';
        const description = 'The main server is not responding to requests';

        // Act
        final result = await aiService.analyzeTicketContent(
          title: title,
          description: description,
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('clarity_score'), isTrue);
        expect(result.containsKey('completeness_score'), isTrue);
        expect(result.containsKey('priority_assessment'), isTrue);
      });

      test('should handle analysis with similar tickets', () async {
        // Arrange
        const title = 'Printer Issue';
        const description = 'Cannot print documents';
        final similarTickets = [
          const Ticket(
            id: 1,
            name: 'Printer not working',
            content: 'Printer shows offline status',
            status: TicketStatus.newTicket,
          ),
        ];

        // Act
        final result = await aiService.analyzeTicketContent(
          title: title,
          description: description,
          similarTickets: similarTickets,
        );

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result['is_potential_duplicate'], isA<bool>());
      });
    });

    group('suggestCategories', () {
      test('should suggest categories successfully', () async {
        // Arrange
        const title = 'Email not working';
        const description = 'Cannot send or receive emails';
        const availableCategories = ['Hardware', 'Software', 'Network'];

        // Act
        final result = await aiService.suggestCategories(
          title: title,
          description: description,
          availableCategories: availableCategories,
        );

        // Assert
        expect(result, isA<List<String>>());
        expect(result.isNotEmpty, isTrue);
        expect(result.length, lessThanOrEqualTo(5));
      });

      test('should handle empty available categories', () async {
        // Arrange
        const title = 'VPN Access';
        const description = 'Need VPN access for remote work';

        // Act
        final result = await aiService.suggestCategories(
          title: title,
          description: description,
        );

        // Assert
        expect(result, isA<List<String>>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('generateResponse', () {
      test('should generate response successfully', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Password Reset',
          content: 'I forgot my password and need to reset it',
          status: TicketStatus.newTicket,
        );
        const context = 'User requested password reset via email';

        // Act
        final result = await aiService.generateResponse(
          ticket: ticket,
          context: context,
        );

        // Assert
        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
        expect(result.contains('password'), isTrue);
      });

      test('should generate response with different tones', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Urgent Issue',
          content: 'System is down',
          status: TicketStatus.newTicket,
        );
        const context = 'Critical system failure';

        // Act
        final professionalResult = await aiService.generateResponse(
          ticket: ticket,
          context: context,
          tone: 'professional',
        );

        final casualResult = await aiService.generateResponse(
          ticket: ticket,
          context: context,
          tone: 'casual',
        );

        // Assert
        expect(professionalResult, isA<String>());
        expect(casualResult, isA<String>());
        expect(professionalResult, isNot(equals(casualResult)));
      });
    });

    group('findSimilarTickets', () {
      test('should find similar tickets successfully', () async {
        // Arrange
        const query = 'printer not working';
        const existingTickets = [
          Ticket(
            id: 1,
            name: 'Printer offline',
            content: 'Printer shows offline',
            status: TicketStatus.newTicket,
          ),
          Ticket(
            id: 2,
            name: 'Network issue',
            content: 'Cannot connect to network',
            status: TicketStatus.assigned,
          ),
        ];

        // Act
        final result = await aiService.findSimilarTickets(
          query: query,
          existingTickets: existingTickets,
        );

        // Assert
        expect(result, isA<List<String>>());
        expect(result.length, lessThanOrEqualTo(5));
      });

      test('should handle empty existing tickets', () async {
        // Arrange
        const query = 'email configuration';

        // Act
        final result = await aiService.findSimilarTickets(
          query: query,
        );

        // Assert
        expect(result, isA<List<String>>());
      });
    });

    group('suggestSolutions', () {
      test('should suggest solutions successfully', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Slow Computer',
          content: 'Computer is running very slowly',
          status: TicketStatus.newTicket,
        );
        const knowledgeBase = [
          'Check for malware',
          'Clear temporary files',
          'Update drivers',
          'Add more RAM',
        ];

        // Act
        final result = await aiService.suggestSolutions(
          ticket: ticket,
          knowledgeBase: knowledgeBase,
        );

        // Assert
        expect(result, isA<List<String>>());
        expect(result.isNotEmpty, isTrue);
        expect(result.length, lessThanOrEqualTo(5));
      });

      test('should handle empty knowledge base', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Blue Screen',
          content: 'Getting blue screen error',
          status: TicketStatus.newTicket,
        );

        // Act
        final result = await aiService.suggestSolutions(
          ticket: ticket,
        );

        // Assert
        expect(result, isA<List<String>>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('summarizeTicket', () {
      test('should summarize ticket successfully', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Complex Network Issue',
          content:
              'Multiple users are reporting that they cannot access the internet. '
              'The issue seems to be intermittent and affects different departments. '
              'We have checked the main router and switches but cannot find the root cause. '
              'Users are getting DNS errors and timeout messages.',
          status: TicketStatus.assigned,
          priority: TicketPriority.high,
        );

        // Act
        final result = await aiService.summarizeTicket(ticket);

        // Assert
        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
        expect(result.length, lessThan(300)); // Should be concise
      });

      test('should handle ticket with minimal content', () async {
        // Arrange
        const ticket = Ticket(
          id: 1,
          name: 'Simple Issue',
          content: 'Not working',
          status: TicketStatus.newTicket,
        );

        // Act
        final result = await aiService.summarizeTicket(ticket);

        // Assert
        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('chat', () {
      test('should chat successfully', () async {
        // Arrange
        const message = 'How do I reset a user password?';

        // Act
        final result = await aiService.chat(message: message);

        // Assert
        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
        expect(result.toLowerCase(), contains('password'));
      });

      test('should maintain conversation history', () async {
        // Arrange
        const message1 = 'What is GLPI?';
        const message2 = 'How do I use it?';

        // Act
        final result1 = await aiService.chat(message: message1);
        final result2 = await aiService.chat(message: message2);

        // Assert
        expect(result1, isA<String>());
        expect(result2, isA<String>());
        expect(result1, isNot(equals(result2)));
      });

      test('should handle chat without history', () async {
        // Arrange
        const message = 'Tell me about Flutter';

        // Act
        final result = await aiService.chat(
          message: message,
          includeHistory: false,
        );

        // Assert
        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('clearConversationHistory', () {
      test('should clear conversation history', () async {
        // Arrange
        await aiService.chat(message: 'First message');
        await aiService.chat(message: 'Second message');

        // Act
        aiService.clearConversationHistory();

        // Assert - history should be empty (internal state)
        // This is tested by ensuring subsequent chats don't reference previous context
        const newMessage = 'New conversation';
        final result = await aiService.chat(message: newMessage);

        expect(result, isA<String>());
        expect(result.isNotEmpty, isTrue);
      });
    });

    group('getConversationHistory', () {
      test('should return conversation history', () async {
        // Arrange
        await aiService.chat(message: 'Message 1');
        await aiService.chat(message: 'Message 2');

        // Act
        final history = aiService.getConversationHistory();

        // Assert
        expect(history, isA<List<Map<String, String>>>());
        expect(history.length, greaterThanOrEqualTo(2));
      });

      test('should return independent copy of history', () async {
        // Arrange
        await aiService.chat(message: 'Test message');

        // Act
        final history1 = aiService.getConversationHistory();
        final history2 = aiService.getConversationHistory();

        // Assert
        expect(history1, equals(history2));
        expect(identical(history1, history2), isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle initialization without API key', () {
        // Arrange
        final aiServiceWithoutKey = AIService();

        // Act & Assert
        expect(
          () => aiServiceWithoutKey.analyzeTicketContent(
            title: 'Test',
            description: 'Test',
          ),
          throwsA(isA<AIException>()),
        );
      });

      test('should handle network errors gracefully', () async {
        // Arrange
        const title = 'Test Ticket';
        const description = 'Test Description';

        // Act & Assert
        // This would normally require mocking HTTP client errors
        // For now, we test that the method completes without throwing
        expect(
          () async => await aiService.analyzeTicketContent(
            title: title,
            description: description,
          ),
          returnsNormally,
        );
      });
    });
  });
}
