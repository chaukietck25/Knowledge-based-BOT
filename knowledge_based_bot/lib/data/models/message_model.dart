import 'package:knowledge_based_bot/data/models/assistant.dart';

class MessageModel {
  final String text;
  final bool isCurrentUser;
  final String sender;
  final Assistant? assistant;

  MessageModel({
    required this.text,
    required this.isCurrentUser,
    required this.sender,
    this.assistant,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'] ?? '',
      isCurrentUser: json['isCurrentUser'] ?? false,
      sender: json['sender'] ?? 'System',
      assistant: json['assistant'] != null
          ? Assistant.fromJson(json['assistant'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCurrentUser': isCurrentUser,
      'sender': sender,
      'assistant': assistant?.toJson(),
    };
  }
}
