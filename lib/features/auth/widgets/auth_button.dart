import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;

  const AuthButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      height: 56,

      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        child: Text(text),
      ),
    );
  }
}