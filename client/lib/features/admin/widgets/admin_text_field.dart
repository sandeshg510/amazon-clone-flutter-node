import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  const AdminTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.isRequired = true,
    required this.title, // <-- default is true
  });

  final String title;
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '  $title',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
          ),
          validator: (value) {
            if (!isRequired) return null; // skip validation
            if (value == null || value.isEmpty) {
              return 'Enter your $hintText';
            }
            return null;
          },
        ),
      ],
    );
  }
}
