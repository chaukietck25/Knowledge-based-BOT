import 'package:flutter/material.dart';
import 'createBotScreen.dart';

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
      MaterialPageRoute(builder: (context) => const CreateBotScreen()),
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
