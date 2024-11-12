import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prompt Library'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => PromptLibraryModal(),
              isScrollControlled: true,
            );
          },
          child: Text('Open Prompt Library'),
        ),
      ),
    );
  }
}

class PromptLibraryModal extends StatefulWidget {
  @override
  _PromptLibraryModalState createState() => _PromptLibraryModalState();
}

class _PromptLibraryModalState extends State<PromptLibraryModal> {
  bool isMyPromptSelected = true;
  bool showAllCategories = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prompt Library',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => NewPromptDialog(),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('My Prompt'),
                      selected: isMyPromptSelected,
                      onSelected: (selected) {
                        setState(() {
                          isMyPromptSelected = true;
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Public Prompt'),
                      selected: !isMyPromptSelected,
                      onSelected: (selected) {
                        setState(() {
                          isMyPromptSelected = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              if (!isMyPromptSelected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FilterChip(label: Text('All'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Other'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Writing'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Marketing'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Chatbot'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(label: Text('Seo'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Career'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Coding'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Productivity'),
                                onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Education'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: Text('Business'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(label: Text('Fun'), onSelected: (_) {}),
                          ],
                        ),
                      ),
                      if (!showAllCategories)
                        IconButton(
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              showAllCategories = true;
                            });
                          },
                        ),
                      if (showAllCategories)
                        Wrap(
                          spacing: 8.0,
                          children: [
                            FilterChip(label: Text('All'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Other'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Writing'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Marketing'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Chatbot'), onSelected: (_) {}),
                            FilterChip(label: Text('Seo'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Career'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Coding'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Productivity'),
                                onSelected: (_) {}),
                            FilterChip(
                                label: Text('Education'), onSelected: (_) {}),
                            FilterChip(
                                label: Text('Business'), onSelected: (_) {}),
                            FilterChip(label: Text('Fun'), onSelected: (_) {}),
                            IconButton(
                              icon: Icon(Icons.arrow_drop_up,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  showAllCategories = false;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class NewPromptDialog extends StatefulWidget {
  @override
  _NewPromptDialogState createState() => _NewPromptDialogState();
}

class _NewPromptDialogState extends State<NewPromptDialog> {
  bool isPrivatePrompt = true;
  String selectedLanguage = 'English';
  String selectedCategory = 'Business';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      contentPadding: EdgeInsets.all(16.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'New Prompt',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ChoiceChip(
                  label: Text('Private Prompt'),
                  selected: isPrivatePrompt,
                  onSelected: (selected) {
                    setState(() {
                      isPrivatePrompt = true;
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Public Prompt'),
                  selected: !isPrivatePrompt,
                  onSelected: (selected) {
                    setState(() {
                      isPrivatePrompt = false;
                    });
                  },
                ),
              ],
            ),
            if (!isPrivatePrompt) ...[
              SizedBox(height: 16),
              Text(
                'Prompt Language',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                value: selectedLanguage,
                dropdownColor: Colors.grey[800],
                items: <String>['English', 'Vietnamese', 'Spanish']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
              ),
            ],
            SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Name of the prompt',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (!isPrivatePrompt) ...[
              SizedBox(height: 16),
              Text(
                'Category',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                dropdownColor: Colors.grey[800],
                items: <String>[
                  'Business',
                  'Marketing',
                  'Education',
                  'Technology'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ],
            SizedBox(height: 16),
            Text(
              'Description (Optional)',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Describe your prompt so others can have a better understanding',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Prompt',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Use square brackets [ ] to specify user input.',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Save'),
        ),
      ],
    );
  }
}
