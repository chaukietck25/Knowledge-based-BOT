// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PromptTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isFavorite;
  final VoidCallback onInfoPressed;
  final VoidCallback onFavoritePressed;
  final VoidCallback onNavigatePressed;
  final VoidCallback onTapPromptTile;

  const PromptTile({
    Key? key,
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.onInfoPressed,
    required this.onFavoritePressed,
    required this.onNavigatePressed,
    required this.onTapPromptTile,
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
        onTap: onTapPromptTile,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: onInfoPressed,
            ),
            IconButton(
              icon: isFavorite? Icon(Icons.star_rate_rounded) : Icon(Icons.star_border_rounded),
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
