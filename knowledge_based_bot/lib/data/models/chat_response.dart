// lib/data/models/chat_response.dart
class ChatResponse {
  final String? conversationId;
  final String message;
  final int remainingUsage;

  ChatResponse({
    this.conversationId,
    required this.message,
    required this.remainingUsage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversationId'],
      message: json['message'] ?? '',
      remainingUsage: json['remainingUsage'] ?? 0,
    );
  }
}