import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class EmptyEventState extends StatelessWidget {
  const EmptyEventState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60), // Fixed: Offsetting for bottom navigation bar
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_note_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.emptyDay,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.planOutfitForDay,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
