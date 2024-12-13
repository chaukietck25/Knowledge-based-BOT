import 'package:flutter/material.dart';
import '../../widgets/translation_type_buttons.dart';
import '../../widgets/language_selection.dart';
import '../../widgets/text_input_section.dart';
import '../../widgets/text_output_section.dart';

class TranslateScreen extends StatelessWidget {
  const TranslateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
      body:const  Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslationTypeButtons(),
            SizedBox(height: 20),
            LanguageSelection(),
            SizedBox(height: 20),
            TextInputSection(),
            SizedBox(height: 20),
            LanguageSelection(),
            SizedBox(height: 20),
            TextOutputSection(),
          ],
        ),
      ),
    );
  }
}