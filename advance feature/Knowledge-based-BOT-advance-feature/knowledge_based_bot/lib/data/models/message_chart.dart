class Message {
  final String text;
  final String sender;
  final bool isCurrentUser;
  final String? timestamp;
  final Assistant? assistant;

  Message({
    required this.text,
    required this.sender,
    required this.isCurrentUser,
    this.timestamp,
    this.assistant,
  });
}

class Assistant {
  final String id;
  final String model;
  final String name;

  Assistant({
    required this.id,
    required this.model,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "model": model,
      "name": name,
    };
  }
}