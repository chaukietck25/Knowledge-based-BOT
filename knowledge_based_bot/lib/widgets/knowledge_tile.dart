import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class KnowledgeTile extends StatefulWidget {
  final String title;
  final String description;
  final String assistantId;
  final String knowledgeId;
  final bool isImported; // New parameter
  final Future<void> Function() onImportPressed;
  final Future<void> Function() onDeleteFromAssistantPressed;
  final Future<void> Function() onDeleteKnowledgePressed;
  final VoidCallback onTapKnowledgeTile;

  const KnowledgeTile({
    Key? key,
    required this.title,
    required this.description,
    required this.assistantId,
    required this.knowledgeId,
    required this.isImported, // Initialize it
    required this.onImportPressed,
    required this.onDeleteFromAssistantPressed,
    required this.onDeleteKnowledgePressed,
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
          padding: const EdgeInsets.all(0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display V symbol if imported
                if (widget.isImported)
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
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
                      // Import Button
                      isImporting
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: Icon(Icons.import_export),
                              tooltip: 'Import Knowledge into Assistant',
                              onPressed: widget.isImported
                                  ? null // Disable if already imported
                                  : () async {
                                      setState(() {
                                        isImporting = true;
                                      });
                                      await widget.onImportPressed();
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
                      // Delete from Assistant Button
                      isDeletingFromAssistant
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              tooltip: 'Delete Knowledge from Assistant',
                              onPressed: widget.isImported
                                  ? () async {
                                      setState(() {
                                        isDeletingFromAssistant = true;
                                      });
                                      await widget.onDeleteFromAssistantPressed();
                                      setState(() {
                                        isDeletingFromAssistant = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Knowledge removed from assistant successfully'),
                                        ),
                                      );
                                    }
                                  : null, // Disable if not imported
                            ),
                      // Delete Knowledge Completely Button
                      isDeletingKnowledge
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: Icon(Icons.delete_forever, color: Colors.red),
                              tooltip: 'Delete Knowledge Completely',
                              onPressed: () async {
                                setState(() {
                                  isDeletingKnowledge = true;
                                });
                                await widget.onDeleteKnowledgePressed();
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
              ],
            ),
          ),
        );
      },
    );
  }
}
