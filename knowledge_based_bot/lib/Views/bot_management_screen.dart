import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Views/chat_pdf_img_screen.dart';
import 'package:knowledge_based_bot/Views/prompt_library_screen.dart';
import 'package:knowledge_based_bot/Views/translation_screen.dart';
import '../widgets/search_bar.dart'
    as custom; // Use an alias for your custom SearchBar
import '../widgets/memo_item.dart';
import 'createBotScreen.dart';

class MonicaSearch extends StatefulWidget {
  const MonicaSearch({super.key});

  @override
  State<MonicaSearch> createState() => _MonicaSearchState();
}

class _MonicaSearchState extends State<MonicaSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const custom.SearchBar(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromRGBO(41, 40, 44, 1), //Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text('Công cụ'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromRGBO(41, 40, 44, 1), //Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Handle upgrade button press
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TranslateScreen()));
                        },
                        child: const Text('Phiên dịch'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromRGBO(41, 40, 44, 1), //Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Handle upgrade button press
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPdfImageScreen()));
                        },
                        child: const Text('ChatPDF'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromRGBO(41, 40, 44, 1), //Colors.grey[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // Handle upgrade button press
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPdfImageScreen()));
                        },
                        child: const Text('More'),
                      ),
                      // buildCategoryChip('Công cụ', 0),
                    ],
                  ),
                ), // Use the alias for your custom SearchBar
                Expanded(
                  child: ListView(
                    children: const [
                      MemoItem(
                        title: 'Computer science',
                        description:
                            '... Computer science Computer science Computer science is the study of computation, information, and automation ... with computational science. ... Computer Science and Engineering Research Study. Computer...',
                        time: 'Reading • 3 days ago',
                      ),
                      MemoItem(
                        title: 'Computer science',
                        description:
                            '... Computer science Computer science Computer science is the study of computation, information, and automation ... with computational science. ... Computer Science and Engineering Research Study. Computer...',
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Simulate fetching data from an API
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _items = [
        {'title': 'Celebrity 1', 'image': 'assets/celebrity1.png'},
        {'title': 'Celebrity 2', 'image': 'assets/celebrity2.png'},
        {'title': 'Celebrity 3', 'image': 'assets/celebrity3.png'},
        // Add more items as needed
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onChipSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCreateBotScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateBotScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bots'),
        actions: [
          Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Tạo'),
                onPressed: _navigateToCreateBotScreen,
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color.fromARGB(255, 250, 248, 248),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCategoryChip('Celebrity', 0),
                  buildCategoryChip('My bots', 1),
                  buildCategoryChip('Top', 2),
                  buildCategoryChip('Models', 3),
                  buildCategoryChip('Pro', 4),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_items.isEmpty) {
      return const CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return buildListItem(item['title']!, item['image']!);
      },
    );
  }

  Widget buildCategoryChip(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedIndex == index,
        onSelected: (bool selected) {
          _onChipSelected(index);
        },
        backgroundColor: Colors.grey[800],
        selectedColor: Colors.white,
        labelStyle: TextStyle(
          color: _selectedIndex == index ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget buildListItem(String title, String imagePath) {
    return Card(
      color: const Color.fromARGB(255, 206, 230, 218),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        title: Text(title),
        onTap: () {
          // Hành động khi nhấn vào item
        },
      ),
    );
  }
}
