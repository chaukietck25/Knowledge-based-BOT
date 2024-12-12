// lib/data/models/assistant.dart

class Assistant {
  final String id;
  final String assistantName;

  Assistant({required this.id, required this.assistantName});

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['openAiAssistantId'] ?? json['id'],
      assistantName: json['assistantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assistantName': assistantName,
    };
  }
}