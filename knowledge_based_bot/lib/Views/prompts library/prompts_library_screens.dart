import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
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
          child: const Text('Open Prompt Library'),
        ),
      ),
    );
  }
}

class PromptLibraryModal extends StatefulWidget {
  const PromptLibraryModal({super.key});

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
                    const Text(
                      'Prompt Library',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => NewPromptDialog(),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
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
                      label: const Text('My Prompt'),
                      selected: isMyPromptSelected,
                      onSelected: (selected) {
                        setState(() {
                          isMyPromptSelected = true;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Public Prompt'),
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
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
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
                            FilterChip(label: const Text('All'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Other'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Writing'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Marketing'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Chatbot'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(label: const Text('Seo'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Career'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Coding'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Productivity'),
                                onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Education'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(
                                label: const Text('Business'), onSelected: (_) {}),
                            const SizedBox(width: 8),
                            FilterChip(label: const Text('Fun'), onSelected: (_) {}),
                          ],
                        ),
                      ),
                      if (!showAllCategories)
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_drop_down, color: Colors.white),
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
                            FilterChip(label: const Text('All'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Other'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Writing'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Marketing'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Chatbot'), onSelected: (_) {}),
                            FilterChip(label: const Text('Seo'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Career'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Coding'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Productivity'),
                                onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Education'), onSelected: (_) {}),
                            FilterChip(
                                label: const Text('Business'), onSelected: (_) {}),
                            FilterChip(label: const Text('Fun'), onSelected: (_) {}),
                            IconButton(
                              icon: const Icon(Icons.arrow_drop_up,
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
  const NewPromptDialog({super.key});

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
      contentPadding: const EdgeInsets.all(16.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'New Prompt',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
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
                  label: const Text('Private Prompt'),
                  selected: isPrivatePrompt,
                  onSelected: (selected) {
                    setState(() {
                      isPrivatePrompt = true;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Public Prompt'),
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
              const SizedBox(height: 16),
              const Text(
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
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Name',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Name of the prompt',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (!isPrivatePrompt) ...[
              const SizedBox(height: 16),
              const Text(
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
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Description (Optional)',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Describe your prompt so others can have a better understanding',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Prompt',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Use square brackets [ ] to specify user input.',
                hintStyle: const TextStyle(color: Colors.grey),
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
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}
