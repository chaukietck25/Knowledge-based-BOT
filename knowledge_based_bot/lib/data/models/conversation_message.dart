// lib\data\models\conversation_message.dart
class ConversationMessage {
  final String query;
  final String answer;
  final int createdAt;
  final List<dynamic> files;

  ConversationMessage({
    required this.query,
    required this.answer,
    required this.createdAt,
    required this.files,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      query: json['query'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      files: json['files'] ?? [],
    );
  }
}