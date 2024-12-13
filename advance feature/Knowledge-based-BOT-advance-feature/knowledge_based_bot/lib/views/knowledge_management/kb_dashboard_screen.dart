import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';

import './kb_screen.dart';



class KbDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledge'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ElevatedButton(
          //     child: Text('Create Knowledge',
          //         style: TextStyle(color: Colors.white)),
          //     onPressed: () {
          //       // Handle create knowledge action
          //       _showCreateKnowledgeDialog(context);
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.blue,
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Expanded(
                //   child: TextField(
                //     decoration: InputDecoration(
                //       labelText: 'Search',
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 8),
                // ElevatedButton(
                //   onPressed: () {
                //     // Handle create knowledge action
                //   },
                //   child: Text('Create Knowledge'),
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(241, 245, 249, 1),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {},
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
                  child: Text('Search', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    // Thêm logic sử dụng prompt ở đây
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

          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Knowledge')),
                        DataColumn(label: Text('Units')),
                        DataColumn(label: Text('Size')),
                        DataColumn(label: Text('Action')),
                      ],
                      
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('title', ),
                                  Text('description', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KbScreen()),
                                );
                              },
                            ),
                            DataCell(
                              Text('number of units'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KbScreen()),
                                );
                              },
                            ),
                            DataCell(
                              Text('size of knowledge'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KbScreen()),
                                );
                              },
                            ),
                            DataCell(IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Handle delete action
                              },
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       IconButton(
          //         icon: Icon(Icons.arrow_back),
          //         onPressed: () {
          //           // Handle previous page action
          //         },
          //       ),
          //       Text('1'),
          //       IconButton(
          //         icon: Icon(Icons.arrow_forward),
          //         onPressed: () {
          //           // Handle next page action
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Bots',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.book),
      //       label: 'Knowledge',
      //     ),
      //   ],
      //   currentIndex: 1, // Set the current index to Knowledge
      //   onTap: (index) {
      //     // Handle bottom navigation bar tap
      //   },
      // ),
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
            child: const SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge name",
                    hintText: "...",
                  ),
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge description",
                    hintText: "...",
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
                // Thêm logic sử dụng prompt ở đây
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
