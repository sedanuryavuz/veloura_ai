import 'package:flutter/material.dart';

import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/outfit/presentation/pages/outfit_page.dart';
import '../../features/wardrobe/presentation/pages/wardrobe_page.dart';

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
    ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: VBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          VBottomNavItem(icon: Icons.checkroom_rounded, label: 'Wardrobe'),
          VBottomNavItem(icon: Icons.auto_awesome, label: 'Outfits'),
          VBottomNavItem(icon: Icons.calendar_month_rounded, label: 'Calendar'),
          VBottomNavItem(icon: Icons.psychology_rounded, label: 'AI Chat'),
        ],
      ),
    );
  }
}
