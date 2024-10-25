import 'package:flutter/material.dart';

class UploadSection extends StatelessWidget {
  const UploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.upload_file,
            size: 50,
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          Text(
            'Click or drag file to this page to upload',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            '(4 / 10) total',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            'Support: PDF  Doc  PPT',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}