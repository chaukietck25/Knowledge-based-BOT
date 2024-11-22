import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/prompt_category_model.dart';
import 'package:knowledge_based_bot/utils/prompt_category.dart';

import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';

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
  bool isMyPromptSelected = false;

  bool showAllCategories = false;

  //search controller
  final TextEditingController _searchController = TextEditingController();

  //mobx
  final PromptStore promptStore = PromptStore();

  // Get prompt from API
  @override
  void initState() {
    super.initState();
    promptStore.fetchPrompts();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8, // Kích thước ban đầu của DraggableScrollableSheet
      minChildSize: 0.7, // Kích thước tối thiểu của DraggableScrollableSheet
      maxChildSize: 0.9, // Kích thước tối đa của DraggableScrollableSheet
      snap: true,
      snapSizes: [
        0.8,
        0.9
      ], // Các kích thước mà DraggableScrollableSheet có thể "snap" vào

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
                            if (isMyPromptSelected) {
                              promptStore.privatePrompts();
                            } else {
                              promptStore.fetchPrompts();
                            }
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
                      label: Text('Public Prompt'),
                      selected: !isMyPromptSelected,
                      onSelected: (selected) {
                        setState(() {
                          isMyPromptSelected = false;
                        });
                        promptStore.fetchPrompts();
                      },
                    ),
                    SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('My Prompt'),
                      selected: isMyPromptSelected,
                      onSelected: (selected) {
                        setState(() {
                          isMyPromptSelected = true;
                        });
                        promptStore.privatePrompts();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        promptStore.searchByAPI(
                            _searchController.text, !isMyPromptSelected);
                        //searchPrompts(_searchController.text);
                      },
                    ),
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
                      ElevatedButton(
                        child: Text('Favorite Prompt'),
                        onPressed: () {
                          promptStore.filterByFavorite();
                        },
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          if (!showAllCategories)
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing:
                                      8.0, // khoảng cách giữa các FilterChip
                                  runSpacing: 8.0, // khoảng cách giữa các dòng
                                  children:
                                      PROMPT_CATEGORY_ITEM.entries.map((entry) {
                                    return FilterChip(
                                      label: Text(entry.value['label']),
                                      onSelected: (_) {
                                        promptStore.filterByCategory(
                                            entry.value['value']);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          if (showAllCategories)
                            Expanded(
                              child: Wrap(
                                spacing: 8.0, // khoảng cách giữa các FilterChip
                                runSpacing: 8.0, // khoảng cách giữa các dòng
                                children:
                                    PROMPT_CATEGORY_ITEM.entries.map((entry) {
                                  return FilterChip(
                                    label: Text(entry.value['label']),
                                    onSelected: (_) {
                                      promptStore.filterByCategory(
                                          entry.value['value']);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          IconButton(
                            icon: showAllCategories
                                ? Icon(Icons.arrow_drop_up, color: Colors.white)
                                : Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                            onPressed: () {
                              setState(() {
                                showAllCategories = !showAllCategories;
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: RenderListPrompt(promptStore: promptStore),
                  // Observer(
                  //   builder:(_) => ListView.separated(
                  //     shrinkWrap: true,
                  //     itemCount: promptStore.prompts.length,
                  //     itemBuilder: (context, index) {
                  //       final prompt = promptStore.prompts[index];
                  //       return PromptTile(
                  //         title: prompt['title']!,
                  //         description: prompt[index]['description']!,
                  //         onInfoPressed: () {
                  //           // Show prompt details
                  //         },
                  //         onFavoritePressed: () {
                  //           // Add to favorites
                  //         },
                  //         onNavigatePressed: () {
                  //           // Navigate to prompt
                  //         },
                  //       );
                  //       // return Padding(
                  //       //   padding: const EdgeInsets.all(8.0),
                  //       //   child:
                  //       //   ListTile(
                  //       //     title: Text(
                  //       //       prompts[index]['title']!,
                  //       //       style: TextStyle(fontWeight: FontWeight.bold),
                  //       //     ),
                  //       //     //tileColor: const Color.fromARGB(255, 253, 1, 1),
                  //       //     subtitle: Text(prompts[index]['description']!),
                  //       //     trailing: Row(
                  //       //       mainAxisSize: MainAxisSize.min,
                  //       //       children: [
                  //       //         IconButton(
                  //       //           icon: Icon(Icons.info_outline),
                  //       //           onPressed: () {
                  //       //             // Show prompt details
                  //       //           },
                  //       //         ),
                  //       //         IconButton(
                  //       //           icon: Icon(Icons.star_border),
                  //       //           onPressed: () {
                  //       //             // Add to favorites
                  //       //           },
                  //       //         ),
                  //       //         IconButton(
                  //       //           icon: Icon(Icons.arrow_forward),
                  //       //           onPressed: () {
                  //       //             // Navigate to prompt
                  //       //           },
                  //       //         ),
                  //       //       ],
                  //       //     ),
                  //       //   ),
                  //       // );
                  //     },
                  //     separatorBuilder: (context, index) => Divider(),
                  //   ),
                  // ),
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
  bool isPublicPrompt = false;
  String selectedLanguage = 'English';
  String selectedCategory = PROMPT_CATEGORY_ITEM.entries.last.value['value'];

  // var store data
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final PromptStore promptStore = PromptStore();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'New Prompt',
            style: TextStyle(color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
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
                  selected: isPublicPrompt,
                  onSelected: (selected) {
                    setState(() {
                      isPublicPrompt = false;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Public Prompt'),
                  selected: !isPublicPrompt,
                  onSelected: (selected) {
                    setState(() {
                      isPublicPrompt = true;
                    });
                  },
                ),
              ],
            ),
            if (isPublicPrompt) ...[
              const SizedBox(height: 16),
              const Text(
                'Prompt Language',
                style: TextStyle(color: Colors.black),
              ),
              DropdownButton<String>(
                value: selectedLanguage,
                dropdownColor: Colors.grey[800],
                items: <String>['English', 'Vietnamese', 'Spanish']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.black)),
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
            CommonTextField(
              title: 'Title',
              hintText: 'Title of the prompt',
              controller: titleController,
            ),
            if (isPublicPrompt) ...[
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(color: Colors.black),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                dropdownColor: Colors.grey[800],
                items: PROMPT_CATEGORY_ITEM.entries
                    .map<DropdownMenuItem<String>>((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value['value'],
                    child: Text(entry.value['label'],
                        style: TextStyle(color: Colors.black)),
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
            CommonTextField(
              title: 'Description (Optional)',
              hintText:
                  'Describe your prompt so others can have a better understanding',
              maxlines: 4,
              controller: descriptionController,
            ),
            SizedBox(height: 16),
            CommonTextField(
              title: 'Prompt',
              hintText: 'Use square brackets [ ] to specify user input.',
              maxlines: 4,
              controller: contentController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            promptStore.createPrompt(
                titleController.text,
                contentController.text,
                descriptionController.text,
                selectedCategory,
                selectedLanguage,
                isPublicPrompt);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
