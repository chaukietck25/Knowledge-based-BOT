// lib/widgets/memo_item.dart
import 'package:flutter/material.dart';

class MemoItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const MemoItem({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 206, 230, 218),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onUpdate,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: () {
          // Optional: Handle tap if needed
        },
      ),
    );
  }
}