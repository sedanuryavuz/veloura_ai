import 'package:flutter/material.dart';
import '../utils/outfit_theme.dart';

class EmptyStateView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(OutfitTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(OutfitTheme.spacingL),
              decoration: BoxDecoration(
                color: OutfitTheme.borderSubtle.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: OutfitTheme.textSecondary,
              ),
            ),
            const SizedBox(height: OutfitTheme.spacingL),
            Text(
              title,
              style: OutfitTheme.titleStyle.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: OutfitTheme.spacingS),
            Text(
              subtitle,
              style: OutfitTheme.subtitleStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
