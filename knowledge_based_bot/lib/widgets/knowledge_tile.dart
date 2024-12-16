// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class KnowledgeTile extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onDeletePressed;
  final VoidCallback onTapKnowledgeTile;

  const KnowledgeTile({
    Key? key,
    required this.title,
    required this.description,
    required this.onDeletePressed,
    required this.onTapKnowledgeTile,
  }) : super(key: key);

   @override
  _KnowledgeTileState createState() => _KnowledgeTileState();
}

class _KnowledgeTileState extends State<KnowledgeTile> {

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0), // Thêm khoảng cách giữa các ListTile
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                left: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                right: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                )

              ),
            ),
            child: ListTile(
              
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0), // Tăng khoảng cách giữa title và subtitle
                  Text(widget.description, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic) ),
                ],
              ),
              //tileColor: Colors.white, // Đặt màu nền của ListTile là màu trắng
              //subtitle: Text(widget.description),
              onTap:widget.onTapKnowledgeTile,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDeletePressed,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  
}
