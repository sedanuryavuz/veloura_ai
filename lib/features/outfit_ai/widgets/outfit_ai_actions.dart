import 'package:flutter/material.dart';

import '../../outfit/utils/outfit_theme.dart';

class OutfitAiActions extends StatelessWidget {
  final bool isLoading;
  final bool hasSelection;

  final VoidCallback onGenerate;
  final VoidCallback onSave;

  const OutfitAiActions({
    super.key,
    required this.isLoading,
    required this.hasSelection,
    required this.onGenerate,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: "ai_generate_btn",
          onPressed: isLoading ? null : onGenerate,
          backgroundColor: OutfitTheme.accentColor,

          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.auto_awesome),

          label: Text(
            isLoading
                ? "Generating..."
                : "Generate AI",
          ),
        ),

        if (hasSelection) ...[
          const SizedBox(height: 10),

          FloatingActionButton.extended(
            heroTag: "ai_save_btn",
            onPressed: onSave,
            backgroundColor: Colors.green,

            icon: const Icon(Icons.check),

            label: const Text(
              "Save Outfit",
            ),
          ),
        ],
      ],
    );
  }
}