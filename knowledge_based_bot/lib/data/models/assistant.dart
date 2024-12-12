// lib/data/models/assistant.dart
class Assistant {
  final String id; // UUID v4
  final String assistantName;
  final bool isDefault;
  String? openAiThreadIdPlay; // Made mutable to allow updates

  Assistant({
    required this.id,
    required this.assistantName,
    this.isDefault = true, // Defaults to true for default assistants
    this.openAiThreadIdPlay,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'] ?? json['openAiAssistantId'] ?? '', // Corrected assignment
      assistantName: json['assistantName'] ?? 'Unnamed Assistant',
      isDefault: json['isDefault'] ?? false, // Assuming non-default by default
      openAiThreadIdPlay: json['openAiThreadIdPlay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assistantName': assistantName,
      'isDefault': isDefault,
      'openAiThreadIdPlay': openAiThreadIdPlay,
    };
  }
}
