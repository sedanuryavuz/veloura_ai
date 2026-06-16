import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veloura_ai/features/auth/presentation/pages/splash_page.dart';
import 'package:veloura_ai/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:veloura_ai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:veloura_ai/features/auth/domain/usecases/login.dart';
import 'package:veloura_ai/features/auth/domain/usecases/register.dart';
import 'package:veloura_ai/features/auth/domain/usecases/logout.dart';
import 'package:veloura_ai/features/auth/domain/usecases/get_current_user.dart';
import 'package:veloura_ai/features/auth/presentation/provider/auth_provider.dart';
import 'theme/app_theme.dart';

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

import 'package:veloura_ai/features/calendar/presentation/provider/calendar_provider.dart';
import 'package:veloura_ai/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:veloura_ai/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/event_ai_data_source.dart';
import 'package:veloura_ai/features/calendar/data/datasources/notification_data_source.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/get_calendar_events.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/add_calendar_event.dart';
import 'package:veloura_ai/features/calendar/domain/usecases/delete_calendar_event.dart';
import 'package:veloura_ai/features/chat/presentation/providers/chat_provider.dart';
import 'package:veloura_ai/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:veloura_ai/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:veloura_ai/features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/wardrobe/presentation/provider/wardrobe_provider.dart';
import '../features/wardrobe/domain/usecases/get_wardrobe_items.dart';
import '../features/wardrobe/domain/usecases/add_clothing_item.dart';
import '../features/wardrobe/domain/usecases/update_clothing_item.dart';
import '../features/wardrobe/domain/usecases/analyze_clothing.dart';
import '../features/wardrobe/domain/usecases/remove_background.dart';
import '../features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import '../features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';

import 'package:veloura_ai/features/auth/presentation/pages/initialization_error_page.dart';

class MyApp extends StatelessWidget {
  final String? initError;
  const MyApp({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    if (initError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Veloura AI',
        theme: AppTheme.light,
        home: InitializationErrorPage(error: initError!),
      );
    }

    final wardrobeRepository = WardrobeRepositoryImpl(WardrobeRemoteDataSource());
    final supabaseClient = Supabase.instance.client;
    final authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(supabaseClient));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final chatRemoteDataSource = ChatRemoteDataSourceImpl();
          final chatRepository = ChatRepositoryImpl(
            chatRemoteDataSource: chatRemoteDataSource,
            locationDataSource: LocationDataSourceImpl(),
            weatherDataSource: WeatherDataSourceImpl(),
          );
          return ChatProvider(
            sendChatMessageUseCase: SendChatMessageUseCase(chatRepository: chatRepository),
          );
        }),
       //ChangeNotifierProvider(create: (_) => ClothingFormController()),
        ChangeNotifierProvider(create: (_) {
          final outfitRepository = OutfitRepositoryImpl(
            remoteDataSource: OutfitRemoteDataSourceImpl(supabaseClient),
            aiDataSource: OutfitAiDataSourceImpl(),
            backgroundRemovalDataSource: BackgroundRemovalDataSourceImpl(),
            storageDataSource: StorageDataSourceImpl(supabaseClient),
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
          );
        }),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUsecase: Login(authRepository),
            registerUsecase: Register(authRepository),
            logoutUsecase: Logout(authRepository),
            getCurrentUserUsecase: GetCurrentUser(authRepository),
          ),
        ),
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
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
