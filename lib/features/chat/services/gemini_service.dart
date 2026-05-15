import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:veloura_ai/core/constants/prompts.dart';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-2.5-flash',

    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
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
  Future<Map<String, dynamic>?> analyzeClothing(
    File image,
  ) async {
    try {
      final bytes = await image.readAsBytes();

      final response = await model.generateContent([
        Content.multi([
          TextPart(Prompts.clothingAnalysis),

          DataPart(
            'image/jpeg',
            bytes,
          ),
        ]),
      ]);

      final text = response.text;

      if (text == null) return null;

      final cleaned = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return jsonDecode(cleaned);
    } catch (e) {
      print("CLOTHING ANALYSIS ERROR: $e");
      return null;
    }
  }
}