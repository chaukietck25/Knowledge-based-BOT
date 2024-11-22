class ChatResponse {
    String conversationId;
    String message;
    int remainingUsage;

    ChatResponse({
        required this.conversationId,
        required this.message,
        required this.remainingUsage,
    });

    ChatResponse copyWith({
        String? conversationId,
        String? message,
        int? remainingUsage,
    }) => 
        ChatResponse(
            conversationId: conversationId ?? this.conversationId,
            message: message ?? this.message,
            remainingUsage: remainingUsage ?? this.remainingUsage,
        );
}