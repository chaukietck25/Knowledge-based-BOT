import 'package:flutter/material.dart';

class CommonTextField  extends StatelessWidget {
  const CommonTextField ({super.key, required this.title, required this.hintText,  this.controller, this.maxlines, this.suffixIcon,  this.readOnly = false});

  final String title;
  final String hintText;
  final TextEditingController? controller ;
  final int? maxlines;
  final Widget? suffixIcon;
  final bool readOnly ;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch ,
      children: [
        Text(
          title,
          style:  TextStyle(color: Colors.black),

        ),
        const SizedBox(height: 10),
        TextField(
          readOnly: readOnly,
          controller: controller,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          maxLines: maxlines,
          decoration:  InputDecoration(
            filled: true,
            hintText: hintText,
            suffixIcon: suffixIcon,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
          ),
          onChanged: (value){},
        ),
      ],
    );
  }
}