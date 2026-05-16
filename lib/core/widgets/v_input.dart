import 'package:flutter/material.dart';
import '../../app/theme/app_decorations.dart';

class VInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const VInput({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: AppDecorations.inputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
