import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/data/models/kb_unit_model.dart';
import 'package:knowledge_based_bot/store/knowledge_store.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';

class KbScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  KbScreen({required this.knowledge});

  @override
  _KbScreenState createState() => _KbScreenState();
}

class _KbScreenState extends State<KbScreen> {
  final KnowledgeStore knowledgeStore = KnowledgeStore();
  bool isLoading = true;

  // get knowledge unit

  @override
  void initState() {
    super.initState();
    // Fetch the latest knowledge data if needed
    knowledgeStore.fetchKnowledgeUnits(widget.knowledge.id).then((value) {
      setState(() {
        isLoading = false;
      });
      print(
          "Knowledge unit fetched successfully: ${knowledgeStore.knowledgeUnitList.length}");
    });
  }

  Future<void> _navigateToLocalFileScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocalFileScreen(knowledge: widget.knowledge),
      ),
    );

    if (result == true) {
      // Nếu kết quả trả về là true, cập nhật lại dữ liệu
      setState(() {
        isLoading = true;
      });
      knowledgeStore.fetchKnowledgeUnits(widget.knowledge.id).then((value) {
       
        setState(() {
          isLoading = false;
          widget.knowledge.numUnits = knowledgeStore.knowledgeUnitList.length;
          widget.knowledge.totalSize = knowledgeStore.knowledgeUnitList.fold(
              0, (previousValue, element) => previousValue + element.size);
        });
        
      });
    }
  }

  double _convertToKb(int size) {
    return size / (1024);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget
            .knowledge.knowledgeName), // Set the title of the knowledge base
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              knowledgeStore.fetchKnowledge().then((value) {
                Navigator.pop(context, true);
              });
            }),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ElevatedButton(
          //     child: Text('Add unit',
          //         style: TextStyle(color: Colors.white)),
          //     onPressed: () {
          //       // Thêm logic sử dụng prompt ở đây
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
      body: Observer(builder: (_) {
        if (isLoading == true) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.storage),
                      ),
                      title: Text(widget.knowledge.knowledgeName,
                          style: TextStyle(fontSize: 20)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.knowledge.description),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Chip(
                                label:
                                    Text('Units: ${widget.knowledge.numUnits}'),
                              ),
                              SizedBox(width: 8),
                              Chip(
                                label: Text(
                                    'Size: ${_convertToKb(widget.knowledge.totalSize).toStringAsFixed(3)} KB'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit action
                          _showUpdateKnowledgeDialog(context);
                          //_navigateToLocalFileScreen();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Observer(builder: (_) {
                            return DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text('Unit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text('Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  //DataColumn(label: Text('Size')),
                                  //DataColumn(label: Text('Enable')),
                                  //DataColumn(label: Text('Action')),
                                ],
                                rows: knowledgeStore.knowledgeUnitList
                                    .map((unit) {
                                  return DataRow(cells: [
                                    DataCell(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(unit.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text(
                                          _convertToKb(unit.size).toStringAsFixed(3).toString() + ' KB',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    )),
                                    DataCell(Text(unit.type)),
                                    //DataCell(Text(unit.name)),
                                    // DataCell(Switch(
                                    //   trackColor:
                                    //       MaterialStateProperty.all(Colors.blue),
                                    //   value: true,
                                    //   onChanged: (bool value) {
                                    //     // Handle switch change
                                    //     // switchValue = value;
                                    //   },
                                    // )),
                                    // DataCell(IconButton(
                                    //   icon: Icon(Icons.delete),
                                    //   onPressed: () {
                                    //     // Handle delete action
                                    //   },
                                    // )),
                                  ]);
                                }).toList());
                          }),
                        ),
                      );
                    }),
                  ),
                ],
              ));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle create knowledge action
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //     return dialogAddUnit(knowledge: widget.knowledge);
          //   },
          // );
          _showDialogUpdateUnits(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add unit',
      ),
    );
  }

  void _showDialogUpdateUnits(BuildContext context) {
    String _selectedOption = 'Local files';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add unit'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text('Local files'),
                    subtitle: Text('Upload pdf, docx, ...'),
                    value: 'Local files',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                      // if (value != null) {
                      //   _navigateToScreen(context, value);
                      // }

                      //Navigator.of(context).pop();
                    },
                    secondary: Image.asset('assets/logo/files.png', width: 30),
                  ),
                  RadioListTile<String>(
                    title: Text('URL'),
                    subtitle: Text('Connect URL website to get data'),
                    value: 'URL',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                      // if (value != null) {
                      //   _navigateToScreen(context, value);
                      // }

                      //Navigator.of(context).pop();
                    },
                    secondary: Image.asset('assets/logo/url.png', width: 30),
                  ),
                  RadioListTile<String>(
                    title: Text('Google drive'),
                    subtitle: Text('Connect Google drive to get data'),
                    value: 'Google drive',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                      // if (value != null) {
                      //   _navigateToScreen(context, value);
                      // }

                      //Navigator.of(context).pop();
                    },
                    secondary:
                        Image.asset('assets/logo/google-drive.png', width: 30),
                  ),
                  RadioListTile<String>(
                    title: Text('Slack'),
                    subtitle: Text('Connect Slack to get data'),
                    value: 'Slack',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                      // if (value != null) {
                      //   _navigateToScreen(context, value);
                      // }

                      //Navigator.of(context).pop();
                    },
                    secondary: Image.asset('assets/logo/slack.png', width: 30),
                  ),
                  RadioListTile<String>(
                    title: Text('Confluence'),
                    subtitle: Text('Connect Confluence to get data'),
                    value: 'Confluence',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                      // if (value != null) {
                      //   _navigateToScreen(context, value);
                      // }

                      //Navigator.of(context).pop();
                    },
                    secondary:
                        Image.asset('assets/logo/confluence.png', width: 30),
                  ),
                ],
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
                child: Text('Next', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_selectedOption != null) {
                    _navigateToScreen(context, _selectedOption);
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
        });
  }

  void _navigateToScreen(BuildContext context, String value) {
    //Widget screen = LocalFileScreen(knowledge: widget.knowledge);
    switch (value) {
      case 'Local files':
        //screen = LocalFileScreen(knowledge: widget.knowledge);
        _navigateToLocalFileScreen();
        break;
      case 'URL':
        //screen = WebsiteScreen();
        break;
      case 'Confluence':
        //screen = ConfluenceScreen();
        break;
      case 'Google drive':
        //screen = GoogleDriveScreen();
        break;
      case 'Slack':
        //screen = SlackScreen();
        break;
      default:
      //screen = LocalFileScreen(knowledge: widget.knowledge);
    }
  }

  void _showUpdateKnowledgeDialog(BuildContext context) {
    TextEditingController knowledgeNameController = TextEditingController();
    TextEditingController knowledgeDescriptionController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Knowledge'),
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
                    hintText: widget.knowledge.knowledgeName,
                    controller: knowledgeNameController,
                  ),
                  SizedBox(height: 16),
                  CommonTextField(
                    title: "Knowledge description",
                    hintText: widget.knowledge.description,
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
                //
                if (knowledgeNameController.text.isEmpty) {
                  knowledgeNameController.text = widget.knowledge.knowledgeName;
                }
                if (knowledgeDescriptionController.text.isEmpty) {
                  knowledgeDescriptionController.text =
                      widget.knowledge.description;
                }
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                knowledgeStore
                    .updateKnowledge(
                        widget.knowledge.id,
                        knowledgeNameController.text,
                        knowledgeDescriptionController.text)
                    .then((value) {
                  knowledgeStore.fetchKnowledge().then((value1) {
                    setState(() {
                      isLoading = false;
                      widget.knowledge.knowledgeName =
                          knowledgeNameController.text;
                      widget.knowledge.description =
                          knowledgeDescriptionController.text;
                    });
                  });
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

// class dialogAddUnit extends StatefulWidget {
//   final KnowledgeResDto knowledge;

//   dialogAddUnit({required this.knowledge});
//   @override
//   _dialogAddUnitState createState() => _dialogAddUnitState();
// }

// class _dialogAddUnitState extends State<dialogAddUnit> {
//   String _selectedOption = 'Local files';

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add unit'),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             RadioListTile<String>(
//               title: Text('Local files'),
//               subtitle: Text('Upload pdf, docx, ...'),
//               value: 'Local files',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//                 // if (value != null) {
//                 //   _navigateToScreen(context, value);
//                 // }

//                 //Navigator.of(context).pop();
//               },
//               secondary: Image.asset('assets/logo/files.png', width: 30),
//             ),
//             RadioListTile<String>(
//               title: Text('URL'),
//               subtitle: Text('Connect URL website to get data'),
//               value: 'URL',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//                 // if (value != null) {
//                 //   _navigateToScreen(context, value);
//                 // }

//                 //Navigator.of(context).pop();
//               },
//               secondary: Image.asset('assets/logo/url.png', width: 30),
//             ),
//             RadioListTile<String>(
//               title: Text('Google drive'),
//               subtitle: Text('Connect Google drive to get data'),
//               value: 'Google drive',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//                 // if (value != null) {
//                 //   _navigateToScreen(context, value);
//                 // }

//                 //Navigator.of(context).pop();
//               },
//               secondary: Image.asset('assets/logo/google-drive.png', width: 30),
//             ),
//             RadioListTile<String>(
//               title: Text('Slack'),
//               subtitle: Text('Connect Slack to get data'),
//               value: 'Slack',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//                 // if (value != null) {
//                 //   _navigateToScreen(context, value);
//                 // }

//                 //Navigator.of(context).pop();
//               },
//               secondary: Image.asset('assets/logo/slack.png', width: 30),
//             ),
//             RadioListTile<String>(
//               title: Text('Confluence'),
//               subtitle: Text('Connect Confluence to get data'),
//               value: 'Confluence',
//               groupValue: _selectedOption,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//                 // if (value != null) {
//                 //   _navigateToScreen(context, value);
//                 // }

//                 //Navigator.of(context).pop();
//               },
//               secondary: Image.asset('assets/logo/confluence.png', width: 30),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           child: Text('Next', style: TextStyle(color: Colors.white)),
//           onPressed: () {
//             if (_selectedOption != null) {
//               _navigateToScreen(context, _selectedOption);
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           ),
//         ),
//       ],
//     );
//   }

//   void _navigateToScreen(BuildContext context, String value) {
//     Widget screen = LocalFileScreen(knowledge: widget.knowledge);
//     switch (value) {
//       case 'Local files':
//         screen = LocalFileScreen(knowledge: widget.knowledge);
//         break;
//       case 'URL':
//         screen = WebsiteScreen();
//         break;
//       case 'Confluence':
//         screen = ConfluenceScreen();
//         break;
//       case 'Google drive':
//         screen = GoogleDriveScreen();
//         break;
//       case 'Slack':
//         screen = SlackScreen();
//         break;
//       default:
//         screen = LocalFileScreen(knowledge: widget.knowledge);
//     }
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => screen),
//     );
//   }
// }

class LocalFileScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  LocalFileScreen({required this.knowledge});

  @override
  _LocalFileScreenState createState() => _LocalFileScreenState();
}

class _LocalFileScreenState extends State<LocalFileScreen> {
  final KnowledgeStore knowledgeStore = KnowledgeStore();
  bool isLoading = false;
  String? uploadedFileName;
  Uint8List? selectedFileBytes;
  String? selectedFilePath;
  String? noti;
  final List<String> allowedExtensions = [
    'c',
    'cpp',
    'docx',
    'html',
    'java',
    'json',
    'md',
    'pdf',
    'php',
    'pptx',
    'py',
    'rb',
    'tex',
    'txt'
  ];

  final Map<String, String> mimeTypes = {
    'c': 'text/x-c',
    'cpp': 'text/x-c++',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'html': 'text/html',
    'java': 'text/x-java',
    'json': 'application/json',
    'md': 'text/markdown',
    'pdf': 'application/pdf',
    'php': 'text/x-php',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'py': 'text/x-python',
    'rb': 'text/x-ruby',
    'tex': 'text/x-tex',
    'txt': 'text/plain',
  };

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        print("kIsWeb: $kIsWeb");
        String fileName = result.files.first.name;
        String? mimeType = lookupMimeType(fileName);
        setState(() {
          isLoading = true;
        });
        if (mimeType != null && mimeTypes.containsValue(mimeType)) {
          if (kIsWeb) {
            // Handle file selection on web
            Uint8List? fileBytes = result.files.first.bytes;
            String fileName = result.files.first.name;
            // Handle the selected file bytes
            print("Selected file: $fileName");
            setState(() {
              selectedFileBytes = fileBytes;
              uploadedFileName = fileName;
              isLoading = false;
            });
          } else {
            // Handle file selection on mobile
            String filePath = result.files.single.path!;
            String fileName = result.files.single.name;
            // Handle the selected file
            print("Selected file: $filePath");
            setState(() {
              selectedFilePath = filePath;
              uploadedFileName = fileName;
              isLoading = false;
            });
          }
        } else {
          print("File type not allowed");
        }
      } else {
        // User canceled the picker
        print("File selection canceled");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> _uploadFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (kIsWeb && selectedFileBytes != null && uploadedFileName != null) {
        await knowledgeStore.uploadLocalFileWeb(
            widget.knowledge.id, selectedFileBytes!, uploadedFileName!);
      } else if (selectedFilePath != null) {
        await knowledgeStore.uploadLocalFile(
            widget.knowledge.id, selectedFilePath!);
      }
      print("File uploaded successfully");
    } catch (e) {
      print("Error uploading file: $e");
    } finally {
      setState(() {
        isLoading = false;
        noti = "File uploaded successfully";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Knowledge id: ${widget.knowledge.id}");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo/files.png', width: 30, height: 30),
            SizedBox(width: 8),
            Text('Local Files',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //pop the screen to kb screen
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            const Text(
              'Upload local file:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (isLoading == true)
              Center(child: CircularProgressIndicator())
            else
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload_file,
                            size: 50, color: Colors.blue),
                        const SizedBox(height: 8),
                        const Text(
                          'Click to this area to upload',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Supported file types: pdf, docx, html, java, json, md, pdf, php, pptx, py, rb, tex, txt',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            if (uploadedFileName != null)
              Container(
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
                      )),
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uploadedFileName!,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  //tileColor: Colors.white, // Đặt màu nền của ListTile là màu trắng
                  //subtitle: Text(widget.description),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle delete action
                          setState(() {
                            uploadedFileName = null;
                            selectedFileBytes = null;
                            selectedFilePath = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),
            if (noti != null)
              Text(
                noti!,
                style:
                    TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
              ),
            Center(
              child: ElevatedButton(
                child: Text('Upload', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Thêm logic sử dụng prompt ở đây
                  if (uploadedFileName != null) {
                    noti = null;
                    _uploadFile();
                    setState(() {
                      uploadedFileName = null;
                      selectedFileBytes = null;
                      selectedFilePath = null;
                    });
                  }else{
                    setState(() {
                      noti = "Please select a file to upload";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebsiteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo/url.png', width: 30, height: 30),
            SizedBox(width: 8),
            Text('URL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Web URL:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Connect', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Thêm logic sử dụng prompt ở đây
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You can load up to 64 pages at a time.\nIf you want to increase this limitation, you need to contact me.\nEmail: jarvisknowledgebase@gmail.com',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfluenceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo/confluence.png', width: 30, height: 30),
            SizedBox(width: 8),
            Text('Confluence',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Wiki Page URL:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Confluence Username:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Confluence Access Token:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Connect', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Thêm logic sử dụng prompt ở đây
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You can retrieve up to 128 pages at a time.\nIf you want to increase this limitation, you need to contact me.\nEmail: jarvisknowledgebase@gmail.com',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleDriveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo/google-drive.png', width: 30, height: 30),
            SizedBox(width: 8),
            Text('Google Drive',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Google Drive Folder ID:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Connect', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Thêm logic sử dụng prompt ở đây
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You can view all files in the specified folder.\nIf you want to increase this limitation, you need to contact me.\nEmail: jarvisknowledgebase@gmail.com',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class SlackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo/slack.png', width: 30, height: 30),
            SizedBox(width: 8),
            Text('Slack',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Slack Workspace:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Text('Slack Bot Token:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                child: Text('Connect', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Thêm logic sử dụng prompt ở đây
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You can view all sessions from the past 60 days.\nIf you want to increase this limitation, you need to contact me.\nEmail: jarvisknowledgebase@gmail.com',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
