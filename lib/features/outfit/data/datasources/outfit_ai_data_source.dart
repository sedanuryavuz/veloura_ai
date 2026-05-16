import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class OutfitAiDataSource {
  Future<Map<String, dynamic>?> generateOutfit({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> weather,
  });
  Future<Map<String, dynamic>?> analyzeClothing(File image);
  Future<String> sendMessage(String message);
}

class OutfitAiDataSourceImpl implements OutfitAiDataSource {
  final GenerativeModel _model;

  OutfitAiDataSourceImpl()
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
        );

  @override
  Future<String> sendMessage(String message) async {
    try {
      final response = await _model.generateContent([
        Content.text(message),
      ]);
      return response.text ?? "No response";
    } catch (e) {
      return "AI error occurred";
    }
  }

  @override
  Future<Map<String, dynamic>?> analyzeClothing(File image) async {
    try {
      final bytes = await image.readAsBytes();
      
      const prompt = """
You are a strict JSON generator. Return ONLY valid JSON.
No markdown, no explanations, no backticks, no extra text.
IMPORTANT RULES:
- category must be one of: top, bottom, shoes, accessories
- color must be one of: black, white, blue, red, green, beige

Schema:
{
  "name": "string",
  "category": "top | bottom | shoes | accessories",
  "color": "string",
  "style": "string",
  "description": "string"
}

Analyze this clothing item and return the result in this exact JSON format.
""";

      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ]),
      ]);

      final text = response.text;
      print("RAW GEMINI RESPONSE: $text");
      
      if (text == null) return null;
      
      final cleaned = _cleanJson(text);
      print("CLEANED JSON: $cleaned");
      
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      print("GEMINI ANALYSIS ERROR: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> generateOutfit({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> weather,
  }) async {
    try {
      final prompt = _buildPrompt(items, weather);
      final response = await _model.generateContent([Content.text(prompt)]);
      
      final text = response.text;
      if (text == null) return null;

      final cleaned = _cleanJson(text);
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  String _buildPrompt(List<Map<String, dynamic>> items, Map<String, dynamic> weather) {
    final temp = weather['temperature'] ?? 0;
    final desc = weather['description'] ?? "unknown";

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

Weather: $temp°C - $desc
Wardrobe: ${jsonEncode(items)}
''';
  }

  String _cleanJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1) return text;
    return text.substring(start, end + 1);
  }
}
