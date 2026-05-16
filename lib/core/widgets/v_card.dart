import 'package:flutter/material.dart';
import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_colors.dart';

class VCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? radius;
  final Color? color;
  final List<BoxShadow>? shadow;

  const VCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius,
    this.color,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius ?? AppDecorations.cardRadius),
        boxShadow: shadow ?? AppDecorations.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? AppDecorations.cardRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
