import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/errors/exceptions.dart';
import 'package:glpi_client_advanced/domain/entities/ticket.dart';

class AIService {
  static final AIService _instance = AIService._internal();

  factory AIService() => _instance;

  AIService._internal();

  String? _apiKey;
  String _baseUrl = AppConstants.aiBaseUrl;
  String _model = AppConstants.aiModel;

  // Conversation history for context
  final List<Map<String, String>> _conversationHistory = [];

  // Stream controller for real-time responses
  final StreamController<String> _responseController =
      StreamController<String>.broadcast();

  // Public stream
  Stream<String> get responseStream => _responseController.stream;

  // Initialize AI service
  void initialize({String? apiKey, String? baseUrl, String? model}) {
    _apiKey = apiKey ?? AppConstants.aiApiKey;
    _baseUrl = baseUrl ?? AppConstants.aiBaseUrl;
    _model = model ?? AppConstants.aiModel;

    if (_apiKey == null || _apiKey!.isEmpty) {
      throw AIException('API key is required for AI service');
    }
  }

  // Analyze ticket content and suggest improvements
  Future<Map<String, dynamic>> analyzeTicketContent({
    required String title,
    required String description,
    List<Ticket>? similarTickets,
  }) async {
    try {
      final prompt = _buildTicketAnalysisPrompt(
        title: title,
        description: description,
        similarTickets: similarTickets,
      );

      final response = await _sendRequest(prompt);

      return _parseTicketAnalysisResponse(response);
    } catch (e) {
      throw AIException('Failed to analyze ticket content: ${e.toString()}');
    }
  }

  // Suggest ticket category based on content
  Future<List<String>> suggestCategories({
    required String title,
    required String description,
    List<String> availableCategories = const [],
  }) async {
    try {
      final prompt = _buildCategorySuggestionPrompt(
        title: title,
        description: description,
        availableCategories: availableCategories,
      );

      final response = await _sendRequest(prompt);

      return _parseCategorySuggestions(response);
    } catch (e) {
      throw AIException('Failed to suggest categories: ${e.toString()}');
    }
  }

  // Generate response for customer
  Future<String> generateResponse({
    required Ticket ticket,
    required String context,
    String tone = 'professional',
  }) async {
    try {
      final prompt = _buildResponseGenerationPrompt(
        ticket: ticket,
        context: context,
        tone: tone,
      );

      final response = await _sendRequest(prompt);

      return _extractContent(response);
    } catch (e) {
      throw AIException('Failed to generate response: ${e.toString()}');
    }
  }

  // Search for similar tickets
  Future<List<String>> findSimilarTickets({
    required String query,
    List<Ticket> existingTickets = const [],
    int maxResults = 5,
  }) async {
    try {
      final prompt = _buildSimilaritySearchPrompt(
        query: query,
        existingTickets: existingTickets,
        maxResults: maxResults,
      );

      final response = await _sendRequest(prompt);

      return _parseSimilarTicketsResponse(response);
    } catch (e) {
      throw AIException('Failed to find similar tickets: ${e.toString()}');
    }
  }

  // Provide solution suggestions
  Future<List<String>> suggestSolutions({
    required Ticket ticket,
    List<String> knowledgeBase = const [],
  }) async {
    try {
      final prompt = _buildSolutionSuggestionPrompt(
        ticket: ticket,
        knowledgeBase: knowledgeBase,
      );

      final response = await _sendRequest(prompt);

      return _parseSolutionSuggestions(response);
    } catch (e) {
      throw AIException('Failed to suggest solutions: ${e.toString()}');
    }
  }

  // Summarize ticket content
  Future<String> summarizeTicket(Ticket ticket) async {
    try {
      final prompt = _buildSummarizationPrompt(ticket);

      final response = await _sendRequest(prompt);

      return _extractContent(response);
    } catch (e) {
      throw AIException('Failed to summarize ticket: ${e.toString()}');
    }
  }

  // Chat with AI assistant
  Future<String> chat({
    required String message,
    bool includeHistory = true,
  }) async {
    try {
      if (includeHistory) {
        _conversationHistory.add({'role': 'user', 'content': message});
      }

      final response = await _sendChatRequest(
        includeHistory
            ? _conversationHistory
            : [
                {'role': 'user', 'content': message}
              ],
      );

      final aiResponse = _extractContent(response);

      if (includeHistory) {
        _conversationHistory.add({'role': 'assistant', 'content': aiResponse});

        // Keep only last 20 messages to prevent memory issues
        if (_conversationHistory.length > 20) {
          _conversationHistory.removeRange(0, _conversationHistory.length - 20);
        }
      }

      return aiResponse;
    } catch (e) {
      throw AIException('Failed to chat with AI: ${e.toString()}');
    }
  }

  // Stream AI response in real-time
  Future<void> streamChatResponse({
    required String message,
    bool includeHistory = true,
  }) async {
    try {
      final messages = includeHistory
          ? [
              ..._conversationHistory,
              {'role': 'user', 'content': message}
            ]
          : [
              {'role': 'user', 'content': message}
            ];

      await _sendStreamingChatRequest(messages);
    } catch (e) {
      throw AIException('Failed to stream AI response: ${e.toString()}');
    }
  }

  // Clear conversation history
  void clearConversationHistory() {
    _conversationHistory.clear();
  }

  // Get conversation history
  List<Map<String, String>> getConversationHistory() {
    return List.from(_conversationHistory);
  }

  // Private methods
  String _buildTicketAnalysisPrompt({
    required String title,
    required String description,
    List<Ticket>? similarTickets,
  }) {
    var prompt =
        '''Analyze the following ticket and provide suggestions for improvement:

Title: $title
Description: $description

Please analyze:
1. Clarity and completeness of the ticket
2. Missing information that would help resolution
3. Priority assessment
4. Category suggestions
5. Potential duplicate detection''';

    if (similarTickets != null && similarTickets.isNotEmpty) {
      prompt += '\n\nSimilar tickets found:\n';
      for (var i = 0; i < similarTickets.length && i < 3; i++) {
        prompt +=
            '${i + 1}. ${similarTickets[i].name} (ID: ${similarTickets[i].id})\n';
      }
    }

    prompt += '''

Please provide your analysis in JSON format with the following structure:
{
  "clarity_score": 1-10,
  "completeness_score": 1-10,
  "missing_info": ["list", "of", "missing", "information"],
  "priority_assessment": "low|medium|high|critical",
  "category_suggestions": ["suggested", "categories"],
  "is_potential_duplicate": true|false,
  "duplicate_tickets": ["ticket_ids"],
  "improvement_suggestions": ["suggestions"]
}''';

    return prompt;
  }

  String _buildCategorySuggestionPrompt({
    required String title,
    required String description,
    List<String> availableCategories = const [],
  }) {
    var prompt =
        '''Based on the following ticket content, suggest the most appropriate categories:

Title: $title
Description: $description

''';

    if (availableCategories.isNotEmpty) {
      prompt += 'Available categories: ${availableCategories.join(', ')}\n\n';
    }

    prompt +=
        'Please suggest 3-5 most relevant categories in order of relevance.';

    return prompt;
  }

  String _buildResponseGenerationPrompt({
    required Ticket ticket,
    required String context,
    String tone = 'professional',
  }) {
    return '''Generate a response for the following ticket:

Ticket: ${ticket.name}
Description: ${ticket.content ?? 'No description'}
Status: ${ticket.status?.toString() ?? 'Unknown'}
Priority: ${ticket.priority?.toString() ?? 'Unknown'}

Context: $context

Please generate a ${tone} response that:
1. Acknowledges the issue
2. Provides relevant information or next steps
3. Maintains a ${tone} tone
4. Is helpful and professional

Response:''';
  }

  String _buildSimilaritySearchPrompt({
    required String query,
    List<Ticket> existingTickets = const [],
    int maxResults = 5,
  }) {
    var prompt = '''Find tickets similar to: "$query"

''';

    if (existingTickets.isNotEmpty) {
      prompt += 'Existing tickets to search through:\n';
      for (var ticket in existingTickets) {
        prompt +=
            'ID: ${ticket.id}, Title: ${ticket.name}, Status: ${ticket.status}\n';
      }
      prompt += '\n';
    }

    prompt +=
        'Please identify the $maxResults most similar tickets based on title and content similarity.';

    return prompt;
  }

  String _buildSolutionSuggestionPrompt({
    required Ticket ticket,
    List<String> knowledgeBase = const [],
  }) {
    var prompt = '''Suggest solutions for the following ticket:

Ticket: ${ticket.name}
Description: ${ticket.content ?? 'No description'}
Category: ${ticket.itilcategoriesId ?? 'Unknown'}
Status: ${ticket.status?.toString() ?? 'Unknown'}

''';

    if (knowledgeBase.isNotEmpty) {
      prompt += 'Available knowledge base articles:\n';
      for (var i = 0; i < knowledgeBase.length && i < 5; i++) {
        prompt += '${i + 1}. ${knowledgeBase[i]}\n';
      }
      prompt += '\n';
    }

    prompt +=
        'Please suggest 3-5 potential solutions or troubleshooting steps.';

    return prompt;
  }

  String _buildSummarizationPrompt(Ticket ticket) {
    return '''Summarize the following ticket in 2-3 sentences:

Title: ${ticket.name}
Description: ${ticket.content ?? 'No description'}
Status: ${ticket.status?.toString() ?? 'Unknown'}
Priority: ${ticket.priority?.toString() ?? 'Unknown'}
Date: ${ticket.date?.toString() ?? 'Unknown'}

Summary:''';
  }

  Future<Map<String, dynamic>> _sendRequest(String prompt) async {
    if (_apiKey == null) {
      throw AIException('AI service not initialized');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    );
    if (response.statusCode != 200) {
      throw AIException(
          'API request failed: ${response.statusCode} ${response.body}');
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> _sendChatRequest(
      List<Map<String, String>> messages) async {
    if (_apiKey == null) {
      throw AIException('AI service not initialized');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'max_tokens': 1000,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw AIException(
          'API request failed: ${response.statusCode} ${response.body}');
    }

    return jsonDecode(response.body);
  }

  Future<void> _sendStreamingChatRequest(
      List<Map<String, String>> messages) async {
    if (_apiKey == null) {
      throw AIException('AI service not initialized');
    }

    final request =
        http.Request('POST', Uri.parse('$_baseUrl/chat/completions'))
          ..headers.addAll({
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          })
          ..body = jsonEncode({
            'model': _model,
            'messages': messages,
            'max_tokens': 1000,
            'temperature': 0.7,
            'stream': true,
          });

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200) {
      throw AIException(
          'Streaming request failed: ${streamedResponse.statusCode}');
    }

    await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
      final lines = chunk.split('\n');
      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') continue;

          try {
            final jsonData = jsonDecode(data);
            final content = jsonData['choices']?[0]?['delta']?['content'] ?? '';
            if (content.isNotEmpty) {
              _responseController.add(content);
            }
          } catch (e) {
            // Skip invalid JSON
          }
        }
      }
    }
  }

  String _extractContent(Map<String, dynamic> response) {
    try {
      return response['choices']?[0]?['message']?['content'] ?? '';
    } catch (e) {
      throw AIException('Invalid response format');
    }
  }

  Map<String, dynamic> _parseTicketAnalysisResponse(String response) {
    try {
      // Try to extract JSON from the response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;

      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonString = response.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonString);
      }
    } catch (e) {
      // Fall back to default structure
    }

    return {
      'clarity_score': 5,
      'completeness_score': 5,
      'missing_info': [],
      'priority_assessment': 'medium',
      'category_suggestions': [],
      'is_potential_duplicate': false,
      'duplicate_tickets': [],
      'improvement_suggestions': ['Unable to parse AI response'],
    };
  }

  List<String> _parseCategorySuggestions(String response) {
    // Extract category suggestions from the response
    final lines = response.split('\n');
    final categories = <String>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty &&
          !trimmed.startsWith('Please') &&
          !trimmed.startsWith('Based')) {
        // Remove numbering and extra characters
        final category = trimmed.replaceAll(RegExp(r'^\d+\.\s*'), '').trim();
        if (category.isNotEmpty) {
          categories.add(category);
        }
      }
    }

    return categories;
  }

  List<String> _parseSimilarTicketsResponse(String response) {
    // Extract ticket IDs from the response
    final ticketIds = <String>[];
    final matches = RegExp(r'ID:\s*(\d+)').allMatches(response);

    for (final match in matches) {
      ticketIds.add(match.group(1)!);
    }

    return ticketIds;
  }

  List<String> _parseSolutionSuggestions(String response) {
    // Extract solution suggestions
    final solutions = <String>[];
    final lines = response.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty &&
          !trimmed.startsWith('Please') &&
          !trimmed.startsWith('Suggest') &&
          !trimmed.startsWith('Ticket:')) {
        solutions.add(trimmed);
      }
    }

    return solutions;
  }

  // Dispose resources
  void dispose() {
    _responseController.close();
  }
}
