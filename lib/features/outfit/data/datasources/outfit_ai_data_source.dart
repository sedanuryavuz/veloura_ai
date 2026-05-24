import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class OutfitAiDataSource {
  Future<Map<String, dynamic>?> generateOutfit({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> weather,
    List<String> previousOutfitIds = const [],
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
    List<String> previousOutfitIds = const [],
  }) async {
    try {
      final prompt = _buildPrompt(items, weather, previousOutfitIds);
      final response = await _model.generateContent([Content.text(prompt)]);
      
      final text = response.text;
      if (text == null) return null;

      final cleaned = _cleanJson(text);
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  String _buildPrompt(List<Map<String, dynamic>> items, Map<String, dynamic> weather, List<String> previousOutfitIds) {
    final temp = weather['temperature'] ?? 0;
    final desc = weather['description'] ?? "unknown";

    return '''
You are a high-end Fashion Stylist and AI Consultant.
Your goal is to create ONE visually balanced, modern, and aesthetically harmonious outfit using ONLY the items provided in the user's wardrobe.

STYLING RULES:
1. VISUAL HARMONY: Prioritize color compatibility and silhouette balance (e.g., if the top is oversized, the bottom should be more fitted, unless it's a specific streetwear look).
2. DRESS LOGIC: If you choose a "dress" (from top or specific category), the "bottom" category MUST be empty. Never suggest pants or jeans under a dress.
3. NO CLASHING: Avoid visually awkward combinations like dress + pants or duplicate layers that don't make sense (e.g., two heavy coats).
4. ACCESSORIES: Include accessories ONLY if they improve the outfit's aesthetic. They are optional.
5. SEASONAL APPROPRIATENESS: The outfit must suit the current weather ($temp°C - $desc).
6. FRESHNESS: Avoid these specific combinations (IDs): ${previousOutfitIds.join(', ')}. Try to be diverse and creative.

JSON OUTPUT FORMAT:
Return ONLY valid JSON. No markdown, no extra text.
{
  "outfit_name": "A creative, premium name for the look",
  "style": "The aesthetic style (e.g., Quiet Luxury, Streetwear, Minimalist)",
  "reason": "Brief professional fashion advice on why this works",
  "items": [
    {
      "id": "must match wardrobe id",
      "name": "item name",
      "category": "top | bottom | shoes | accessories"
    }
  ]
}

Current Weather: $temp°C - $desc
Wardrobe Items: ${jsonEncode(items)}
''';
  }

  String _cleanJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end == -1) return text;
    return text.substring(start, end + 1);
  }
}
