// lib/presentation/widgets/empty_state_message.dart
import 'package:flutter/material.dart';

class EmptyStateMessage extends StatelessWidget {
  final String message;
  const EmptyStateMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) => Center(
      child: Text(message, style: Theme.of(context).textTheme.titleLarge));
}
