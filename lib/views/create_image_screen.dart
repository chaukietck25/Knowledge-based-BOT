import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class CreateImageScreen extends StatefulWidget {
  const CreateImageScreen({super.key});

  @override
  _CreateImageScreenState createState() => _CreateImageScreenState();
}

class _CreateImageScreenState extends State<CreateImageScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  void _createImage() {
    // Implement the logic to create the image
    final String title = _titleController.text;
    if (_imageBytes != null && title.isNotEmpty) {
      // Perform the image creation logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image created with title: $title')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title and select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo ảnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Title:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter image title',
              ),
            ),
            const SizedBox(height: 20),
            _imageBytes == null
                ? const Text('No image selected.')
                : Image.memory(_imageBytes!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                ElevatedButton(
                  onPressed: _createImage,
                  child: const Text('Create Image'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}