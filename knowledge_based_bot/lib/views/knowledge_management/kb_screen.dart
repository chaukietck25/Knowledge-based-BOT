
import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';
import 'package:knowledge_based_bot/store/knowledge_store.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

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
      print("knowledge id: ${widget.knowledge.id}");
    });
  }

  Future<void> _navigate(String screenType) async {
    Widget screen;

    switch (screenType) {
      case 'LocalFile':
        screen = LocalFileScreen(knowledge: widget.knowledge);
        break;
      case 'WebUrl': // Thay thế bằng tên màn hình khác nếu có
        screen = WebsiteScreen(
            knowledge:
                widget.knowledge); // Thay thế bằng widget của màn hình khác
        break;
      case 'GoogleDrive':
        screen = GoogleDriveScreen(knowledge: widget.knowledge);
        break;
      case 'Slack':
        screen = SlackScreen(knowledge: widget.knowledge);
        break;
      case 'Confluence':
        screen = ConfluenceScreen(knowledge: widget.knowledge);
        break;
      default:
        screen = LocalFileScreen(knowledge: widget.knowledge);
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
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
      backgroundColor: Colors.white,
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
          
        ],
      ),
      body: Observer(builder: (_) {
        if (isLoading == true) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        } else {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.storage),
                      ),
                      title: Text(widget.knowledge.knowledgeName,
                          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.knowledge.description ,
                              style: TextStyle(color: Colors.black)),
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
                        scrollDirection: Axis.vertical,
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: constraints.maxWidth),
                          child: Observer(builder: (_) {
                            return DataTable(
                              headingRowColor: MaterialStateProperty.all(Colors.blue.shade50),
                              headingTextStyle: TextStyle(color: Colors.black),
                              dataRowHeight: 100,
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
                                  return 
                                  DataRow(cells: [
                                    DataCell(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        //SizedBox(height: 8),
                                        Text(unit.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        //SizedBox(height: 4),
                                        Text(
                                          _convertToKb(unit.size)
                                                  .toStringAsFixed(3)
                                                  .toString() +
                                              ' KB',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        //SizedBox(height: 8),
                                        
                                      ],
                                    )),
                                    DataCell(Text(unit.type)),
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
          
          _showDialogUpdateUnits(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add unit',
      ),
    );
  }

  void _showDialogUpdateUnits(BuildContext context) {
    String? _selectedOption;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add unit'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Local files'),
                    subtitle: Text('Upload pdf, docx, ...'),
                    leading: Image.asset('assets/logo/files.png', width: 30),
                    onTap: () => _navigate('LocalFile'),
                  ),
                  ListTile(
                    title: Text('URL'),
                    subtitle: Text('Connect URL website to get data'),
                    leading: Image.asset('assets/logo/url.png', width: 30),
                    onTap: () => _navigate('WebUrl'),
                  ),
                  ListTile(
                    title: Text('Google drive'),
                    subtitle: Text('Connect Google drive to get data'),
                    leading:
                        Image.asset('assets/logo/google-drive.png', width: 30),
                    onTap: () => _navigate('GoogleDrive'),
                  ),
                  ListTile(
                    title: Text('Slack'),
                    subtitle: Text('Connect Slack to get data'),
                    leading: Image.asset('assets/logo/slack.png', width: 30),
                    onTap: () => _navigate('Slack'),
                  ),
                  ListTile(
                    title: Text('Confluence'),
                    subtitle: Text('Connect Confluence to get data'),
                    leading:
                        Image.asset('assets/logo/confluence.png', width: 30),
                    onTap: () => _navigate('Confluence'),
                  ),
                ],
              ),
            ),
          );
        });
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
            onPressed: () async {
              const url = 'https://jarvis.cx/help/knowledge-base/connectors/file';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Docs', style: TextStyle(color: Colors.white)),
                    ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      noti!,
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child:
                        Text('Upload', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Thêm logic sử dụng prompt ở đây
                      if (uploadedFileName != null) {
                        noti = null;
                        _uploadFile().then((value) {
                          setState(() {
                            isLoading = false;
                            uploadedFileName = null;
                            selectedFileBytes = null;
                            selectedFilePath = null;

                            if (knowledgeStore.noti_message != null) {
                              noti = "Failed to upload file: ${knowledgeStore.noti_message}";
                            } else {
                              noti = "File uploaded successfully";
                            }
                          });
                        });
                      } else {
                        setState(() {
                          noti = "Please select a file to upload";
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        "Processing... Please wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class WebsiteScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  WebsiteScreen({required this.knowledge});

  @override
  _WebsiteScreenState createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  TextEditingController urlController = TextEditingController();
  TextEditingController unitNameController = TextEditingController();

  final KnowledgeStore knowledgeStore = KnowledgeStore();

  bool isLoading = false;
  String? noti;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //pop the screen to kb screen
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Column(
                  children: [
                    CommonTextField(
                      title: "Web URL",
                      hintText: "Enter web URL",
                      controller: urlController,
                    ),
                    SizedBox(height: 16),
                    CommonTextField(
                      title: "Unit name",
                      hintText: "Enter unit name",
                      controller: unitNameController,
                      maxlines: 4,
                    ),
                    SizedBox(height: 16),
                    if (noti != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          noti!,
                          style: TextStyle(
                              color: Colors.red, fontStyle: FontStyle.italic),
                        ),
                      ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text('Upload',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            noti = null;
                          });
                          //
                          if (urlController.text.isEmpty ||
                              unitNameController.text.isEmpty) {
                            setState(() {
                              noti = "Please enter web URL and unit name";
                            });
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            knowledgeStore
                                .uploadWebUrl(widget.knowledge.id,
                                    urlController.text, unitNameController.text)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                                if (knowledgeStore.noti_message != null) {
                                  noti = "Failed to upload Web URL: ${knowledgeStore.noti_message}";
                                } else {
                                  noti = "Web URL uploaded successfully";
                                }
                              });
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        "Processing... Please wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ConfluenceScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  ConfluenceScreen({required this.knowledge});

  @override
  _ConfluenceScreenState createState() => _ConfluenceScreenState();
}

class _ConfluenceScreenState extends State<ConfluenceScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController wikiPageUrlController = TextEditingController();
  TextEditingController confluenceUsernameController = TextEditingController();
  TextEditingController confluenceAccessTokenController =
      TextEditingController();

  final KnowledgeStore knowledgeStore = KnowledgeStore();

  bool isLoading = false;
  String? noti;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //pop the screen to kb screen
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
            onPressed: () async {
              const url = 'https://jarvis.cx/help/knowledge-base/connectors/confluence';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Docs', style: TextStyle(color: Colors.white),)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonTextField(
                  title: "Name",
                  hintText: "Enter unit name",
                  controller: nameController,
                ),
                SizedBox(height: 16),
                CommonTextField(
                  title: "Wiki Page URL",
                  hintText: "Enter wiki page URL",
                  controller: wikiPageUrlController,
                  maxlines: 4,
                ),
                SizedBox(height: 16),
                CommonTextField(
                  title: "Confluence Username",
                  hintText: "Enter confluence username",
                  controller: confluenceUsernameController,
                  maxlines: 4,
                ),
                SizedBox(height: 16),
                CommonTextField(
                  title: "Confluence Access Token",
                  hintText: "Enter confluence access token",
                  controller: confluenceAccessTokenController,
                  maxlines: 4,
                ),
                SizedBox(height: 16),
                if (noti != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      noti!,
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    ),
                  ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child:
                        Text('Upload', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Thêm logic sử dụng prompt ở đây
                      setState(() {
                        noti = null;
                      });
                      if (nameController.text.isEmpty ||
                          wikiPageUrlController.text.isEmpty ||
                          confluenceUsernameController.text.isEmpty ||
                          confluenceAccessTokenController.text.isEmpty) {
                        setState(() {
                          noti = "Please enter all fields";
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        // knowledgeStore
                        //     .uploadConfluence(
                        //         widget.knowledge.id,
                        //         nameController.text,
                        //         wikiPageUrlController.text,
                        //         confluenceUsernameController.text,
                        //         confluenceAccessTokenController.text)
                        //     .then((value) {
                        //   setState(() {
                        //     isLoading = false;
                        //     noti = "Confluence uploaded successfully";
                        //   });
                        // });
                        try {
                          knowledgeStore
                              .uploadConfluence(
                            widget.knowledge.id,
                            nameController.text,
                            wikiPageUrlController.text,
                            confluenceUsernameController.text,
                            confluenceAccessTokenController.text,
                          )
                              .then((value) {
                            setState(() {
                              isLoading = false;
                              if (knowledgeStore.noti_message != null) {
                                noti = "Failed to upload Confluence: ${knowledgeStore.noti_message}";
                              } else {
                                noti = "Confluence uploaded successfully";
                              }
                            });
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                            noti = "Failed to upload Confluence: $e";
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        "Processing... Please wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class GoogleDriveScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  GoogleDriveScreen({required this.knowledge});
  //GoogleDriveScreen({Key? key}) : super(key: key);

  @override
  _GoogleDriveScreenState createState() => _GoogleDriveScreenState();
}

class _GoogleDriveScreenState extends State<GoogleDriveScreen> {
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
            onPressed: () async {
              const url = 'https://jarvis.cx/help/knowledge-base/connectors/google-drive';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Docs', style: TextStyle(color: Colors.white),)
            ),
          ),
        ],
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

class SlackScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  SlackScreen({required this.knowledge});
  //SlackScreen({Key? key}) : super(key: key);

  @override
  _SlackScreenState createState() => _SlackScreenState();
}

class _SlackScreenState extends State<SlackScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController slackWorkspaceController = TextEditingController();
  TextEditingController slackBotTokenController = TextEditingController();

  final KnowledgeStore knowledgeStore = KnowledgeStore();

  bool isLoading = false;
  String? noti;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //pop the screen to kb screen
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
            onPressed: () async {
              const url = 'https://jarvis.cx/help/knowledge-base/connectors/slack';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text('Docs', style: TextStyle(color: Colors.white),)
                    ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonTextField(
                  title: "Name",
                  hintText: "Enter unit name",
                  controller: nameController,
                ),
                SizedBox(height: 16),
                CommonTextField(
                  title: "Slack workspace",
                  hintText: "Enter slack workspace",
                  controller: slackWorkspaceController,
                  maxlines: 4,
                ),
                SizedBox(height: 16),
                CommonTextField(
                  title: "Slack Bot Token:",
                  hintText: "Enter slack bot token",
                  controller: slackBotTokenController,
                  maxlines: 4,
                ),
                SizedBox(height: 16),
                if (noti != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      noti!,
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    ),
                  ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child:
                        Text('Upload', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        noti = null;
                      });
                      if (nameController.text.isEmpty ||
                          slackWorkspaceController.text.isEmpty ||
                          slackBotTokenController.text.isEmpty) {
                        setState(() {
                          noti = "Please enter all fields";
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          knowledgeStore
                              .uploadSlack(
                            widget.knowledge.id,
                            nameController.text,
                            slackWorkspaceController.text,
                            slackBotTokenController.text,
                          )
                              .then((value) {
                            setState(() {
                              isLoading = false;
                              if (knowledgeStore.noti_message != null) {
                                noti = "Failed to upload Slack: ${knowledgeStore.noti_message}";
                              } else {
                                noti = "Slack uploaded successfully";
                              }
                            });
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                            noti = "Failed to upload Slack: $e";
                          });
                        }

                        //   knowledgeStore
                        //       .uploadSlack(
                        //           widget.knowledge.id,
                        //           nameController.text,
                        //           slackWorkspaceController.text,
                        //           slackBotTokenController.text)
                        //       .then((value) {
                        //     setState(() {
                        //       isLoading = false;
                        //       noti = "Slack uploaded successfully";
                        //     });
                        //   });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading == true)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        "Processing... Please wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
