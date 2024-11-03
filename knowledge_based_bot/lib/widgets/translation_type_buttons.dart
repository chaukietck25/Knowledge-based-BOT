import 'package:flutter/material.dart';

class TranslationTypeButtons extends StatelessWidget {
  const TranslationTypeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF Translation'),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.web),
          label: const Text('Web Translation'),
        ),
      ],
    );
  }
}