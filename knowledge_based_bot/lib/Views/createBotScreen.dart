import 'package:flutter/material.dart';

class CreateBotScreen extends StatefulWidget {
  @override
  _CreateBotScreenState createState() => _CreateBotScreenState();
}

class _CreateBotScreenState extends State<CreateBotScreen> {
  String selectedModel = 'GPT-3'; // Initialize with a default value
  String selectedPermission = 'Công khai'; //permission
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: Text('Tạo bot'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle automatic creation
            },
            child: Text(
              'Tạo tự động',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                //child: Icon(Icons.cube, size: 40, color: Colors.white),
              ),
              SizedBox(height: 16),
              // ElevatedButton.icon(
              //   onPressed: () {},
              //   icon: Icon(Icons.copy),
              //   label: Text('Sao chép từ mạng xã hội'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black,
              //     side: BorderSide(color: Colors.grey),
              //   ),
              // ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên BOT',
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vui lòng nhập ở đây...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              
              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mô tả cài đặt',
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ví dụ: Bạn là một nhà văn khoa học viễn tưởng giàu kinh nghiệm. Bạn xuất sắc trong việc tạo ra những thế giới tương lai độc đáo và cốt truyện hấp dẫn.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              ListTile(
                title: Text('Mô hình'),
                // trailing text should be replaced with selected model
                tileColor: Colors.grey[200],
                trailing: Text(selectedModel), // Replace with selected model
                onTap: () {
                  // open model selection dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Chọn mô hình'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('GPT-3'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-3';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('GPT-4'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-4';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('GPT-4o mini'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedModel = 'GPT-4o mini';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('Quyền hạn'),
                tileColor: Colors.grey[200],
                onTap: () {
                  // Handle permission selection
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thay đổi quyền', style: TextStyle(color: Colors.black)),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: Text('Chỉ mình tôi'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission = 'Chỉ mình tôi';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text('Bất kì ai có đường liên kết'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission =
                                        'Bất kì ai có đường liên kết';
                                  });
                                },
                              ),
                              Padding(padding: EdgeInsets.all(8.0)),
                              GestureDetector(
                                child: Text(
                                    'Công khai - Mọi người đều có thể truy cập'),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // Replace trailing text with selected model
                                    selectedPermission =
                                        'Công khai - Mọi người đều có thể truy cập';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mô tả',
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText:                       'Ví dụ: Tôi là một nhà văn khoa học viễn tưởng có kinh nghiệm.',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle bot creation
                },
                child: Text('Tạo bot'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CreateBotScreen extends StatefulWidget {
//   const CreateBotScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CreateBotScreenState createState() => _CreateBotScreenState();
// }

// class _CreateBotScreenState extends State<CreateBotScreen> {
//   String _selectedPermission = 'Public';

//   void _showModelSelection(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: const Color(0xFF1D1D1D), // Màu nền của modal bottom sheet
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.model_training, color: Colors.white),
//                 title: const Text('GPT-4o mini', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   // Hành động khi chọn GPT-4o mini
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.model_training, color: Colors.white),
//                 title: const Text('Claude 3.5 Sonnet', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   // Hành động khi chọn Claude 3.5 Sonnet
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.model_training, color: Colors.white),
//                 title: const Text('GPT-4o', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   // Hành động khi chọn GPT-4o
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showPermissionSelection(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           color: const Color(0xFF1D1D1D), // Màu nền của modal bottom sheet
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.lock, color: Colors.white),
//                 title: const Text('Chỉ mình tôi', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   setState(() {
//                     _selectedPermission = 'Chỉ mình tôi';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.link, color: Colors.white),
//                 title: const Text('Bất kỳ ai có liên kết', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   setState(() {
//                     _selectedPermission = 'Bất kỳ ai có liên kết';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.public, color: Colors.white),
//                 title: const Text('Công khai • Mọi người đều có thể thấy', style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   setState(() {
//                     _selectedPermission = 'Công khai • Mọi người đều có thể thấy';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tạo bot'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Tên bot',
//                 labelText: 'Tên',
//                 filled: true,
//                 fillColor: Color.fromARGB(255, 250, 248, 248),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 hintText: 'Mô tả Cài Đặt',
//                 labelText: 'Mô tả Cài Đặt',
//                 filled: true,
//                 fillColor: Color.fromARGB(255, 250, 248, 248),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _showModelSelection(context);
//               },
//               child: const Text('Mô Hình'),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 _showPermissionSelection(context);
//               },
//               child: Text(_selectedPermission),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }