

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/store/knowledge_store.dart';
import 'package:knowledge_based_bot/widgets/knowledge_tile.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:knowledge_based_bot/views/knowledge_management/kb_screen.dart';

class KbDashboardScreen extends StatefulWidget {
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
    knowledgeStore.fetchKnowledge().then((value) {
      setState(() {
        isLoading = false;
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

    //print("result: $result");
    if (result == true) {
      // Nếu kết quả trả về là true, cập nhật lại dữ liệu
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledge'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Observer(builder: (_) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                              knowledgeStore.fetchKnowledge()
                                  .then((value) {
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
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Observer(builder: (context) {
                    var kbList = knowledgeStore.knowledgeList;
                    //print("refreshed");
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
                              onDeletePressed: () {
                                
                                setState(() {
                                  isLoading = true;
                                });
                                knowledgeStore
                                    .deleteKnowledge(knowledge.id)
                                    .then((value) {
                                  knowledgeStore.fetchKnowledge().then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                });
                              },
                              onTapKnowledgeTile: () {
                                //print("knowledge: ${knowledge.id}");
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
          // Handle create knowledge action
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
                    title: "Knowledge name",
                    hintText: "...",
                    controller: knowledgeNameController,
                  ),
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge description",
                    hintText: "...",
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
                knowledgeStore
                    .createKnowledge(knowledgeNameController.text,
                        knowledgeDescriptionController.text)
                    .then((value) {
                  Navigator.of(context).pop();
                });
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
