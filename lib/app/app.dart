import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/features/auth/pages/login_page.dart';
import 'package:veloura_ai/features/auth/pages/register_page.dart';
import 'package:veloura_ai/features/calendar/pages/outfit_calendar_page.dart';
import 'package:veloura_ai/features/outfit/controllers/outfit_controller.dart';
import 'package:veloura_ai/features/outfit/pages/outfit_builder_page.dart';
import 'package:veloura_ai/features/outfit/pages/outfit_list_page.dart';
import 'package:veloura_ai/features/wardrobe/pages/add_clothing_page.dart';
import 'package:veloura_ai/features/wardrobe/pages/wardrobe_page.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/calendar/controllers/calendar_controller.dart';
import '../features/chat/controllers/chat_controller.dart';
import '../features/chat/pages/chat_page.dart';
import '../features/wardrobe/controllers/clothing_form_controller.dart';
import '../features/wardrobe/providers/wardrobe_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => ClothingFormController(),),
        ChangeNotifierProvider(create: (_) => OutfitController()),
        ChangeNotifierProvider(create: (_) => CalendarController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
            ChangeNotifierProvider(create: (_) => WardrobeProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Veloura AI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE8B4B8)),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
