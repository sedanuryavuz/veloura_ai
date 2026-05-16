import 'package:flutter/material.dart';
import '../../utils/outfit_theme.dart';

class OutfitLoading extends StatelessWidget {
  const OutfitLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: OutfitTheme.borderRadiusL,
        ),
        child: Row(
          children: List.generate(3, (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: OutfitTheme.borderRadiusM,
              ),
            ),
          )),
        ),
      ),
    );
  }
}
