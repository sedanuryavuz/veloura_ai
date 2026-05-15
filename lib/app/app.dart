import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/domain/usecases/generate_ai_outfit_usecase.dart';
import 'package:veloura_ai/features/auth/pages/login_page.dart';
import 'package:veloura_ai/features/outfit/providers/outfit_provider.dart';
import 'package:veloura_ai/features/outfit/repositories/outfit_repository.dart';
import 'package:veloura_ai/features/outfit_ai/controllers/outfit_ai_controller.dart';
import 'package:veloura_ai/features/outfit_ai/services/ai_outfit_service.dart';
import 'package:veloura_ai/features/outfit_ai/services/location_service.dart';
import 'package:veloura_ai/features/outfit_ai/services/weather_service.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/calendar/providers/calendar_provider.dart';
import '../features/calendar/repositories/calendar_repository.dart';
import '../features/chat/controllers/chat_controller.dart';
import '../domain/controllers/clothing_form_controller.dart';
import '../features/wardrobe/presentation/provider/wardrobe_provider.dart';
import '../features/wardrobe/domain/usecases/get_wardrobe_items.dart';
import '../features/wardrobe/domain/usecases/add_clothing_item.dart';
import '../features/wardrobe/domain/usecases/update_clothing_item.dart';
import '../features/wardrobe/domain/usecases/analyze_clothing.dart';
import '../features/wardrobe/domain/usecases/remove_background.dart';
import '../features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import '../features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wardrobeRepository = WardrobeRepositoryImpl(WardrobeRemoteDataSource());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => ClothingFormController()),
        ChangeNotifierProvider(create: (_) => OutfitProvider(OutfitRepository())),
        ChangeNotifierProvider(create: (_) => CalendarProvider(CalendarRepository())),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(
          create: (_) => WardrobeProvider(
            getWardrobeItems: GetWardrobeItems(wardrobeRepository),
            addClothingItem: AddClothingItem(wardrobeRepository),
            updateClothingItem: UpdateClothingItem(wardrobeRepository),
            deleteClothingItem: DeleteClothingItem(wardrobeRepository),
            analyzeClothing: AnalyzeClothing(wardrobeRepository),
            removeBackground: RemoveBackground(wardrobeRepository),
            repository: wardrobeRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => OutfitAiController(
            generateAiOutfitUseCase: GenerateAiOutfitUseCase(
              aiService: AiOutfitService(),
              locationService: LocationService(),
              weatherService: WeatherService(),
            ),
          ),
        )
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
