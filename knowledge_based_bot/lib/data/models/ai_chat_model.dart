
///AiChatDto
class AiChatModel {
    AssistantDto? assistant;
    String content;
    List<String>? files;
    AiChatMetadata? metadata;

    AiChatModel({
        this.assistant,
        required this.content,
        this.files,
        this.metadata,
    });

    AiChatModel copyWith({
        AssistantDto? assistant,
        String? content,
        List<String>? files,
        AiChatMetadata? metadata,
    }) => 
        AiChatModel(
            assistant: assistant ?? this.assistant,
            content: content ?? this.content,
            files: files ?? this.files,
            metadata: metadata ?? this.metadata,
        );
}


///AssistantDto
class AssistantDto {
    Id? id;
    Model model;

    AssistantDto({
        this.id,
        required this.model,
    });

    AssistantDto copyWith({
        Id? id,
        Model? model,
    }) => 
        AssistantDto(
            id: id ?? this.id,
            model: model ?? this.model,
        );
}

enum Id {
    CLAUDE_3_HAIKU_20240307,
    CLAUDE_3_SONNET_20240229,
    GEMINI_15_FLASH_LATEST,
    GEMINI_15_PRO_LATEST,
    GPT_4_O,
    GPT_4_O_MINI
}

enum Model {
    DIFY
}


///AiChatMetadata
class AiChatMetadata {
    ChatConversation conversation;

    AiChatMetadata({
        required this.conversation,
    });

    AiChatMetadata copyWith({
        ChatConversation? conversation,
    }) => 
        AiChatMetadata(
            conversation: conversation ?? this.conversation,
        );
}


///ChatConversation
class ChatConversation {
    String id;
    List<ChatMessage> messages;

    ChatConversation({
        required this.id,
        required this.messages,
    });

    ChatConversation copyWith({
        String? id,
        List<ChatMessage>? messages,
    }) => 
        ChatConversation(
            id: id ?? this.id,
            messages: messages ?? this.messages,
        );
}


///ChatMessage
class ChatMessage {
    AssistantDto assistant;
    String content;
    List<String> files;
    String role;

    ChatMessage({
        required this.assistant,
        required this.content,
        required this.files,
        required this.role,
    });

    ChatMessage copyWith({
        AssistantDto? assistant,
        String? content,
        List<String>? files,
        String? role,
    }) => 
        ChatMessage(
            assistant: assistant ?? this.assistant,
            content: content ?? this.content,
            files: files ?? this.files,
            role: role ?? this.role,
        );
}

