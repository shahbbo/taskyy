import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, required this.title, this.onPressed});

  final String title;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5F33E1),
        minimumSize: const Size(335, 51),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
    );
  }
}
