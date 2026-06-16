import 'package:flutter/material.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import 'package:veloura_ai/core/widgets/v_tutorial_page.dart';

class ClothingPhotoTutorialPage extends StatelessWidget {
  final VoidCallback onCompleted;

  const ClothingPhotoTutorialPage({
    super.key,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      VTutorialStep(
        title: "Get Better AI Results",
        description: "For the most accurate clothing analysis, place your item on a clean, light-colored background.",
        visual: _buildStepOneVisual(),
      ),
      VTutorialStep(
        title: "Good Lighting Matters",
        description: "Use natural light and avoid heavy shadows or dark environments.",
        visual: _buildStepTwoVisual(),
      ),
      VTutorialStep(
        title: "Let AI Do The Work",
        description: "Veloura AI will automatically analyze colors, category, style, and details from your photo.",
        visual: _buildStepThreeVisual(),
      ),
    ];

    return VTutorialPage(
      steps: steps,
      finishButtonText: "Got It, Open Camera",
      onCompleted: onCompleted,
    );
  }

  Widget _buildStepOneVisual() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: GridPainter(),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.checkroom_rounded,
                      size: 45,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwoVisual() {
    return SizedBox(
      width: 280,
      height: 240,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 16),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      color: const Color(0xff2D3436).withValues(alpha: 0.1),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xffDFE6E9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.checkroom_rounded, size: 32, color: Color(0xffB2BEC3)),
                          ),
                          const SizedBox(height: 12),
                          const Text("Poor Light", style: TextStyle(color: Color(0xff636E72), fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 90,
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                    ),
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.error,
                        child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 16),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffFFF9E6), Color(0xffFFF2CC)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Color(0x1AD19095), blurRadius: 8)],
                            ),
                            child: const Icon(Icons.checkroom_rounded, size: 32, color: AppColors.primary),
                          ),
                          const SizedBox(height: 12),
                          const Text("Bright Light", style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: -10,
                      left: -10,
                      child: Icon(Icons.wb_sunny_rounded, size: 40, color: Color(0xffFDCB6E)),
                    ),
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.success,
                        child: Icon(Icons.check_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepThreeVisual() {
    return Container(
      width: 270,
      height: 270,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          const Positioned(
            top: 10,
            left: 20,
            child: Icon(Icons.auto_awesome, color: Color(0xffFFEAA7), size: 32),
          ),
          const Positioned(
            bottom: 80,
            right: 15,
            child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 28),
          ),
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1AD19095),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAnalysisRow("Category", "Top", Icons.check_circle_rounded),
                      _buildAnalysisRow("Color", "Pink", Icons.check_circle_rounded),
                      _buildAnalysisRow("Style", "Minimalist", Icons.check_circle_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xff636E72),
                fontSize: 12,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff2D3436),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    final vStep = size.width / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(vStep * i, 0), Offset(vStep * i, size.height), paint);
    }

    final hStep = size.height / 4;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(0, hStep * i), Offset(size.width, hStep * i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
