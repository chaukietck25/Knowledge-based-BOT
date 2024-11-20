// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:knowledge_based_bot/data/models/prompt_model.dart' as prompt_model;
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
                showPromptDialog(context, prompt as prompt_model.Prompt);
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
                  'Written by ${prompt.userName}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Description: ${prompt.description}', style: TextStyle(fontStyle: FontStyle.italic)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Prompt', style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.blue.withAlpha(30),
            highlightColor: Colors.blue.withAlpha(30),
                      child: IconButton(
                        onPressed: (){
                      
                          Clipboard.setData(ClipboardData(text: prompt.content));
                          
                          
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
            TextButton(
              child: Text('Update'),
              onPressed: () {
                // Thêm logic cập nhật prompt ở đây
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                // Thêm logic xóa prompt ở đây
              },
            ),
          ],
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text('Use this prompt'),
            onPressed: () {
              // Thêm logic sử dụng prompt ở đây
            },
          ),
        ],
      );
    },
  );
}