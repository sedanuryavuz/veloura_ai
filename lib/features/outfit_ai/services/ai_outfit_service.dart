import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:veloura_ai/features/outfit_ai/models/ai_outfit_result.dart';

class AiOutfitService {
  final model = GenerativeModel(
    model: 'gemini-2-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
  );

  // ---------------- PROMPT ----------------
  String buildPrompt(List items, Map weather) {
    final temp = weather['temperature'] ?? 0;
    final desc = weather['description'] ?? "unknown";

    final wardrobeJson = items.map((e) {
      return {
        "id": e.id,
        "name": e.name,
        "category": e.category.toString().split('.').last, // 🔥 enum FIX
        "color": e.color,
        "style": e.style,
      };
    }).toList();

    return '''
You are a fashion AI stylist.

Create ONE outfit using ONLY wardrobe items.

IMPORTANT:
Return ONLY valid JSON.
NO markdown.
NO ```json.

JSON FORMAT:
{
  "outfit_name": "",
  "style": "",
  "reason": "",
  "items": [
    {
      "id": "",
      "name": "",
      "category": ""
    }
  ]
}

Weather:
$temp°C - $desc

Wardrobe:
${jsonEncode(wardrobeJson)}
''';
  }

  // ---------------- CLEAN JSON ----------------
  String cleanJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');

    if (start == -1 || end == -1) {
      return text;
    }

    return text.substring(start, end + 1);
  }

  // ---------------- MAIN FUNCTION ----------------
Future<AiOutfitResult?> generateOutfit({
    required List items,
    required Map weather,
  }) async {
    try {
      final prompt = buildPrompt(items, weather);

      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text;
      if (text == null) return null;

      final cleaned = cleanJson(text);

      final json = jsonDecode(cleaned);

    return AiOutfitResult.fromJson(json);
    } catch (e) {
      print("AI ERROR: $e");
      return null;
    }
  }
}