import 'package:flutter/material.dart';

class AddEventButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AddEventButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
