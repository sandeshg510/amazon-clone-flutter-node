import 'package:flutter/material.dart';

class NewCustomButton extends StatelessWidget {
  Color color;
  final String title;
  void Function()? onTap;
  NewCustomButton(
      {super.key, this.color = Colors.yellow, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          )),
    );
  }
}
