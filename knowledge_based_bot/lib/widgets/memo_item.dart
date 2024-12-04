import 'package:flutter/material.dart';

class MemoItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback? onTap;
  final bool isSelected; // Add isSelected

  const MemoItem({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.onDelete,
    required this.onUpdate,
    this.onTap,
    this.isSelected = false, // Default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.blue[50],
      title: Text(title),
      subtitle: Text(description),
      trailing: Text(time),
      onTap: onTap,
      onLongPress: () {
        // Optionally handle long press if needed
      },
      // You can add additional actions or widgets here
    );
  }
}