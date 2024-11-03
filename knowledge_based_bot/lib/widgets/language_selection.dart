import 'package:flutter/material.dart';

class LanguageSelection extends StatelessWidget {
  const LanguageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ChoiceChip(
          label: Text('Vietnamese - Detected'),
          selected: true,
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text('English'),
          selected: false,
        ),
        SizedBox(width: 10),
        ChoiceChip(
          label: Text('Spanish'),
          selected: false,
        ),
      ],
    );
  }
}