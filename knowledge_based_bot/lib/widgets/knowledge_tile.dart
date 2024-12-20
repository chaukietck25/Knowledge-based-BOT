import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class KnowledgeTile extends StatefulWidget {
  final String title;
  final String description;
  final String assistantId;
  final String knowledgeId;
  final Future<void> Function() onImportPressed; // Đã sửa
  final Future<void> Function() onDeleteFromAssistantPressed; // Đã sửa
  final Future<void> Function() onDeleteKnowledgePressed; // Thêm mới
  final VoidCallback onTapKnowledgeTile;

  const KnowledgeTile({
    Key? key,
    required this.title,
    required this.description,
    required this.assistantId,
    required this.knowledgeId,
    required this.onImportPressed,
    required this.onDeleteFromAssistantPressed,
    required this.onDeleteKnowledgePressed, // Thêm mới
    required this.onTapKnowledgeTile,
  }) : super(key: key);

  @override
  _KnowledgeTileState createState() => _KnowledgeTileState();
}

class _KnowledgeTileState extends State<KnowledgeTile> {
  bool isImporting = false;
  bool isDeletingFromAssistant = false;
  bool isDeletingKnowledge = false;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0), // Khoảng cách giữa các ListTile
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0), // Khoảng cách giữa title và description
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              onTap: widget.onTapKnowledgeTile,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nút Import
                  isImporting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(Icons.import_export),
                          tooltip: 'Import Knowledge into Assistant',
                          onPressed: () async {
                            setState(() {
                              isImporting = true;
                            });
                            await widget.onImportPressed(); // Đã sửa
                            setState(() {
                              isImporting = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Knowledge imported successfully'),
                              ),
                            );
                          },
                        ),
                  // Nút Delete from Assistant
                  isDeletingFromAssistant
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(Icons.remove_circle),
                          tooltip: 'Delete Knowledge from Assistant',
                          onPressed: () async {
                            setState(() {
                              isDeletingFromAssistant = true;
                            });
                            await widget.onDeleteFromAssistantPressed(); // Đã sửa
                            setState(() {
                              isDeletingFromAssistant = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Knowledge removed from assistant successfully'),
                              ),
                            );
                          },
                        ),
                  // Nút Delete Knowledge hoàn toàn
                  isDeletingKnowledge
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete_forever),
                          tooltip: 'Delete Knowledge Completely',
                          onPressed: () async {
                            setState(() {
                              isDeletingKnowledge = true;
                            });
                            await widget.onDeleteKnowledgePressed(); // Thêm mới
                            setState(() {
                              isDeletingKnowledge = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Knowledge deleted completely successfully'),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
