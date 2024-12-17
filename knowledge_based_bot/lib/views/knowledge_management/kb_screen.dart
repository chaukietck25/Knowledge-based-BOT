import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/data/models/knowledge_model.dart';

class KbScreen extends StatefulWidget {
  final KnowledgeResDto knowledge;

  KbScreen({required this.knowledge});

  @override
  _KbScreenState createState() => _KbScreenState();
}

class _KbScreenState extends State<KbScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.knowledge.knowledgeName), // Set the title of the knowledge base
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.storage),
                ),
                title: Text(widget.knowledge.knowledgeName, style: TextStyle(fontSize: 20)),
                subtitle: Row(
                  children: [
                    Chip(
                      label: Text('Units: ${widget.knowledge.numUnits}'),
                    ),
                    SizedBox(width: 8),
                    Chip(
                      label: Text('Size: ${widget.knowledge.totalSize} KB'),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
                  },
                ),
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
                      columns: [
                        DataColumn(label: Text('Unit')),
                        DataColumn(label: Text('Source')),
                        DataColumn(label: Text('Size')),
                        DataColumn(label: Text('Enable')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Name of the unit')),
                          DataCell(Text('Source of the unit')),
                          DataCell(Text('Size of the unit')),
                          DataCell(Switch(
                            trackColor: MaterialStateProperty.all(Colors.blue),
                            value: true,
                            onChanged: (bool value) {
                              // Handle switch change
                              // switchValue = value;
                            },
                          )),
                          DataCell(IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete action
                            },
                          )),
                        ]),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle create knowledge action
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialogAddUnit();
            },
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add unit',
      ),
    );
  }
}

class dialogAddUnit extends StatefulWidget {
  @override
  _dialogAddUnitState createState() => _dialogAddUnitState();
}

class _dialogAddUnitState extends State<dialogAddUnit> {
  String _selectedOption = 'Local files';

  @override
  Widget build(BuildContext context) {
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
              secondary: Image.asset('assets/logo/google-drive.png', width: 30),
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
              secondary: Image.asset('assets/logo/confluence.png', width: 30),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ],
    );
  }

  void _navigateToScreen(BuildContext context, String value) {
    Widget screen = LocalFileScreen();
    switch (value) {
      case 'Local files':
        screen = LocalFileScreen();
        break;
      case 'URL':
        screen = WebsiteScreen();
        break;
      case 'Confluence':
        screen = ConfluenceScreen();
        break;
      case 'Google drive':
        screen = GoogleDriveScreen();
        break;
      case 'Slack':
        screen = SlackScreen();
        break;
      default:
        screen = LocalFileScreen();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

class LocalFileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, size: 50, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Click or drag file to this area to upload',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Support for a single or bulk upload. Strictly prohibit from uploading company data or other band files',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
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
