import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    await dotenv.load(fileName: ".env");
    await SupabaseService.initialize();
  } catch (e) {
    initError = e.toString();
  }
  
  runApp(MyApp(initError: initError));
}