// lib/widgets/chat_input_field.dart

import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/views/conversation/conversation_history.dart';
import 'dart:async';
import '../store/chat_store.dart';
import '../provider_state.dart';

import '../store/prompt_store.dart';
import 'package:knowledge_based_bot/views/prompts%20library/prompts_library_screens.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart'; // Add this line to import the Prompt model
import 'package:knowledge_based_bot/widgets/common_text_field.dart'; // Add this line to import CommonTextField
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // **Added**: Import Observer



class ChatInputField extends StatefulWidget {
  final ChatStore chatStore;

  ChatInputField({super.key, required this.chatStore});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  String? refreshToken = ProviderState.getRefreshToken();
  String? accessToken = ProviderState.getAccessToken();

  final PromptStore promptStore = PromptStore(); // **Added**: Create an instance of PromptStore

  var prompts = <Prompt>[]; // **Added**: Create a list of prompts

  void initState() {
    super.initState();
    promptStore.fetchPrompts().then((value) {
      prompts = promptStore.prompts;
    }); // **Added**: Fetch prompts when the widget is initialized
  }

  

  final GlobalKey _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  
  
  void _showOverlay(BuildContext context) {
    final RenderBox? textFieldRenderBox = _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (textFieldRenderBox == null) return;
    final RenderBox overlayRenderBox = Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = textFieldRenderBox.localToGlobal(Offset.zero, ancestor: overlayRenderBox);
    final size = textFieldRenderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        bottom: overlayRenderBox.size.height - position.dy + 10, // Đẩy menu lên trên
        width: size.width,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 4.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *0.4, // Chiều cao tối đa của menu
              maxWidth: MediaQuery.of(context).size.width * 0.7 // Chiều rộng tối đa của menu
            ),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: Colors.blue.withOpacity(0.1),

                  title: Text(prompts[index].title,softWrap: true, maxLines: null, style: TextStyle(fontWeight: FontWeight.bold,),),
                  //subtitle: Text(prompts[index].description),
                  onTap: () {
                    showUsePromptBottomSheet(context, prompts[index]);
                    _hideOverlay();
                  },
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _hideOverlay();
                    }
                  },
                );
              },
              
                      )),
        ),
      ),
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // **Prompt Library Button**
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.pen, // Biểu tượng bút viết từ Font Awesome
              color: Colors.black,
              size: 15,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => PromptLibraryModal(),
                isScrollControlled: true,
              ).then((value) {
                _controller.clear();
                _controller.text =
                    (ProviderState.getMsg() ?? '').replaceAll('\n', ' ');
              });
            },
          ),

          // **Message Input Field**
          Expanded(
            child: TextField(
              key: _textFieldKey,
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  widget.chatStore.sendMessage(value, refreshToken);
                  _controller.clear();
                }
              },
              onChanged: (value) {
                if (value.endsWith('/')) {
                  _showOverlay(context);
                } else {
                  _hideOverlay();
                }
              },
            ),
          ),

          const SizedBox(width: 10),

          // **Send Button with Loading Indicator**
          Observer(
            builder: (_) {
              if (widget.chatStore.isSending) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    String message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      widget.chatStore.sendMessage(message, refreshToken);
                      _controller.clear();
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),

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
                      updatedContent = '${contentController.text} \n\nInput: ${msgController.text}';

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
                       
                      
                    },
                  ),
                  
                ],
              ),
            ),
          ),
        );
      }).then((value) {
        _controller.clear();
        _controller.text = (ProviderState.getMsg() ?? '').replaceAll('\n', ' ');

      });
}


 
}
