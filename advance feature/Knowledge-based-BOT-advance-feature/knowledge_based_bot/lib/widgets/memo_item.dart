import 'package:flutter/material.dart';

class MemoItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onTap;
  final bool isSelected;

  const MemoItem({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.onDelete,
    required this.onUpdate,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue[50] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onUpdate,
              tooltip: 'Update Bot',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete Bot',
            ),
          ],
        ),
      ),
    );
  }
}