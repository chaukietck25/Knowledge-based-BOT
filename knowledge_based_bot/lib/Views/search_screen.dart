import 'package:flutter/material.dart';
import '../widgets/search_bar.dart' as custom; // Use an alias for your custom SearchBar
import '../widgets/memo_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const custom.SearchBar(), // Use the alias for your custom SearchBar
                Expanded(
                  child: ListView(
                    children: const [
                      MemoItem(
                        title: 'Computer science',
                        description: '... Computer science Computer science Computer science is the study of computation, information, and automation ... with computational science. ... Computer Science and Engineering Research Study. Computer...',
                        time: 'Reading • 3 days ago',
                      ),
                      MemoItem(
                        title: 'Computer science',
                        description: '... Computer science Computer science Computer science is the study of computation, information, and automation ... with computational science. ... Computer Science and Engineering Research Study. Computer...',
                        time: 'Reading • 2 days ago',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}