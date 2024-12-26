// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart'
    as prompt_model;
import 'package:knowledge_based_bot/data/models/prompt_model.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:knowledge_based_bot/provider_state.dart';

import 'package:knowledge_based_bot/views/chat/chat_screen.dart';

import 'package:mobx/mobx.dart';

class RenderListPrompt extends StatefulObserverWidget {
  final PromptStore promptStore;

  final Completer<void> completer;

  const RenderListPrompt({
    required this.promptStore,
    required this.completer,
  });
  @override
  _RenderListPromptState createState() => _RenderListPromptState();
}

class _RenderListPromptState extends State<RenderListPrompt> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        //final prompts = isFiltered ? promptStore.filteredPrompts : promptStore.prompts;
        //widget.promptStore.privatePrompts();
        var prompts = widget.promptStore.filteredPrompts;
        if (prompts.length == 0) {
          return Center(
            child: Text('No prompts found'),
          );
        }

        

        return ListView.separated(
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            final prompt = prompts[index];
            bool isFav = prompt.isFavorite;

            return PromptTile(
              title: prompt.title,
              description: prompt.description,
              isFavorite: isFav,
              onInfoPressed: () {
                Completer<void> completer = Completer<void>();
                showPromptDialog(
                    context, prompt as prompt_model.Prompt, completer);
                //promptStore.privatePrompts();
                completer.future.then((_) {
                  // Thực hiện hành động sau khi showUpdatePromptDialog hoàn thành
                  setState(() {
                    widget.promptStore.fetchPrompts();
                    widget.promptStore.privatePrompts();
                    prompts = widget.promptStore.filteredPrompts;
                  });
                });
              },
              onFavoritePressed: () {
                if (!prompt.isFavorite) {
                  widget.promptStore.addToFavoriteList(prompt.id);

                  // promptStore.filterByFavorite();
                } else {
                  //promptStore.toggleFavorite(prompt.id);
                  widget.promptStore.removeFavoriteList(prompt.id);
                }
              },
              onNavigatePressed: () {
                print('Navigate pressed');
              },
              onTapPromptTile: () {
                showUsePromptBottomSheet(context, prompt);
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }
}

// dialog to show prompt details
void showPromptDialog(BuildContext context, prompt_model.Prompt prompt,
    Completer<void> completer) {

  PromptStore promptStore = PromptStore();
  promptStore.getCurUser();
  var curUser = promptStore.curUser;
  print('curUser: $curUser');
  print('prompt.userId: ${prompt.userId}');

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: EdgeInsets.all(20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Row(
          children: [
            // title of the dialog
            Text(prompt.title,softWrap: true,maxLines: null,),
            Spacer(),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Set the width
          height: MediaQuery.of(context).size.height * 0.4, // Set the height

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // category and user name
                  '${prompt.category} - ${prompt.userName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // description
                Text('Description: ${prompt.description}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Prompt',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),

                    // copy button
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      highlightColor: Colors.blue.withAlpha(30),
                      child: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: prompt.content));
                          },
                          icon: Icon(Icons.copy)),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // content
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: TextField(
                    controller: TextEditingController(text: prompt.content),
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
          // if the prompt is created by the user, show update button
          
          if (!prompt.isPublic || prompt.userId == curUser ) ...[
            ElevatedButton(
              child: Text('Update', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Thêm logic cập nhật prompt ở đây
                showUpdatePromptDialog(context, prompt);
              },
            ),
          ],

          // use this prompt button
          ElevatedButton(
            child:
                Text('Use this prompt', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Thêm logic sử dụng prompt ở đây
              showUsePromptBottomSheet(context, prompt);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),

          // close button
          ElevatedButton(
            // style: ElevatedButton.styleFrom(
            //                 backgroundColor: Colors.blue,
            //               ),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// dialog to update prompt
void showUpdatePromptDialog(BuildContext context, prompt_model.Prompt prompt) {
  bool isPrivatePrompt = true;
  String selectedLanguage = 'English';

  // var store data
  TextEditingController titleController =
      TextEditingController(text: prompt.title);
  TextEditingController descriptionController =
      TextEditingController(text: prompt.description);
  TextEditingController contentController =
      TextEditingController(text: prompt.content);

  final PromptStore promptStore = PromptStore();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Update Prompt',
                //style: TextStyle(color: Colors.white),
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
                SizedBox(height: 16),

                // title
                CommonTextField(
                  title: 'Title',
                  hintText: 'Title of the prompt',
                  controller: titleController,
                ),
                SizedBox(height: 16),

                // description
                CommonTextField(
                  title: 'Description (Optional)',
                  hintText:
                      'Describe your prompt so others can have a better understanding',
                  maxlines: 4,
                  controller: descriptionController,
                ),
                SizedBox(height: 16),

                // content
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
            // remove button
            ElevatedButton(
                onPressed: () {
                  // promptStore.removePrompt(prompt.id);
                  // promptStore.privatePrompts();
                  // Navigator.pop(context);

                  // show confirmation dialog
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Remove "${prompt.title}" ?',softWrap: true,maxLines: null,),
                          actions: [
                            Column(
                              children: [
                                Text(
                                    'Are you sure you want to remove this prompt?'),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          promptStore.removePrompt(prompt.id);

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      //   style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.blue,
                                      //                           ),
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel',
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                )),

            // save button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),

              // save button action
              onPressed: () {
                promptStore.updatePrompt(
                  prompt.id,
                  titleController.text,
                  contentController.text,
                  descriptionController.text,
                  'other',
                  selectedLanguage,
                  false,
                );
                promptStore.privatePrompts();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),

            // cancel button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }).then((value) => promptStore.privatePrompts());
}



// bottom sheet to use prompt
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

class LanguageDropdown extends StatefulWidget {
  final String selectedLanguage;
  final ValueChanged<String> onChanged;

  LanguageDropdown({required this.selectedLanguage, required this.onChanged});

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedLanguage,
      dropdownColor: Colors.grey[200],
      items: <String>[
        'Auto',
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
        'Armenian'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue!;
        });
        widget.onChanged(newValue!);
      },
    );
  }
}
