import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CalendarHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
