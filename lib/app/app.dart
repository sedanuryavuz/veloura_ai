import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/chat/controllers/chat_controller.dart';
import '../features/chat/pages/chat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Veloura AI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xffE8B4B8),
          ),
        ),
        home: const ChatPage(),
      ),
    );
  }
}