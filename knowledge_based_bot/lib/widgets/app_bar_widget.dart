import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/logo.png', // Đảm bảo bạn có biểu tượng trong thư mục assets
            height: 40,
          ),
          const SizedBox(width: 10),
          const Text('Sider'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Product'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('ChatPDF'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Download'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Pricing'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
