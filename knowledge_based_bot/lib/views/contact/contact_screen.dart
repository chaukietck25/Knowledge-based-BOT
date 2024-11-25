import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  final List<String> issueTypes = ["Báo cáo lỗi", "Yêu cầu tính năng", "Khác"];

  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Liên hệ chúng tôi'),
    //       leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () {
    //           // Handle back button press
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Center(
    //               child: Column(
    //                 children: [
    //                   CircleAvatar(
    //                     radius: 40,
    //                     backgroundColor: Colors.grey,
    //                     child: Icon(Icons.person, size: 40, color: Colors.white),
    //                   ),
    //                   SizedBox(height: 8),
    //                   Text(
    //                     'ChatBOT',
    //                     style:
    //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(height: 16),
    //             Text(
    //               'Liên hệ chúng tôi',
    //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //             ),
    //             SizedBox(height: 8),
    //             Text(
    //               'Do sự chênh lệch về múi giờ và giờ làm việc, phản hồi của bạn sẽ được xử lý trong vòng 48 giờ làm việc. Vui lòng kiểm tra email để nhận phản hồi của chúng tôi.',
    //             ),
    //             SizedBox(height: 16),
    //             DropdownButtonFormField<String>(
    //               decoration: InputDecoration(
    //                 labelText: 'Loại vấn đề',
    //                 border: OutlineInputBorder(),
    //               ),
    //               items: issueTypes.map((String issue) {
    //                 return DropdownMenuItem<String>(
    //                   value: issue,
    //                   child: Text(issue),
    //                 );
    //               }).toList(),
    //               onChanged: (String? newValue) {
    //                 // Handle change
    //               },
    //             ),
    //             SizedBox(height: 16),
    //             TextFormField(
    //               decoration: InputDecoration(
    //                 labelText: 'Tóm tắt lỗi',
    //                 hintText:
    //                     'Hãy cho chúng tôi biết điều gì đã sai trong vài từ.',
    //                 border: OutlineInputBorder(),
    //               ),
    //             ),
    //             SizedBox(height: 16),
    //             TextFormField(
    //               decoration: InputDecoration(
    //                 labelText: 'Chi tiết lỗi',
    //                 hintText:
    //                     'Vui lòng mô tả chi tiết điều gì đã sai, bất kỳ hành động nào bạn đã thực hiện và thông báo lỗi mà bạn đã nhận được.',
    //                 border: OutlineInputBorder(),
    //               ),
    //               maxLines: 5,
    //             ),
    //             SizedBox(height: 16),
    //             TextFormField(
    //               decoration: InputDecoration(
    //                 labelText: 'Địa chỉ email của bạn',
    //                 hintText:
    //                     'Nhập địa chỉ email để nhận thông tin cập nhật về vấn đề.',
    //                 border: OutlineInputBorder(),
    //               ),
    //               keyboardType: TextInputType.emailAddress,
    //             ),
    //             SizedBox(height: 16),
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.red, // Corrected from 'primary'
    //                   foregroundColor: Colors.white, // Corrected from 'onPrimary'
    //                   minimumSize: Size(double.infinity, 50),
    //                 ),
    //                 onPressed: () {
    //                   // Handle logout
    //                 },
    //                 child: Text('Gửi'),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        title: const Text('Liên hệ với chúng tôi'),
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(41, 40, 44, 1)),
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
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ChatBOT',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(41, 40, 44, 1)),
                    ),
                    Text(
                      'version',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loại vấn đề',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Chọn loại vấn đề bạn gặp phải',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: issueTypes.map((String issue) {
                        return DropdownMenuItem<String>(
                          value: issue,
                          child: Text(issue),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle change
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm tắt lỗi',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vấn đề bạn gặp phải',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết vấn đề bạn gặp phải',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vui lòng mô tả chi tiết điều gì đã sai, bất kỳ hành động nào bạn đã thực hiện và thông báo lỗi mà bạn đã nhận được.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vui lòng nhập ở đây...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 7,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Địa chỉ email của bạn',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Địa chỉ email để chúng tôi liên hệ với bạn về vấn đề này.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Vui lòng nhập ở đây...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Corrected from 'primary'
                    foregroundColor: Colors.white, // Corrected from 'onPrimary'
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // Handle logout
                  },
                  child: const Text('Gửi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
