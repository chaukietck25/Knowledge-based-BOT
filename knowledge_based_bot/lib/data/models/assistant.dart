class Assistant {
  final String id; // UUID v4
  final String assistantName;
  final bool isDefault;
  String? openAiThreadIdPlay; // Made mutable to allow updates

  Assistant({
    required this.id,
    required this.assistantName,
    this.isDefault = true,
    this.openAiThreadIdPlay,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) {
    return Assistant(
      id: json['id'] ?? json['openAiAssistantId'] ?? '', // Kiểm tra tên trường từ API
      assistantName: json['assistantName'] ?? 'Unnamed Assistant', 
      isDefault: json['isDefault'] ?? false,
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
