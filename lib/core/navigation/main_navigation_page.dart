import 'package:flutter/material.dart';
import 'package:veloura_ai/core/l10n/app_localizations.dart';
import 'package:veloura_ai/features/profile/presentation/pages/profile_page.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/outfit/presentation/pages/outfit_page.dart';
import '../../features/wardrobe/presentation/pages/wardrobe_page.dart';
import '../widgets/lazy_indexed_stack.dart';
import 'widgets/v_bottom_navigation_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    WardrobePage(),
    OutfitPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: LazyIndexedStack(
        index: currentIndex,
        children: pages,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 84.0), // Floating cleanly above the custom bottom nav bar
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ChatPage(),
              ),
            );
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: VBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          VBottomNavItem(icon: Icons.checkroom_rounded, label: l10n.wardrobe),
          VBottomNavItem(icon: Icons.auto_awesome, label: l10n.outfits),
          VBottomNavItem(icon: Icons.calendar_month_rounded, label: l10n.calendar),
          VBottomNavItem(icon: Icons.person_rounded, label: l10n.profile),
        ],
      ),
    );
  }
}
