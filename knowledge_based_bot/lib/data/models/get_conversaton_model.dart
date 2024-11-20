class ConversatonModel {
    
    ///The selected model's id
    AssistantId? assistantId;
    
    ///Always is "dify"
    AssistantModel assistantModel;
    
    ///search/filter data by cursor
    String? cursor;
    
    ///limit
    double? limit;

    ConversatonModel({
        this.assistantId,
        required this.assistantModel,
        this.cursor,
        this.limit,
    });

    ConversatonModel copyWith({
        AssistantId? assistantId,
        AssistantModel? assistantModel,
        String? cursor,
        double? limit,
    }) => 
        ConversatonModel(
            assistantId: assistantId ?? this.assistantId,
            assistantModel: assistantModel ?? this.assistantModel,
            cursor: cursor ?? this.cursor,
            limit: limit ?? this.limit,
        );
}


///The selected model's id
enum AssistantId {
    CLAUDE_35_SONNET_20240620,
    CLAUDE_3_HAIKU_20240307,
    GEMINI_15_FLASH_LATEST,
    GEMINI_15_PRO_LATEST,
    GPT_4_O,
    GPT_4_O_MINI
}


///Always is "dify"
enum AssistantModel {
    DIFY
}

