// lib/data/models/response_chat.dart
class ChatResponse {
  String? conversationId;
  String message;
  int? remainingUsage;

  ChatResponse({
    this.conversationId,
    required this.message,
    this.remainingUsage,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversationId'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }
}