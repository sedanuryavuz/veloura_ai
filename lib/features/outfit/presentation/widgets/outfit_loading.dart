import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class OutfitLoading extends StatefulWidget {
  const OutfitLoading({super.key});

  @override
  State<OutfitLoading> createState() => _OutfitLoadingState();
}

class _OutfitLoadingState extends State<OutfitLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _messageIndex = 0;
  final List<String> _messages = [
    "Analyzing your style...",
    "Scanning wardrobe items...",
    "Considering color harmony...",
    "Balancing silhouettes...",
    "Checking seasonal trends...",
    "Finalizing your look...",
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              RotationTransition(
                turns: _controller,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _messages[_messageIndex],
              key: ValueKey(_messageIndex),
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.black.withOpacity(0.9),
                letterSpacing: 1.2,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "AI STYLIST",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary.withOpacity(0.7),
              letterSpacing: 4,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
