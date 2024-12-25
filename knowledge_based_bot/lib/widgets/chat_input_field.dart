// lib/widgets/chat_input_field.dart

import 'package:flutter/material.dart';
import 'dart:async';
import '../store/chat_store.dart';
import '../provider_state.dart';

import '../store/prompt_store.dart';
import 'package:knowledge_based_bot/views/prompts%20library/prompts_library_screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // **Added**: Import Observer

// ignore: must_be_immutable
class ChatInputField extends StatelessWidget {
  final ChatStore chatStore;
  ChatInputField({super.key, required this.chatStore});

  final TextEditingController _controller = TextEditingController();
  String? refreshToken = ProviderState.getRefreshToken();
  String? accessToken = ProviderState.getAccessToken();

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
                  chatStore.sendMessage(value, refreshToken);
                  _controller.clear();
                }
              },
              onChanged: (value) {
                if (value.endsWith('/')) {
                  final PromptStore promptStore = PromptStore();
                  final prompts = promptStore.prompts;
                  OverlayState? overlayState = Overlay.of(context);
                  if (overlayState == null) return;
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                        _controller.text =
                                            (ProviderState.getMsg() ?? '')
                                                .replaceAll('\n', ' ');
                                      });

                                      overlayEntry.remove();
                                    },
                                    child: Text('Open'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      overlayEntry.remove();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  overlayState.insert(overlayEntry);
                }
              },
            ),
          ),

          const SizedBox(width: 10),

          // **Send Button with Loading Indicator**
          Observer(
            builder: (_) {
              if (chatStore.isSending) {
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
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    String message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      chatStore.sendMessage(message, refreshToken);
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
}
