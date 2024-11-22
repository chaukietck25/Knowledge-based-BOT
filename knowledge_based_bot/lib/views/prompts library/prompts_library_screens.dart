// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/prompt_category_model.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/utils/prompt_category.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'dart:async';
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
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

  String selectedCategory = 'all';

  bool isFavoriteSelected = false;

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

  

  Completer<void> completer = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: DraggableScrollableSheet(
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
            padding: const EdgeInsets.all(10.0),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Prompt Library',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => NewPromptDialog( promptStore: promptStore),
                                ).then((value) {
                                  
                                  promptStore.privatePrompts();
                                });
                                
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
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
                        labelStyle: TextStyle(
                          color:
                              !isMyPromptSelected ? Colors.white : Colors.black,
                        ),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white,
                        selected: !isMyPromptSelected,
                        onSelected: (selected) {
                          setState(() {
                            isMyPromptSelected = false;
                            promptStore.fetchPrompts();
                          });
                          
                        },
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('My Prompt'),
                        labelStyle: TextStyle(
                          color: isMyPromptSelected ? Colors.white : Colors.black,
                        ),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white,
                        selected: isMyPromptSelected,
                        onSelected: (selected) {
                          setState(() {
                            isMyPromptSelected = true;
                            promptStore.privatePrompts();
                          });
                          
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(241, 245, 249, 1),
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
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: IconButton(
                        icon: !isFavoriteSelected? const Icon(Icons.star_border, color: Colors.black):Icon(Icons.star_rate_rounded ,color: Colors.yellow,),
                        onPressed: () {
                          setState(() {
                            isFavoriteSelected = !isFavoriteSelected;
                          });
                          if (isFavoriteSelected) {
                            promptStore.filterByFavorite();
                          } else {
                            promptStore.fetchPrompts();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (!isMyPromptSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: MediaQuery.of(context).size.width * 0.81,
                    child: Row(
                      children: [
                        SizedBox(width: 4),
                        if (!showAllCategories)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 8.0, // khoảng cách giữa các FilterChip
                                runSpacing: 8.0, // khoảng cách giữa các dòng
                                children:
                                    PROMPT_CATEGORY_ITEM.entries.map((entry) {
                                  return FilterChip(
                                    label: Text(entry.value['label']),
                                    labelStyle: TextStyle(
                                      color:
                                          selectedCategory.toLowerCase() == entry.value['label'].toString().toLowerCase()
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                    selectedColor: Colors.blue,
                                    backgroundColor:
                                        Color.fromRGBO(241, 245, 249, 1),
                                    selected:
                                        selectedCategory.toLowerCase() == entry.value['label'].toString().toLowerCase(),
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedCategory =
                                            selected ? entry.value['value'] : '';
                                      });
                                      promptStore
                                          .filterByCategory(entry.value['value']);
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
                              children: PROMPT_CATEGORY_ITEM.entries.map((entry) {
                                return FilterChip(
                                  label: Text(entry.value['label']),
                                  labelStyle: TextStyle(
                                    color:
                                          selectedCategory.toLowerCase() == entry.value['label'].toString().toLowerCase()
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  selectedColor: Colors.blue,
                                  backgroundColor:
                                      Color.fromRGBO(241, 245, 249, 1),
                                  selected:
                                        selectedCategory.toLowerCase() == entry.value['label'].toString().toLowerCase(),
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedCategory =
                                            selected ? entry.value['value'] : '';
                                      });
                                      promptStore
                                          .filterByCategory(entry.value['value']);
                                    },
                                );
                              }).toList(),
                            ),
                          ),
                        SizedBox(width: 4),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: IconButton(
                            icon: showAllCategories
                                ? Icon(Icons.arrow_drop_up, color: Colors.black)
                                : Icon(Icons.arrow_drop_down,
                                    color: Colors.black),
                            onPressed: () {
                              setState(() {
                                showAllCategories = !showAllCategories;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Observer(
                    builder: (_) {
                      
      
                      return Container(
                        color: Colors.white,
                        child: RenderListPrompt(promptStore: promptStore, completer: completer),
                        
                      );
                      
                    }
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NewPromptDialog extends StatefulObserverWidget {
  final PromptStore promptStore;

  const NewPromptDialog({
    Key? key,
    required this.promptStore,
  }) : super(key: key);

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
    return Observer(
      builder: (_) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Prompt',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                        label: Text('Public Prompt'),
                        labelStyle: TextStyle(
                          color:
                              isPublicPrompt ? Colors.white : Colors.black,
                        ),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white,
                        selected: isPublicPrompt,
                        onSelected: (selected) {
                          setState(() {
                            isPublicPrompt = true;
                          });
                          
                        },
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('Private Prompt'),
                        labelStyle: TextStyle(
                          color: !isPublicPrompt ? Colors.white : Colors.black,
                        ),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white,
                        selected: !isPublicPrompt,
                        onSelected: (selected) {
                          setState(() {
                            isPublicPrompt = false;
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
                  dropdownColor: Colors.grey[200],
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
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
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
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
      }
    );
  }
}


// class NewPromptDialog extends StatefulWidget {
//   final PromptStore promptStore;

//   const NewPromptDialog({
//     Key? key,
//     required this.promptStore,
//   }) : super(key: key);

//   @override
//   _NewPromptDialogState createState() => _NewPromptDialogState();
// }

// class _NewPromptDialogState extends State<NewPromptDialog> {
//   bool isPublicPrompt = false;
//   String selectedLanguage = 'English';
//   String selectedCategory = PROMPT_CATEGORY_ITEM.entries.last.value['value'];

//   // var store data
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController contentController = TextEditingController();

//   final PromptStore promptStore = PromptStore();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       contentPadding: const EdgeInsets.all(16.0),
//       backgroundColor: Colors.white,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'New Prompt',
//             style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
                
//                 ChoiceChip(
//                       label: Text('Public Prompt'),
//                       labelStyle: TextStyle(
//                         color:
//                             isPublicPrompt ? Colors.white : Colors.black,
//                       ),
//                       selectedColor: Colors.blue,
//                       backgroundColor: Colors.white,
//                       selected: isPublicPrompt,
//                       onSelected: (selected) {
//                         setState(() {
//                           isPublicPrompt = true;
//                         });
                        
//                       },
//                     ),
//                     SizedBox(width: 8),
//                     ChoiceChip(
//                       label: Text('Private Prompt'),
//                       labelStyle: TextStyle(
//                         color: !isPublicPrompt ? Colors.white : Colors.black,
//                       ),
//                       selectedColor: Colors.blue,
//                       backgroundColor: Colors.white,
//                       selected: !isPublicPrompt,
//                       onSelected: (selected) {
//                         setState(() {
//                           isPublicPrompt = false;
//                         });
                       
//                       },
//                     ),
//               ],
//             ),
//             if (isPublicPrompt) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Prompt Language',
//                 style: TextStyle(color: Colors.black),
//               ),
//               DropdownButton<String>(
//                 value: selectedLanguage,
//                 dropdownColor: Colors.grey[200],
//                 items: <String>['English', 'Vietnamese', 'Spanish']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value,
//                         style: const TextStyle(color: Colors.black)),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedLanguage = newValue!;
//                   });
//                 },
//               ),
//             ],
//             SizedBox(height: 16),
//             CommonTextField(
//               title: 'Title',
//               hintText: 'Title of the prompt',
//               controller: titleController,
//             ),
//             if (isPublicPrompt) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Category',
//                 style: TextStyle(color: Colors.black),
//               ),
//               DropdownButton<String>(
//                 value: selectedCategory,
//                 dropdownColor: Colors.grey[800],
//                 items: PROMPT_CATEGORY_ITEM.entries
//                     .map<DropdownMenuItem<String>>((entry) {
//                   return DropdownMenuItem<String>(
//                     value: entry.value['value'],
//                     child: Text(entry.value['label'],
//                         style: TextStyle(color: Colors.black)),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedCategory = newValue!;
//                   });
//                 },
//               ),
//             ],
//             SizedBox(height: 16),
//             CommonTextField(
//               title: 'Description (Optional)',
//               hintText:
//                   'Describe your prompt so others can have a better understanding',
//               maxlines: 4,
//               controller: descriptionController,
//             ),
//             SizedBox(height: 16),
//             CommonTextField(
//               title: 'Prompt',
//               hintText: 'Use square brackets [ ] to specify user input.',
//               maxlines: 4,
//               controller: contentController,
//             ),
//           ],
//         ),
//       ),
//       actions: [
        
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//           ),
//           onPressed: () {
//             promptStore.createPrompt(
//                 titleController.text,
//                 contentController.text,
//                 descriptionController.text,
//                 selectedCategory,
//                 selectedLanguage,
//                 isPublicPrompt);
//             Navigator.pop(context);
//           },
//           child: Text('Save', style: TextStyle(color: Colors.white)),
//         ),
//         SizedBox(width: 8),
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//         ),
//       ],
//     );
//   }
// }
