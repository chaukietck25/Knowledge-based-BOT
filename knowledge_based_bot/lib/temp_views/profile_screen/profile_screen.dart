import 'package:flutter/material.dart';
import 'package:knowledge_based_bot/Views/auth/onboarding_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông tin'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Handle back button press
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () {
//               // Handle avatar change
//
//             child: CircleAvatar(
//               radius: 40,
//               backgroundColor: Colors.grey,
//               child: Icon(Icons.person, size: 40, color: Colors.white),
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Nhấp để thay đổi hình đại diện',
//             style: TextStyle(color: Colors.grey),
//           ),
//           SizedBox(height: 16),
//           ListTile(
//             title: Text('Tên'),
//             trailing: Text('Pvhd'),
//             onTap: () {
//               // Handle name change
//               //change name
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   TextEditingController nameController =
//                       TextEditingController();
//                   return AlertDialog(
//                     title: Text('Thay đổi tên'),
//                     content: TextField(
//                       controller: nameController,
//                       decoration: InputDecoration(hintText: "Nhập tên mới"),
//                     ),
//                     actions: <Widget>[
//                       TextButton(
//                         child: Text('Hủy'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       TextButton(
//                         child: Text('Lưu'),
//                         onPressed: () {
//                           // Handle name change logic here
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('Email'),
//             subtitle: Text('Phamdang7702@gmail.com'),
//             trailing: Icon(Icons.copy),
//             onTap: () {
//               // Handle email change
//             },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('ID người dùng'),
//             subtitle: Text('126ee27cad4c4bd6b9291caeb7bfcc23'),
//             trailing: Icon(Icons.copy),
//             onTap: () {
//               // Handle user ID copy
//             },
//           ),
//           Divider(),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Corrected from 'primary'
//                 foregroundColor: Colors.white, // Corrected from 'onPrimary'
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               onPressed: () {
//                 // Handle logout
//               },
//               child: Text('Đăng xuất'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Pvhd";
  String email = "phamdang7702@gmail.com";
  String userId = "126ee27cad4c4bd6b9291caeb7bfcc23";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Thông tin',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Handle avatar tap
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Thay đổi hình đại diện'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Chụp ảnh mới'),
                              onTap: () {
                                // Handle taking a new photo
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Chọn từ thư viện'),
                              onTap: () {
                                // Handle picking from gallery
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhấp để thay đổi hình đại diện',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildInfoTile('Tên', username, Icons.arrow_forward_ios),
              _buildInfoTile('Email', email, Icons.copy),
              _buildInfoTile('ID người dùng', userId, Icons.copy),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Handle logout button press
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData trailingIcon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Icon(trailingIcon, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
