import 'package:flutter/material.dart';

import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/outfit/presentation/pages/outfit_page.dart';
import '../../features/wardrobe/presentation/pages/wardrobe_page.dart';

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
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),



      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xffE8B4B8),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.checkroom_rounded),
                label: 'Wardrobe',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_awesome),
                label: 'Outfits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.psychology_rounded),
                label: 'AI Chat',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
