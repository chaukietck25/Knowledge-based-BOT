import 'package:flutter/material.dart';

class PromptTile extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onInfoPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onNavigatePressed;

  const PromptTile({
    Key? key,
    required this.title,
    required this.description,
    required this.onInfoPressed,
    required this.onFavoritePressed,
    required this.onNavigatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách giữa các ListTile
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        tileColor: Colors.white, // Đặt màu nền của ListTile là màu trắng
        subtitle: Text(description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: onInfoPressed,
            ),
            IconButton(
              icon: Icon(Icons.star_border),
              onPressed: onFavoritePressed,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: onNavigatePressed,
            ),
          ],
        ),
      ),
    );
  }
}