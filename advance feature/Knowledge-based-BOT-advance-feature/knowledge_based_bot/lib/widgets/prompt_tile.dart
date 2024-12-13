// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PromptTile extends StatefulWidget {
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
  _PromptTileState createState() => _PromptTileState();
}

class _PromptTileState extends State<PromptTile> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoritePressed();
  }
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách giữa các ListTile
          child: ListTile(
            title: Text(
             widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            tileColor: Colors.white, // Đặt màu nền của ListTile là màu trắng
            subtitle: Text(widget.description),
            onTap:widget.onTapPromptTile,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: widget.onInfoPressed,
                ),
                IconButton(
                  icon: isFavorite? Icon(Icons.star_rate_rounded) : Icon(Icons.star_border_rounded),
                  onPressed: _toggleFavorite,
                ),
                // IconButton(
                //   icon: Icon(Icons.arrow_forward),
                //   onPressed: onNavigatePressed,
                // ),
              ],
            ),
          ),
        );
      }
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách giữa các ListTile
  //     child: ListTile(
  //       title: Text(
  //        widget.title,
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       tileColor: Colors.white, // Đặt màu nền của ListTile là màu trắng
  //       subtitle: Text(widget.description),
  //       onTap:widget.onTapPromptTile,
  //       trailing: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           IconButton(
  //             icon: Icon(Icons.info_outline),
  //             onPressed: widget.onInfoPressed,
  //           ),
  //           IconButton(
  //             icon: isFavorite? Icon(Icons.star_rate_rounded) : Icon(Icons.star_border_rounded),
  //             onPressed: _toggleFavorite,
  //           ),
  //           // IconButton(
  //           //   icon: Icon(Icons.arrow_forward),
  //           //   onPressed: onNavigatePressed,
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
