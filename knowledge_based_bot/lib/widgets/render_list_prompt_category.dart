import 'package:flutter/material.dart ';
import 'package:knowledge_based_bot/utils/prompt_category.dart';
import 'package:knowledge_based_bot/data/models/prompt_category_model.dart';

import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';


class RenderListPromptCategory extends StatelessWidget {
  PromptCategory? selectedCategory;
  final PromptStore promptStore = PromptStore();

  RenderListPromptCategory({super.key});



  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
      return  Wrap(
                                    spacing:
                                        8.0, // khoảng cách giữa các FilterChip
                                    runSpacing: 8.0, // khoảng cách giữa các dòng
                                    children:
                                        PROMPT_CATEGORY_ITEM.entries.map((entry) {
                                      return FilterChip(
                                        label: Text(entry.value['label']),
                                        onSelected: (_) {
                                          
                                            promptStore.filterByCategory('business');
                                            print('Filter by ${entry.value['label']}');
                                        },
                                      );
                                    }).toList(),
      );
                                  }
    );
  }
}

// Row(
                                    //   children: [
                                    //     FilterChip(
                                    //         label: Text('All'), onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Other'), onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Writing'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Marketing'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Chatbot'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Seo'), onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Career'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Coding'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Productivity'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Education'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Business'),
                                    //         onSelected: (_) {}),
                                    //     const SizedBox(width: 8),
                                    //     FilterChip(
                                    //         label: Text('Fun'), onSelected: (_) {}),
                                    //   ],
                                    // ),