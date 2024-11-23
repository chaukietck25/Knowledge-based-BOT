import 'package:flutter/material.dart';
import 'dart:async';
import '../store/chat_store.dart';
import '../provider_state.dart';

import '../store/prompt_store.dart';
import 'package:knowledge_based_bot/Views/prompts%20library/prompts_library_screens.dart';

// ignore: must_be_immutable
class ChatInputField extends StatelessWidget {
  final ChatStore chatStore;
  ChatInputField({super.key, required this.chatStore});

  final TextEditingController _controller = TextEditingController();
  String? refreshToken = ProviderState.getRefreshToken();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          IconButton(icon: const Icon(Icons.photo), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.insert_drive_file), onPressed: () {}),
          Expanded(
            child: TextField(
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
                  chatStore.sendMessage(value, refreshToken);
                  _controller.clear();
                },
                onChanged: (value) {
                  if (value.endsWith('/')) {
                    

                    final PromptStore promptStore = PromptStore();
                    final prompts = promptStore.prompts;
                    OverlayState overlayState = Overlay.of(context);
                    late OverlayEntry overlayEntry;
                  
                    overlayEntry = OverlayEntry(
                      builder: (context) => Positioned(
                        bottom: 100,
                        left: MediaQuery.of(context).size.width * 0.15,
                        right: MediaQuery.of(context).size.width * 0.55,
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                  // height: MediaQuery.of(context).size.height * 0.07,
                                  // width: MediaQuery.of(context).size.width * 0.05,
                                  height: 60,
                                  width: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Open Prompt Library'),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      PromptLibraryModal(),
                                                  isScrollControlled: true,
                                                ).then((value) {
                                                  _controller.clear();
                                                  
                                                  _controller.text = (ProviderState.getMsg() ?? '').replaceAll('\n', ' ');
                                                });

                                                overlayEntry.remove();
                                              },
                                              child: Text('Open')),
                                          ElevatedButton(
                                            onPressed: () {
                                              overlayEntry.remove();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))),
                        ),
                      ),
                    );

                    overlayState.insert(overlayEntry);
                  }
                }),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              chatStore.sendMessage(_controller.text, refreshToken);
              _controller.clear();
            },
          ),
          IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showModalBottomSheet(
                        
                        context: context,
                        builder: (context) => PromptLibraryModal(),
                        isScrollControlled: true,
                      ).then((value) {
                                                  _controller.clear();
                                                  
                                                  _controller.text = (ProviderState.getMsg() ?? '').replaceAll('\n', ' ');
                                                });;
                    }),
        ],
      ),
    );
  }
}

void showPromptOverlay(BuildContext context, Completer<void> completer) {
  final PromptStore promptStore = PromptStore();
  final prompts = promptStore.prompts;
  OverlayState overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 150,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.6,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                // height: MediaQuery.of(context).size.height * 0.07,
                // width: MediaQuery.of(context).size.width * 0.05,
                height: 60,
                width: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Open Prompt Library'),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => PromptLibraryModal(),
                                isScrollControlled: true,
                              );

                              overlayEntry.remove();
                            },
                            child: Text('Open')),
                        ElevatedButton(
                          onPressed: () {
                            overlayEntry.remove();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    )
                  ],
                ))),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
