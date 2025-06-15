import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.title, this.onTap, this.color, this.isLoading});

  final String title;
  final bool? isLoading;

  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 45),
          backgroundColor: color ?? GlobalVariables.secondaryColor,
          // Button color
          foregroundColor: Colors.white,
          // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ));
  }
}
