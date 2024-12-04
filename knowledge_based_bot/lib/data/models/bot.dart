// lib/data/models/bot.dart
class Bot {
  final String id;
  final String openAiAssistantId;
  final String description;
  final String instructions;
  final String assistantName;
  final String userId;
  final String openAiVectorStoreId;
  final String openAiThreadIdPlay;
  final bool isDefault;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? deletedAt;

  Bot({
    required this.id,
    required this.openAiAssistantId,
    required this.description,
    required this.instructions,
    required this.assistantName,
    required this.userId,
    required this.openAiVectorStoreId,
    required this.openAiThreadIdPlay,
    required this.isDefault,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'] ?? '',
      openAiAssistantId: json['openAiAssistantId'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
      assistantName: json['assistantName'] ?? '',
      userId: json['userId'] ?? '',
      openAiVectorStoreId: json['openAiVectorStoreId'] ?? '',
      openAiThreadIdPlay: json['openAiThreadIdPlay'] ?? '',
      isDefault: json['isDefault'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'openAiAssistantId': openAiAssistantId,
      'description': description,
      'instructions': instructions,
      'assistantName': assistantName,
      'userId': userId,
      'openAiVectorStoreId': openAiVectorStoreId,
      'openAiThreadIdPlay': openAiThreadIdPlay,
      'isDefault': isDefault,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }
}