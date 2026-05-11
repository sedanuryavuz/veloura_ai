import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:veloura_ai/app/theme/app_decorations.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: AppDecorations.glass,
          child: child,
        ),
      ),
    );
  }
}