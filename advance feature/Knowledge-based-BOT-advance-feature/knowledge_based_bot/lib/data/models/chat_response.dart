class ChatResponse {
  final String? conversationId;
  final String message;
  final int remainingUsage;
  final String? openAiThreadIdPlay; // Add if the response includes this

  ChatResponse({
    this.conversationId,
    required this.message,
    required this.remainingUsage,
    this.openAiThreadIdPlay,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversationId: json['conversationId'],
      message: json['message'] ?? '',
      remainingUsage: json['remainingUsage'] ?? 0,
      openAiThreadIdPlay: json['openAiThreadIdPlay'], // Handle if present
    );
  }
}
