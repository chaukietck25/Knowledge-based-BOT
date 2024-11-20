class ResponseConversationHistory {
    String cursor;
    bool hasMore;
    List<ConversationHistoryItem> items;
    int limit;

    ResponseConversationHistory({
        required this.cursor,
        required this.hasMore,
        required this.items,
        required this.limit,
    });

    ResponseConversationHistory copyWith({
        String? cursor,
        bool? hasMore,
        List<ConversationHistoryItem>? items,
        int? limit,
    }) => 
        ResponseConversationHistory(
            cursor: cursor ?? this.cursor,
            hasMore: hasMore ?? this.hasMore,
            items: items ?? this.items,
            limit: limit ?? this.limit,
        );
}

class ConversationHistoryItem {
    String? answer;
    int? createdAt;
    List<String>? files;
    String? query;

    ConversationHistoryItem({
        this.answer,
        this.createdAt,
        this.files,
        this.query,
    });

    ConversationHistoryItem copyWith({
        String? answer,
        int? createdAt,
        List<String>? files,
        String? query,
    }) => 
        ConversationHistoryItem(
            answer: answer ?? this.answer,
            createdAt: createdAt ?? this.createdAt,
            files: files ?? this.files,
            query: query ?? this.query,
        );
}