// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/store/prompt_store.dart';
import 'package:knowledge_based_bot/widgets/widget.dart';

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
        if(prompts.length == 0){
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
              onInfoPressed: () {
                print('Info pressed');
              },
              onFavoritePressed: () {
                print("id: ${prompt.id}");
                promptStore.toggleFavorite(prompt.id);
              },
              onNavigatePressed: () {
                print('Navigate pressed');
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }
}
