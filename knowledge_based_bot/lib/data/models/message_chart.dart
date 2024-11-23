class Message {
  final String text;
  final String sender;
  final bool isCurrentUser;
  final String? timestamp;

  Message({
    required this.text,
    required this.sender,
    required this.isCurrentUser,
    this.timestamp,
  });
}