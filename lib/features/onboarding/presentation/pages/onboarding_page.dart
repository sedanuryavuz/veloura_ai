import 'package:flutter/material.dart';
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

  final List<OnboardingStep> _steps = [
    const OnboardingStep(
      title: "Curate Your Style",
      description: "AI-powered wardrobe organization and style suggestions tailored just for you.",
      icon: Icons.auto_awesome_rounded,
    ),
    const OnboardingStep(
      title: "Virtual Canvas",
      description: "Mix and match tops, bottoms, shoes, and accessories on our interactive canvas to create the perfect look.",
      icon: Icons.palette_outlined,
    ),
    const OnboardingStep(
      title: "Weather Smart",
      description: "Get real-time outfit suggestions matched specifically to the temperature and weather in your location.",
      icon: Icons.wb_sunny_outlined,
    ),
    const OnboardingStep(
      title: "AI Stylist Chat",
      description: "Ask your virtual stylist anything! Get immediate styling advice, tips, and custom outfit combinations.",
      icon: Icons.chat_bubble_outline_rounded,
    ),
  ];

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
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _steps.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        "Skip",
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _steps.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon Container
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                step.icon,
                                size: 100,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 60),
                            
                            // Title
                            Text(
                              step.title,
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            
                            // Description
                            Text(
                              step.description,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Control Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dots Indicator
                      Row(
                        children: List.generate(
                          _steps.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.primaryDark
                                  : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      
                      // Next/Get Started Button
                      ElevatedButton(
                        onPressed: () {
                          if (isLastPage) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          isLastPage ? "Get Started" : "Next",
                          style: AppTextStyles.button,
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
  final IconData icon;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
