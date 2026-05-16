import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veloura_ai/features/auth/pages/login_page.dart';

import 'package:veloura_ai/features/outfit/presentation/provider/outfit_provider.dart';
import 'package:veloura_ai/features/outfit/data/repositories/outfit_repository_impl.dart';
import 'package:veloura_ai/features/outfit/data/datasources/outfit_remote_data_source.dart';
import 'package:veloura_ai/features/outfit/data/datasources/outfit_ai_data_source.dart';
import 'package:veloura_ai/features/outfit/data/datasources/background_removal_data_source.dart';
import 'package:veloura_ai/features/outfit/data/datasources/storage_data_source.dart';
import 'package:veloura_ai/features/outfit/data/datasources/location_data_source.dart';
import 'package:veloura_ai/features/outfit/data/datasources/weather_data_source.dart';
import 'package:veloura_ai/features/outfit/domain/usecases/get_outfits.dart';
import 'package:veloura_ai/features/outfit/domain/usecases/save_outfit.dart';
import 'package:veloura_ai/features/outfit/domain/usecases/delete_outfit.dart';
import 'package:veloura_ai/features/outfit/domain/usecases/generate_outfit.dart';

import '../features/auth/controllers/auth_controller.dart';
import 'package:veloura_ai/features/calendar/presentation/provider/calendar_provider.dart';
import 'package:veloura_ai/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:veloura_ai/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/event_ai_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/notification_data_source.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/get_calendar_events.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/add_calendar_event.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/delete_calendar_event.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/update_calendar_event.dart';
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
        ChangeNotifierProvider(create: (_) {
          final outfitRepository = OutfitRepositoryImpl(
            remoteDataSource: OutfitRemoteDataSourceImpl(Supabase.instance.client),
            aiDataSource: OutfitAiDataSourceImpl(),
            backgroundRemovalDataSource: BackgroundRemovalDataSourceImpl(),
            storageDataSource: StorageDataSourceImpl(Supabase.instance.client),
            locationDataSource: LocationDataSourceImpl(),
            weatherDataSource: WeatherDataSourceImpl(),
          );
          return OutfitProvider(
            getOutfitsUsecase: GetOutfits(outfitRepository),
            saveOutfitUsecase: SaveOutfit(outfitRepository),
            deleteOutfitUsecase: DeleteOutfit(outfitRepository),
            generateOutfitUsecase: GenerateOutfit(outfitRepository),
          );
        }),
        ChangeNotifierProvider(create: (_) {
          final calendarRepository = CalendarRepositoryImpl(
            remoteDataSource: CalendarRemoteDataSourceImpl(),
            localDataSource: CalendarLocalDataSourceImpl(),
            aiDataSource: EventAIDataSourceImpl(),
            notificationDataSource: NotificationDataSourceImpl(),
          );
          return CalendarProvider(
            getEvents: GetCalendarEvents(calendarRepository),
            addEvent: AddCalendarEvent(calendarRepository),
            deleteEvent: DeleteCalendarEvent(calendarRepository),
            //updateEvent: UpdateCalendarEvent(calendarRepository),
          );
        }),
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
