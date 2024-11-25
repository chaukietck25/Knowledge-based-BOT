class ResponseConversation {
    String cursor;
    bool hasMore;
    List<ConversationItem> items;
    int limit;

    ResponseConversation({
        required this.cursor,
        required this.hasMore,
        required this.items,
        required this.limit,
    });

    ResponseConversation copyWith({
        String? cursor,
        bool? hasMore,
        List<ConversationItem>? items,
        int? limit,
    }) => 
        ResponseConversation(
            cursor: cursor ?? this.cursor,
            hasMore: hasMore ?? this.hasMore,
            items: items ?? this.items,
            limit: limit ?? this.limit,
        );

    factory ResponseConversation.fromJson(Map<String, dynamic> json) => ResponseConversation(
        cursor: json['cursor'],
        hasMore: json['has_more'],
        items: List<ConversationItem>.from(json['items'].map((x) => ConversationItem.fromJson(x))),
        limit: json['limit'],
    );

}

class ConversationItem {
    int? createdAt;
    String? id;
    String? title;

    ConversationItem({
        this.createdAt,
        this.id,
        this.title,
    });

    ConversationItem copyWith({
        int? createdAt,
        String? id,
        String? title,
    }) => 
        ConversationItem(
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
            title: title ?? this.title,
        );
    
    factory ConversationItem.fromJson(Map<String, dynamic> json) => ConversationItem(
        createdAt: json['createdAt'],
        id: json['id'],
        title: json['title'],
    );
}