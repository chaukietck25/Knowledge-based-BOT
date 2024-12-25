// lib/views/about/term_use_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermUseScreen extends StatelessWidget {
  const TermUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String markdownData = '''
# Điều Khoản Sử Dụng

**Ngày hiệu lực: 25/12/2024**

## 1. Giới Thiệu

Chào mừng bạn đến với ứng dụng **Knowledge-Based Bot**. Bằng việc sử dụng ứng dụng này, bạn đồng ý tuân theo các điều khoản và điều kiện được đề cập dưới đây.

## 2. Sử Dụng Ứng Dụng

- **Quyền sử dụng**: Bạn được cấp một giấy phép hạn chế, không độc quyền, không chuyển nhượng để sử dụng ứng dụng này cho mục đích cá nhân.

- **Nội dung**: Bạn không được phép sử dụng ứng dụng để tạo ra, phân phối hoặc lưu trữ nội dung bất hợp pháp, độc hại hoặc vi phạm quyền sở hữu trí tuệ.

## 3. Bảo Mật

- Bạn chịu trách nhiệm bảo vệ thông tin đăng nhập và các tài khoản của mình khỏi việc truy cập trái phép.

## 4. Sửa Đổi Điều Khoản

Chúng tôi có quyền sửa đổi các điều khoản sử dụng này bất cứ lúc nào. Bạn nên kiểm tra định kỳ để cập nhật những thay đổi mới nhất.

## 5. Liên Hệ

Nếu bạn có bất kỳ câu hỏi nào về các điều khoản này, vui lòng liên hệ với chúng tôi qua mục **Liên hệ** trong ứng dụng.

**Cảm ơn bạn đã sử dụng ứng dụng của chúng tôi!**
    ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Điều khoản sử dụng',
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
