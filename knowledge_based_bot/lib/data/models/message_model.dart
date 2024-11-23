class MessageModel {
  final String text;
  final bool isCurrentUser;

  MessageModel({
    required this.text,
    required this.isCurrentUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      isCurrentUser: json['isCurrentUser'],
    );
  }
}