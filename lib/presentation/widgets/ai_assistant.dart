import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glpi_client_advanced/core/constants/app_constants.dart';
import 'package:glpi_client_advanced/core/services/ai_service.dart';

class AIAssistant extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final Function(String)? onSuggestionSelected;

  const AIAssistant({
    super.key,
    this.onClose,
    this.onSuggestionSelected,
  });

  @override
  ConsumerState<AIAssistant> createState() => _AIAssistantState();
}

class _AIAssistantState extends ConsumerState<AIAssistant> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isStreaming = false;

  @override
  void initState() {
    super.initState();
    _aiService.initialize();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'type': 'ai',
        'content': 'Hello! I\'m your GLPI assistant. I can help you with:\n\n'
                   '• Analyzing ticket content\n'
                   '• Suggesting categories\n'
                   '• Finding similar tickets\n'
                   '• Generating responses\n'
                   '• Providing solutions\n\n'
                   'What would you like help with?',
        'timestamp': DateTime.now(),
      });
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'type': 'user',
        'content': message,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final response = await _aiService.chat(message: message);
      
      setState(() {
        _messages.add({
          'type': 'ai',
          'content': response,
          'timestamp': DateTime.now(),
        });
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'type': 'error',
          'content': 'Sorry, I encountered an error. Please try again.',
          'timestamp': DateTime.now(),
        });
        _isTyping = false;
      });
    }
  }

  void _streamMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'type': 'user',
        'content': message,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
      _isStreaming = true;
    });

    _scrollToBottom();

    try {
      // Add empty AI message for streaming
      setState(() {
        _messages.add({
          'type': 'ai',
          'content': '',
          'timestamp': DateTime.now(),
          'isStreaming': true,
        });
      });

      // Listen to streaming response
      _aiService.responseStream.listen(
        (chunk) {
          setState(() {
            final lastIndex = _messages.length - 1;
            if (lastIndex >= 0 && _messages[lastIndex]['isStreaming'] == true) {
              _messages[lastIndex]['content'] += chunk;
            }
          });
          _scrollToBottom();
        },
        onError: (error) {
          setState(() {
            _messages.add({
              'type': 'error',
              'content': 'Sorry, I encountered an error while streaming.',
              'timestamp': DateTime.now(),
            });
            _isStreaming = false;
          });
        },
        onDone: () {
          setState(() {
            final lastIndex = _messages.length - 1;
            if (lastIndex >= 0) {
              _messages[lastIndex]['isStreaming'] = false;
            }
            _isStreaming = false;
          });
        },
      );

      await _aiService.streamChatResponse(message: message);
    } catch (e) {
      setState(() {
        _messages.add({
          'type': 'error',
          'content': 'Sorry, I encountered an error. Please try again.',
          'timestamp': DateTime.now(),
        });
        _isStreaming = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearConversation() {
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
    _aiService.clearConversationHistory();
  }

  void _handleSuggestion(String suggestion) {
    _messageController.text = suggestion;
    if (widget.onSuggestionSelected != null) {
      widget.onSuggestionSelected!(suggestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 400,
      height: 600,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          const Divider(height: 1),
          Expanded(
            child: _buildMessageList(theme),
          ),
          const Divider(height: 1),
          _buildInputArea(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Icon(
            Icons.smart_toy,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI Assistant',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearConversation,
            tooltip: 'Clear conversation',
          ),
          if (widget.onClose != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onClose,
              tooltip: 'Close',
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator(theme);
        }

        final message = _messages[index];
        return _buildMessageItem(theme, message);
      },
    );
  }

  Widget _buildMessageItem(ThemeData theme, Map<String, dynamic> message) {
    final type = message['type'] as String;
    final content = message['content'] as String;
    final timestamp = message['timestamp'] as DateTime;
    final isStreaming = message['isStreaming'] == true;

    switch (type) {
      case 'user':
        return _buildUserMessage(theme, content, timestamp);
      case 'ai':
        return _buildAIMessage(theme, content, timestamp, isStreaming);
      case 'error':
        return _buildErrorMessage(theme, content, timestamp);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUserMessage(ThemeData theme, String content, DateTime timestamp) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Text(
                content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTime(timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMessage(ThemeData theme, String content, DateTime timestamp, bool isStreaming) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.smart_toy,
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (isStreaming)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: _buildTypingIndicator(theme, small: true),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTime(timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(ThemeData theme, String content, DateTime timestamp) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error,
                color: theme.colorScheme.onError,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTime(timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme, {bool small = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: small ? 6 : 8,
          height: small ? 6 : 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(small ? 3 : 4),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: small ? 6 : 8,
          height: small ? 6 : 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(small ? 3 : 4),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: small ? 6 : 8,
          height: small ? 6 : 8,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(small ? 3 : 4),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _isStreaming ? null : _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: _isStreaming
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                onPressed: _isStreaming ? null : _sendMessage,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickAction(theme, 'Analyze Ticket', Icons.analytics),
                const SizedBox(width: 8),
                _buildQuickAction(theme, 'Suggest Categories', Icons.category),
                const SizedBox(width: 8),
                _buildQuickAction(theme, 'Find Similar', Icons.search),
                const SizedBox(width: 8),
                _buildQuickAction(theme, 'Generate Response', Icons.edit),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(ThemeData theme, String label, IconData icon) {
    return InkWell(
      onTap: () => _handleSuggestion(label),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}