import 'package:flutter/material.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import 'package:veloura_ai/app/theme/app_decorations.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: List.generate(children.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Divider(
                  height: 1,
                  thickness: 0.5,
                  color: AppColors.textLight.withOpacity(0.2),
                  indent: 56,
                  endIndent: 16,
                );
              }
              return children[index ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}
