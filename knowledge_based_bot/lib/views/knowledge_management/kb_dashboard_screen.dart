// lib/Views/knowledge_management/kb_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/store/knowledge_store.dart';
import 'package:knowledge_based_bot/widgets/knowledge_tile.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:knowledge_based_bot/views/knowledge_management/kb_screen.dart';
import '../../provider_state.dart';

import 'package:knowledge_based_bot/views/prompts library/prompts_library_screens.dart';

class KbDashboardScreen extends StatefulWidget {
  final String assistantId;
  final String openAiThreadId;

  const KbDashboardScreen({
    Key? key,
    required this.assistantId,
    required this.openAiThreadId,
  }) : super(key: key);

  @override
  _KbDashboardScreenState createState() => _KbDashboardScreenState();
}

class _KbDashboardScreenState extends State<KbDashboardScreen> {
  final KnowledgeStore knowledgeStore = KnowledgeStore();
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    knowledgeStore.fetchKnowledge().then((_) {
      knowledgeStore.fetchImportedKnowledges(widget.assistantId).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> _navigateToKbScreen(KnowledgeResDto knowledge) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KbScreen(knowledge: knowledge),
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });
      knowledgeStore.fetchKnowledge().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _importKnowledge(String knowledgeId) async {
    setState(() {
      isLoading = true;
    });
    await knowledgeStore.importKnowledge(
        widget.assistantId, knowledgeId).then((value) {
    setState(() {
      isLoading = false;
    });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Knowledge imported into assistant successfully')),
    );
  }

  // Phương thức Delete Knowledge từ Assistant
  Future<void> _deleteKnowledgeFromAssistant(String knowledgeId) async {
    setState(() {
      isLoading = true;
    });
    await knowledgeStore.deleteKnowledgeFromAssistant(
        widget.assistantId, knowledgeId).then((value) {
    setState(() {
      isLoading = false;
    });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Knowledge removed from assistant successfully')),
    );
  }

  // Inside kb_dashboard_screen.dart
  Future<void> _deleteKnowledge(String knowledgeId) async {
    bool confirm = await _showDeleteConfirmationDialog();
    if (!confirm) return;

    setState(() {
      isLoading = true;
    });
    await knowledgeStore.deleteKnowledge(
        widget.assistantId, knowledgeId).then((value) {
    setState(() {
      isLoading = false;
    });
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Knowledge deleted completely successfully')),
    // );
  }

  // Hộp thoại xác nhận xóa hoàn toàn
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
                'Are you sure you want to delete this knowledge completely? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Delete', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Knowledge Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Additional action buttons if needed
          
        ],
      ),
      body: Observer(builder: (_) {
        return Column(
          children: [
            // Search Bar and other widgets
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(241, 245, 249, 1),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // Handle search action
                              knowledgeStore
                                  .searchKnowledge(searchController.text);
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              searchController.clear();
                              knowledgeStore.fetchKnowledge().then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                          ),
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child:
                        Text('Search', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      knowledgeStore
                          .searchKnowledge(searchController.text)
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Observer(builder: (context) {
                    var kbList = knowledgeStore.knowledgeList;
                    if (kbList.isEmpty) {
                      return Center(child: Text('No knowledge found'));
                    }

                    return ListView.builder(
                      itemCount: kbList.length,
                      itemBuilder: (context, index) {
                        final knowledge = kbList[index];
                        return Column(
                          children: [
                            KnowledgeTile(
                              title: knowledge.knowledgeName,
                              description: knowledge.description,
                              assistantId: widget.assistantId,
                              knowledgeId: knowledge.id,
                              isImported: knowledgeStore.importedKnowledgeIds
                                  .contains(knowledge.id), // Updated line
                              onImportPressed: () =>
                                  _importKnowledge(knowledge.id),
                              onDeleteFromAssistantPressed: () =>
                                  _deleteKnowledgeFromAssistant(knowledge.id),
                              onDeleteKnowledgePressed: () =>
                                  _deleteKnowledge(knowledge.id),
                              onTapKnowledgeTile: () {
                                _navigateToKbScreen(knowledge);
                              },
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateKnowledgeDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Create Knowledge',
      ),
    );
  }

  void _showCreateKnowledgeDialog(BuildContext context) {
    TextEditingController knowledgeNameController = TextEditingController();
    TextEditingController knowledgeDescriptionController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Knowledge'),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.7, // Đặt chiều rộng mong muốn
            height: MediaQuery.of(context).size.height *
                0.5, // Đặt chiều cao mong muốn
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge Name",
                    hintText: "Enter knowledge name",
                    controller: knowledgeNameController,
                  ),
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge Description",
                    hintText: "Enter knowledge description",
                    controller: knowledgeDescriptionController,
                    maxlines: 4,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Thực hiện tạo kiến thức mới
                String name = knowledgeNameController.text.trim();
                String description = knowledgeDescriptionController.text.trim();
                if (name.isNotEmpty && description.isNotEmpty) {
                  Navigator.of(context).pop();
                  setState(() {
                    isLoading = true;
                  });
                  knowledgeStore
                      .createKnowledge(name, description)
                      .then((value) {
                    knowledgeStore.fetchKnowledge().then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  });
                } else {
                  // Hiển thị thông báo lỗi nếu chưa nhập đủ thông tin
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter both name and description')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
