// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/utils/prompt_category.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart';
import 'package:knowledge_based_bot/provider_state.dart';


// show prompt dialog
class PromptLibraryModal extends StatefulWidget {
  const PromptLibraryModal({super.key});

  @override
  _PromptLibraryModalState createState() => _PromptLibraryModalState();
}

class _PromptLibraryModalState extends State<PromptLibraryModal> {
  // var store selection of user to display prompt
  bool isMyPromptSelected = false;
  bool isFavoriteSelected = false;
  bool showAllCategories = false;
  String selectedCategory = 'all';

  //search controller
  final TextEditingController _searchController = TextEditingController();

  //mobx
  final PromptStore promptStore = PromptStore();

  bool isLoading = true;

  // Get prompt from API
  @override
  void initState() {
    super.initState();
    promptStore.fetchPrompts().then((value) {
      promptStore.getCurUser().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Completer<void> completer = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.7,
      maxChildSize: 0.9,
      snap: true,
      snapSizes: [0.8, 0.9],
      expand: false,
      builder: (context, scrollController) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // title of dialog
                            const Text(
                              'Prompt Library',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                // button add new prompt
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        SizedBox(width: 4),
                                        Text('New Prompt',
                                            style: TextStyle(color: Colors.blue)),
                                        //SizedBox(width: 4),
                                        IconButton(
                                          
                                          icon: const Icon(Icons.add,
                                              color: Colors.blue),
                                          onPressed: () {},
                                          
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      showDialog(
                                              context: context,
                                              builder: (context) => NewPromptDialog(
                                                  promptStore: promptStore),
                                            ).then((value) {
                                              promptStore.privatePrompts();
                                            });
                                    }
                                  ),
                                  
                                  
                                ),
                                SizedBox(width: 8),
                                // button close dialog
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black),
                                    onPressed: () => Navigator.pop(context),
                                  ),
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
                            // button to select public prompt
                            ChoiceChip(
                              label: Text('Public Prompt'),
                              labelStyle: TextStyle(
                                color: !isMyPromptSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.white,
                              selected: !isMyPromptSelected,
                              onSelected: (selected) {
                                setState(() {
                                  // change state of button

                                  isMyPromptSelected = false;
                                  isLoading = true;
                                  // get public prompt
                                });
                                promptStore.fetchPrompts().then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            // button to select my prompt(private prompt)
                            ChoiceChip(
                              label: Text('My Prompt'),
                              labelStyle: TextStyle(
                                color: isMyPromptSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.white,
                              selected: isMyPromptSelected,
                              onSelected: (selected) {
                                setState(() {
                                  // change state of button
                                  isMyPromptSelected = true;
                                  isLoading = true;
                                  // get private prompt
                                });
                                promptStore.privatePrompts().then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          children: [
                            // search bar
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(241, 245, 249, 1),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        // search prompt by query
                                        setState(() {
                                          isLoading = true;
                                        });

                                        promptStore.searchByAPI(
                                            _searchController.text,
                                            !isMyPromptSelected).then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                            });
                                        //searchPrompts(_searchController.text);
                                      },
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        // clear search bar
                                        _searchController.clear();
                                        // get all prompt
                                        promptStore.fetchPrompts().then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                    ),
                                    hintText: 'Search',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),

                            // button to select favorite prompt
                            Container(
                              decoration: BoxDecoration(
                                //color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black),
                              ),
                              child: IconButton(
                                icon: !isFavoriteSelected
                                    ? const Icon(Icons.star_border,
                                        color: Colors.black)
                                    : Icon(
                                        Icons.star_rate_rounded,
                                        color: Colors.yellow,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    // change state of button to change color icon
                                    isFavoriteSelected = !isFavoriteSelected;
                                    isLoading = true;
                                  });
                                  // filter prompt by favorite
                                  if (isFavoriteSelected) {
                                    promptStore
                                        .filterByFavorite()
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  } else {
                                    promptStore.fetchPrompts().then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // show category of prompt
                      // only show when user select public prompt
                      
                      Expanded(
                        child: Column(
                          children: [
                             if (!isMyPromptSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: double.infinity,
                            child: Row(
                              children: [
                                SizedBox(width: 4),
                        
                                // show all category or expand category
                                if (!showAllCategories)
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: PROMPT_CATEGORY_ITEM.entries
                                            .map((entry) {
                                          return FilterChip(
                                            label: Text(entry.value['label']),
                                            labelStyle: TextStyle(
                                              color: selectedCategory
                                                          .toLowerCase() ==
                                                      entry.value['label']
                                                          .toString()
                                                          .toLowerCase()
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            selectedColor: Colors.blue,
                                            backgroundColor:
                                                Color.fromRGBO(241, 245, 249, 1),
                        
                                            // change state of button to change color icon
                                            selected:
                                                selectedCategory.toLowerCase() ==
                                                    entry.value['label']
                                                        .toString()
                                                        .toLowerCase(),
                                            // filter prompt by category
                                            onSelected: (selected) {
                                              setState(() {
                                                selectedCategory = selected
                                                    ? entry.value['value']
                                                    : '';
                                                isLoading = true;
                                              });
                                              promptStore
                                                  .filterByCategory(
                                                      entry.value['value'])
                                                  .then((value) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                        
                                // expand category
                                if (showAllCategories)
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: PROMPT_CATEGORY_ITEM.entries
                                          .map((entry) {
                                        return FilterChip(
                                          label: Text(entry.value['label']),
                                          labelStyle: TextStyle(
                                            color:
                                                selectedCategory.toLowerCase() ==
                                                        entry.value['label']
                                                            .toString()
                                                            .toLowerCase()
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                          selectedColor: Colors.blue,
                                          backgroundColor:
                                              Color.fromRGBO(241, 245, 249, 1),
                                          selected:
                                              selectedCategory.toLowerCase() ==
                                                  entry.value['label']
                                                      .toString()
                                                      .toLowerCase(),
                                          onSelected: (selected) {
                                            setState(() {
                                              selectedCategory = selected
                                                  ? entry.value['value']
                                                  : '';
                                              isLoading = true;
                                            });
                                            promptStore
                                                .filterByCategory(
                                                    entry.value['value'])
                                                .then((value) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                SizedBox(width: 4),
                                // button to show all category
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: IconButton(
                                    icon: showAllCategories
                                        ? Icon(Icons.arrow_drop_up,
                                            color: Colors.black)
                                        : Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                    onPressed: () {
                                      // change state of button to show all category
                                      setState(() {
                                        showAllCategories = !showAllCategories;
                                      });
                                    },
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
                        // show list of prompt
                        Expanded(child: Observer(
                          builder: (_) {
                            //final prompts = isFiltered ? promptStore.filteredPrompts : promptStore.prompts;
                            //widget.promptStore.privatePrompts();
                        
                            // get prompt from store
                            var prompts = promptStore.filteredPrompts;
                        
                            var curUser = promptStore.curUser;
                        
                            // if no prompt found
                            if (prompts.length == 0) {
                              return Center(
                                child: Text('No prompts found'),
                              );
                            }
                        
                            // show list of prompt
                            return 
                            ListView.separated(
                              itemCount: prompts.length,
                              itemBuilder: (context, index) {
                                final prompt = prompts[index];
                        
                                // check if prompt is favorite
                                bool isFav = prompt.isFavorite;
                        
                                return PromptTile(
                                  title: prompt.title,
                                  description: prompt.description,
                                  isFavorite: isFav,
                        
                                  // show dialog to display information of prompt
                                  onInfoPressed: () {
                                    // show dialog to display information of prompt
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          insetPadding: EdgeInsets.all(20),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                            Text(prompt.title,softWrap: true,maxLines: null,),
                                            ],
                                          ),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9, // Set the width
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5, // Set the height
                        
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${prompt.category} - ${prompt.userName}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      'Description: ${prompt.description}',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic)),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Text('Prompt',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Spacer(),
                                                      InkWell(
                                                        splashColor: Colors.blue
                                                            .withAlpha(30),
                                                        highlightColor: Colors
                                                            .blue
                                                            .withAlpha(30),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Clipboard.setData(
                                                                  ClipboardData(
                                                                      text: prompt
                                                                          .content));
                                                            },
                                                            icon:
                                                                Icon(Icons.copy)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    color: Colors.grey[200],
                                                    child: TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text:
                                                                  prompt.content),
                                                      readOnly: true,
                                                      maxLines: 10,
                                                      decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            if (!prompt.isPublic ||
                                                prompt.userId ==
                                                    promptStore.curUser) ...[
                                              ElevatedButton(
                                                child: Text('Update',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  // Thêm logic cập nhật prompt ở đây
                                                  showUpdatePromptDialog(
                                                      context, prompt);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                              ),
                                            ],
                                            ElevatedButton(
                                              child: Text('Use this prompt',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                // Thêm logic sử dụng prompt ở đây
                                                showUsePromptBottomSheet(
                                                    context, prompt);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                            ),
                                            ElevatedButton(
                                              // style: ElevatedButton.styleFrom(
                                              //                 backgroundColor: Colors.blue,
                                              //               ),
                                              child: Text('Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (isFavoriteSelected) {
                                        promptStore.filterByFavorite().then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      }
                                      if(selectedCategory != 'all'){
                                        promptStore.filterByCategory(selectedCategory).then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      }
                                      if (isMyPromptSelected) {
                                        promptStore.privatePrompts().then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      }
                                      else {
                                        promptStore.fetchPrompts().then((value) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      }

                                      
                                    });
                                  },
                        
                                  // add/remove prompt to favorite list
                                  onFavoritePressed: () {
                                    if (!prompt.isFavorite) {
                                      promptStore.addToFavoriteList(prompt.id);
                        
                                      // promptStore.filterByFavorite();
                                    } else {
                                      //promptStore.toggleFavorite(prompt.id);
                                      promptStore.removeFavoriteList(prompt.id);
                                    }
                                  },
                                  onNavigatePressed: () {
                                    print('Navigate pressed');
                                  },
                        
                                  // show dialog to user can use prompt
                                  onTapPromptTile: () {
                                    showUsePromptBottomSheet(context, prompt);
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            );
                          },
                        ))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }
}

// dialog create new prompt
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
    return Observer(builder: (_) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'New Prompt',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // button to select public prompt
                    ChoiceChip(
                      label: Text('Public Prompt'),
                      labelStyle: TextStyle(
                        color: isPublicPrompt ? Colors.white : Colors.black,
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
          
                    // button to select private prompt
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
          
                // according to user selection, show textfield to input title, description, content
          
                if (isPublicPrompt) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Prompt Language',
                    style: TextStyle(color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: selectedLanguage,
                    dropdownColor: Colors.grey[200],
                    items: <String>[
                      'English',
                      'Vietnamese',
                      'Spanish',
                      'French',
                      'German',
                      'Japanese',
                      'Korean',
                      'Chinese',
                      'Portuguese',
                      'Arabic',
                      'Hindi',
                      'Russian',
                      'Italian',
                      'Armenian',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
          
                    // change state of button to change language
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                  ),
                ],
                SizedBox(height: 16),
          
                // input title of prompt
                CommonTextField(
                  title: 'Title',
                  hintText: 'Title of the prompt',
                  controller: titleController,
                ),
                if (isPublicPrompt) ...[
                  const SizedBox(height: 16),
          
                  // input category of prompt
                  const Text(
                    'Category',
                    style: TextStyle(color: Colors.black),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    dropdownColor: Colors.grey[200],
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
          
                // input description of prompt
                CommonTextField(
                  title: 'Description (Optional)',
                  hintText:
                      'Describe your prompt so others can have a better understanding',
                  maxlines: 4,
                  controller: descriptionController,
                ),
                SizedBox(height: 16),
          
                // input content of prompt
                CommonTextField(
                  title: 'Prompt',
                  hintText: 'Use square brackets [ ] to specify user input.',
                  maxlines: 4,
                  controller: contentController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          // button to save prompt
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
            child: Text('Create', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),

          // button to cancel, close dialog
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    });
  }
}


void showUsePromptBottomSheet(BuildContext context, Prompt prompt) {
  final PromptStore promptStore = PromptStore();

  TextEditingController msgController = TextEditingController();
  TextEditingController contentController =
      TextEditingController(text: prompt.content);

  String selectedLanguage = 'Auto';

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          

          child: SingleChildScrollView(
            //controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Text(
                        prompt.title,
                        softWrap: true,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // category and user name
                  Text(
                    '${prompt.category} - ${prompt.userName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${prompt.description}',
                  ),
                  SizedBox(height: 10),

                  // prompt
                  CommonTextField(
                    title: 'Prompt',
                    hintText: '',
                    controller: contentController,
                    maxlines: 4,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // choose output language
                      Text(
                        'Output Language',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: LanguageDropdown(
                          selectedLanguage: selectedLanguage,
                          onChanged: (String newValue) {
                            selectedLanguage = newValue;
                          },
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(height: 10),
                  CommonTextField(
                      title: 'Text',
                      hintText: '...',
                      controller: msgController,
                      maxlines: 3),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Add to chat input',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      String updatedContent;

                      /// Use regular expressions to find and replace all elements in the form of [something] with input
                      updatedContent = contentController.text.replaceAll(
                          RegExp(r'\[.*?\]'), msgController.text + '. ');

                      /// Add a description line that will respond in the language specified by the 'language' parameter.
                      String finalContent =
                          '$updatedContent\nAnswer in language: $selectedLanguage';

                      // update msg
                      ProviderState providerState = ProviderState();
                      providerState.setMsg(finalContent);
                      print('set msg: ' + (ProviderState.getMsg() ?? ''));

                      //print('set msg: $finalContent');

                      // Navigator.of(context).pop();
                       Navigator.of(context).pop();
                       Navigator.of(context).pop();
                      
                    },
                  ),
                  
                ],
              ),
            ),
          ),
        );
      });
}

