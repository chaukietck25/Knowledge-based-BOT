// lib/data/models/conversation_item.dart
class ConversationItem {
  final String title;
  final String id;
  final int createdAt;

  ConversationItem({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    return ConversationItem(
      title: json['title'],
      id: json['id'],
      createdAt: json['createdAt'],
    );
  }
}