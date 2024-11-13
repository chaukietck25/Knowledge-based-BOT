import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BotScreen extends StatelessWidget {

  final List<Celebrity> celebrities = [
    Celebrity(
        name: "Dwayne Johnson",
        description:
            "A powerhouse of charisma and strength, you're a master builder of dreams.",
        avatarUrl: '',
        teamName: 'By Team',
        commentsCount: '10K+'),
    Celebrity(
        name: "Ariana Grande",
        description:
            "Ariana Grande — the cosmic chanteuse, drifting somewhere between the notes.",
        avatarUrl: '',
        teamName: 'By Team',
        commentsCount: '29K+'),
    Celebrity(
        name: "Kim Kardashian",
        description:
            "A celestial force of glamour and ambition, Kim navigates the cosmos with style.",
        avatarUrl: '',
        teamName: 'By Team',
        commentsCount: '30K+'),
    Celebrity(
        name: "Selena Gomez",
        description:
            "A cosmic mix of grace and charisma, Selena dances through the universe with poise.",
        avatarUrl: '',
        teamName: 'By Team',
        commentsCount: '6K+'),
    Celebrity(
        name: "Elon Musk",
        description:
            "Innovator with boundless ambition, surfing on the waves of technological progress.",
        avatarUrl: '',
        teamName: 'By Team',
        commentsCount: '12K+'),
  ];

  final List<String> categories = [
    'Celebrity',
    'My Bots',
    'Tops',
    'Models',
    'Productivity',
    'Developer'
  ];

  BotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bots"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            // label: const Text("Create"),
            label: const Text("Tạo"),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextField(
              decoration: const InputDecoration(
                // hintText: 'Search',
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              onChanged: (value) {
                // Add search logic here
              },
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.all(8.0),
                    child: Text(category),
                    ),
                  );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: celebrities.length,
              itemBuilder: (context, index) {
                final celeb = celebrities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(celeb.avatarUrl),
                  ),
                  title: Text(celeb.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(celeb.description),
                      Row(
                        children: [
                          Icon(Icons.person_2_outlined, size: 16),
                          SizedBox(width: 8),
                          Text(celeb.teamName),
                          SizedBox(width: 16),
                          Icon(Icons.comment, size: 16),
                          SizedBox(width: 4),
                          Text(celeb.commentsCount),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Celebrity {
  final String name;
  final String description;
  final String avatarUrl;
  final String teamName;
  final String commentsCount;

  Celebrity({
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.teamName,
    required this.commentsCount,
  });
}
