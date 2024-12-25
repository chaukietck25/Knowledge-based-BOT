// lib/views/about/term_security_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermSecurityScreen extends StatelessWidget {
  const TermSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String markdownData = '''
# Chính Sách Bảo Mật

**Ngày hiệu lực: 25/12/2024**

## 1. Thu Thập Thông Tin

Chúng tôi thu thập thông tin cá nhân mà bạn cung cấp khi đăng ký, sử dụng ứng dụng, hoặc tương tác với các tính năng trong ứng dụng.

## 2. Sử Dụng Thông Tin

Thông tin cá nhân của bạn được sử dụng để:

- Cải thiện chất lượng dịch vụ.
- Cung cấp trải nghiệm người dùng tùy chỉnh.
- Gửi thông báo và cập nhật về ứng dụng.

## 3. Bảo Vệ Thông Tin

Chúng tôi áp dụng các biện pháp bảo mật kỹ thuật và quản lý để bảo vệ thông tin cá nhân của bạn khỏi truy cập trái phép, mất mát, hoặc thay đổi.

## 4. Chia Sẻ Thông Tin

Chúng tôi không chia sẻ thông tin cá nhân của bạn với bên thứ ba, trừ khi có sự đồng ý của bạn hoặc khi pháp luật yêu cầu.

## 5. Quyền của Bạn

Bạn có quyền:

- Yêu cầu truy cập và chỉnh sửa thông tin cá nhân của mình.
- Yêu cầu xóa thông tin cá nhân của mình khỏi hệ thống.

## 6. Liên Hệ

Nếu bạn có bất kỳ câu hỏi nào về chính sách bảo mật này, vui lòng liên hệ với chúng tôi qua mục **Liên hệ** trong ứng dụng.

**Cảm ơn bạn đã tin tưởng và sử dụng ứng dụng của chúng tôi!**
    ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chính sách bảo mật',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Markdown(
        data: markdownData,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          p: const TextStyle(fontSize: 16, color: Colors.black),
          strong: const TextStyle(fontWeight: FontWeight.bold),
          listBullet: const TextStyle(fontSize: 16, color: Colors.black),
          blockSpacing: 12.0,
        ),
      ),
    );
  }
}
