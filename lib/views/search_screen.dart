import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Hành động khi nhấn nút "Tạo"
            },
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
                fillColor: Colors.grey,
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
                  buildCategoryChip('Celebrity'),
                  buildCategoryChip('My bots', isSelected: true),
                  buildCategoryChip('Top'),
                  buildCategoryChip('Models'),
                  buildCategoryChip('Pro'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  buildBotListItem(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // Hành động khi nhấn vào chip
        },
        backgroundColor: Colors.grey[800],
        selectedColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget buildBotListItem() {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/monica.png'), // Thay bằng đường dẫn hình ảnh của bạn
        ),
        title: const Text('Monica'),
        onTap: () {
          // Hành động khi nhấn vào item
        },
      ),
    );
  }
}