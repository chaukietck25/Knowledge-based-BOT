// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart'
    as prompt_model;
import 'package:knowledge_based_bot/data/models/prompt_model.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:flutter/services.dart';

class RenderListPrompt extends StatelessObserverWidget {
  final PromptStore promptStore;

  const RenderListPrompt({
    required this.promptStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        //final prompts = isFiltered ? promptStore.filteredPrompts : promptStore.prompts;
        final prompts = promptStore.filteredPrompts;
        if (prompts.length == 0) {
          return Center(
            child: Text('No prompts found'),
          );
        }

        return ListView.separated(
          itemCount: prompts.length,
          itemBuilder: (context, index) {
            final prompt = prompts[index];
            return PromptTile(
              title: prompt.title,
              description: prompt.description,
              isFavorite: prompt.isFavorite,
              onInfoPressed: () {
                showPromptDialog(context, prompt as prompt_model.Prompt);
                promptStore.privatePrompts();
              },
              onFavoritePressed: () {
                if (!prompt.isFavorite) {
                  promptStore.toggleFavorite(prompt.id);
                  promptStore.filterByFavorite();
                } else {
                  //promptStore.toggleFavorite(prompt.id);
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

void showPromptDialog(BuildContext context, prompt_model.Prompt prompt) {
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
            Text(prompt.title),
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
                  '${prompt.category} - ${prompt.userName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Description: ${prompt.description}',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Prompt',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
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
          if (!prompt.isPublic) ...[
            ElevatedButton(
              child: Text('Update', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Thêm logic cập nhật prompt ở đây
                showUpdatePromptDialog(context, prompt);
              },
            ),
          ],
          ElevatedButton(
            child: Text('Use this prompt'),
            onPressed: () {
              // Thêm logic sử dụng prompt ở đây
            },
          ),
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

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
                CommonTextField(
                  title: 'Title',
                  hintText: 'Title of the prompt',
                  controller: titleController,
                ),
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
                onPressed: () {
                  // promptStore.removePrompt(prompt.id);
                  // promptStore.privatePrompts();
                  // Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              'Are you sure you want to remove this prompt?'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  promptStore.removePrompt(prompt.id);
                                  promptStore.privatePrompts();

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.red),
                                )),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                )),
            ElevatedButton(
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
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      });
}

// class UsePromptBottomSheet extends StatefulWidget {
//   final Prompt prompt;

//   const UsePromptBottomSheet({required this.prompt});

//   @override
//   _UsePromptBottomSheetState createState() => _UsePromptBottomSheetState();
// }

// class _UsePromptBottomSheetState extends State<UsePromptBottomSheet> {

//     @override
//     Widget build(BuildContext context) {
//       final PromptStore promptStore = PromptStore();
  
//       TextEditingController msgController = TextEditingController();
//       TextEditingController contentController =
//           TextEditingController(text: widget.prompt.content);
  
//       String selectedLanguage = 'Auto';
  
//       return Container(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       widget.prompt.title,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Spacer(),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 ),
//                 Text(
//                   '${widget.prompt.category} - ${widget.prompt.userName}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Improve your spelling and grammar by correcting errors in your writing.',
//                 ),
//                 SizedBox(height: 10),
//                 CommonTextField(
//                   title: 'Prompt',
//                   hintText: '',
//                   controller: contentController,
//                   maxlines: 4,
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Output Language',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     DropdownButton<String>(
//                       value: selectedLanguage,
//                       dropdownColor: Colors.grey[200],
//                       items: <String>['English', 'Vietnamese', 'Auto']
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value,
//                               style: const TextStyle(color: Colors.black)),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedLanguage = newValue!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 CommonTextField(
//                     title: 'Text',
//                     hintText: '...',
//                     controller: msgController,
//                     maxlines: 3),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text('Add to chat input',
//                       style: TextStyle(color: Colors.white)),
//                   onPressed: () {
//                     promptStore.addPromptToChatInput(
//                       contentController.text,
//                       msgController.text,
//                       selectedLanguage,
//                     );
  
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }


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
          //height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed

          // child: DraggablScrollableSheet(
          //   expand: true,
          //   builder: (context, scrollController) {
          //     return
          child: SingleChildScrollView(
            //controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        prompt.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Text(
                    '${prompt.category} - ${prompt.userName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Improve your spelling and grammar by correcting errors in your writing.',
                  ),
                  SizedBox(height: 10),
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
                      Text(
                        'Output Language',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        dropdownColor: Colors.grey[200],
                        items: <String>['English', 'Vietnamese', 'Auto']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          selectedLanguage = newValue!;
                        },
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
                      promptStore.addPromptToChatInput(
                        contentController.text,
                        msgController.text,
                        selectedLanguage,
                      );

                      Navigator.of(context).pop();
                    },
                  ),
                  // if (prompt.isPublic) ...[
                  //   SizedBox(height: 10),
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       TextButton(
                  //         child: Text('Update'),
                  //         onPressed: () {
                  //           // Thêm logic cập nhật prompt ở đây
                  //         },
                  //       ),
                  //       TextButton(
                  //         child: Text('Remove'),
                  //         onPressed: () {
                  //           // Thêm logic xóa prompt ở đây
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        );
      });
}
