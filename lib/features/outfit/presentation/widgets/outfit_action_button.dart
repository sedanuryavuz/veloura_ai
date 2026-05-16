import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_decorations.dart';

class OutfitActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool isLoading;
  final Color? color;

  const OutfitActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.isLoading = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDecorations.buttonRadius),
        ),
      ),
      icon: isLoading 
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Icon(icon, size: 20),
      label: Text(label),
    );
  }
}
