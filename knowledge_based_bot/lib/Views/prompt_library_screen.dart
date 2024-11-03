import 'package:flutter/material.dart';
import '../widgets/prompt_card.dart';
import '../widgets/prompt_filter.dart';

class PromptLibraryScreen extends StatefulWidget {
  const PromptLibraryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PromptLibraryScreenState createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends State<PromptLibraryScreen> {
  final List<bool> _isSelected = [true, false];

  void _handleToggle(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Handle add action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ToggleButtons(
              // ignore: sort_child_properties_last
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('My Prompt'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Public Prompt'),
                ),
              ],
              isSelected: _isSelected,
              onPressed: _handleToggle,
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
              borderColor: Colors.black,
              selectedBorderColor: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          PromptFilter(),
          Expanded(
            child: ListView(
              children: const [
                PromptCard(
                  title: 'Grammar corrector',
                  description: 'Improve your spelling and grammar by correcting errors in your writing.',
                ),
                PromptCard(
                  title: 'Learn Code FAST!',
                  description: 'Teach you the code with the most understandable knowledge.',
                ),
                PromptCard(
                  title: 'Story generator',
                  description: 'Write your own beautiful story.',
                ),
                PromptCard(
                  title: 'Essay improver',
                  description: 'Improve your content\'s effectiveness with ease.',
                ),
                PromptCard(
                  title: 'Pro tips generator',
                  description: 'Get perfect tips and advice tailored to your field with this prompt!',
                ),
                PromptCard(
                  title: 'Resume Editing',
                  description: 'Provide suggestions on how to improve your resume to make it stand out.',
                ),
                PromptCard(
                  title: 'AI Painting Prompt Generator',
                  description: 'Input your keyword and style. Let the generator create prompts that you can make great works from a single sketch.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}