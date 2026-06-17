import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:veloura_ai/core/l10n/app_localizations.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import 'package:veloura_ai/app/theme/app_text_styles.dart';
import 'package:veloura_ai/core/services/preferences_service.dart';
import 'package:veloura_ai/features/auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _completeOnboarding() async {
    await PreferencesService.instance.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    // Premium Fashion Marketing Copy (Localized)
    final List<OnboardingStep> steps = [
      OnboardingStep(
        title: isTr ? "Dijital Gardırop" : "Digital Wardrobe",
        description: isTr 
            ? "Kıyafetlerinizi tek bir şık görsel dolapta dijitalleştirin ve düzenleyin."
            : "Digitize and organize your clothes in one sleek visual closet.",
      ),
      OnboardingStep(
        title: isTr ? "Kombin Tasarlayıcı" : "Outfit Builder",
        description: isTr 
            ? "Etkileşimli görsel tuvalde kıyafetleri karıştırın, eşleştirin ve düzenleyin."
            : "Mix, match, and curate outfits on an interactive visual canvas.",
      ),
      OnboardingStep(
        title: isTr ? "Hava Durumuna Özel" : "Weather Smart",
        description: isTr 
            ? "Günlük hava durumuna göre uyarlanmış akıllı kombin önerileri alın."
            : "Receive smart outfit suggestions tailored to the daily weather.",
      ),
      OnboardingStep(
        title: isTr ? "Yapay Zeka Stilisti" : "AI Stylist",
        description: isTr 
            ? "Stil tavsiyeleri için kişisel sanal asistanınızla 7/24 sohbet edin."
            : "Chat 24/7 with a personal virtual assistant for style advice.",
      ),
    ];

    final isLastPage = _currentPage == steps.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xff0F0C0D), // Dark premium background
      body: Stack(
        children: [
          // Elegant Glowing Aura Top Right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.03),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Onboarding Page Contents
          SafeArea(
            child: Column(
              children: [
                // Top Action Bar
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: Text(
                        l10n.skip,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // PageView with Visual illustrations
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: steps.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Custom Vector Illustration (Non-Material icon only)
                                OnboardingVisual(index: index),
                                const SizedBox(height: 48),
                                
                                // Glassmorphic Content Card
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.03),
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            step.title.toUpperCase(),
                                            style: AppTextStyles.h2.copyWith(
                                              color: Colors.white,
                                              fontSize: 22,
                                              letterSpacing: 2.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            step.description,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: Colors.white60,
                                              fontSize: 14,
                                              height: 1.6,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Control Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Modern Pill Indicator
                      Row(
                        children: List.generate(
                          steps.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.only(right: 8),
                            height: 6,
                            width: _currentPage == index ? 24 : 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primary
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: _currentPage == index ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 8,
                                )
                              ] : null,
                            ),
                          ),
                        ),
                      ),
                      
                      // Custom Styled Next / Get Started Gradient Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLastPage) {
                              _completeOnboarding();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isLastPage ? l10n.getStarted.toUpperCase() : l10n.next.toUpperCase(),
                            style: AppTextStyles.button.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStep {
  final String title;
  final String description;

  const OnboardingStep({
    required this.title,
    required this.description,
  });
}

// Custom Visual Illustration Widget to avoid standard raw Material icons
class OnboardingVisual extends StatelessWidget {
  final int index;
  const OnboardingVisual({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return _buildDigitalWardrobe();
      case 1:
        return _buildOutfitCanvas();
      case 2:
        return _buildWeatherSmart();
      case 3:
        return _buildAiStylist();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDigitalWardrobe() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Aura
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.05),
            ),
          ),
          // Hanger glass card
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: const Icon(
              Icons.checkroom_rounded,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          // Floating item tag 1
          Positioned(
            top: 15,
            left: 5,
            child: _buildFloatingTag(Icons.style_rounded, "Top"),
          ),
          // Floating item tag 2
          Positioned(
            bottom: 20,
            right: 5,
            child: _buildFloatingTag(Icons.gesture_rounded, "Bottom"),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitCanvas() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Canvas Alignment Circle
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 1.5, style: BorderStyle.solid),
            ),
          ),
          // Mix/match stacked garments visual
          Positioned(
            top: 15,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.checkroom_rounded, color: AppColors.primaryLight, size: 24),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.straighten_rounded, color: AppColors.primaryLight, size: 24),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.roller_skating_rounded, color: AppColors.primaryLight, size: 24),
            ),
          ),
          // Central Canvas Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                const SizedBox(width: 6),
                const Text(
                  "Canvas",
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSmart() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.05),
            ),
          ),
          // Sun/Cloud weather icon
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(
              Icons.wb_cloudy_rounded,
              size: 48,
              color: AppColors.accent,
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: const Icon(
              Icons.wb_sunny_rounded,
              size: 28,
              color: Colors.amberAccent,
            ),
          ),
          // Temperature Chip
          Positioned(
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Text(
                "22°C / Sunny",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiStylist() {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Concentric glowing rings
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
            ),
          ),
          // Sparkle orb
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          // Chat bubble tags
          Positioned(
            top: 15,
            right: 0,
            child: _buildChatBubble("Style me! ✨"),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            child: _buildChatBubble("Date look? 🌹"),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryLight, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
