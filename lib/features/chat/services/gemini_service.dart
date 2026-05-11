import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  Future<String> sendMessage(String message) async {
    try {
      final response = await model.generateContent([
        Content.text(message),
      ]);

      return response.text ?? "No response";
    } catch (e) {
      print("AI ERROR: $e");
      return "AI error occurred";
    }
  }
}