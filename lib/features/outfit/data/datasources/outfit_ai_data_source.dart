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
- category must be one of: top, bottom, shoes, dress, outerwear, bag, hat, socks, jewelry, watch, glasses, belt, accessory
- color must be one of: black, white, blue, red, green, beige

Schema:
{
  "name": "string",
  "category": "top | bottom | shoes | dress | outerwear | bag | hat | socks | jewelry | watch | glasses | belt | accessory",
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
    final condition = weather['condition'] ?? weather['description'] ?? 'Sunny';
    final category = weather['category'] ?? 'sunny';

    return '''
You are a high-end Fashion Stylist and AI Consultant.
Your goal is to create ONE visually balanced, modern, and aesthetically harmonious outfit using ONLY the items provided in the user's wardrobe.

STYLING RULES:
1. VISUAL HARMONY: Prioritize color compatibility and silhouette balance (e.g., if the top/outerwear is oversized, the bottom should be more fitted, unless it's a specific streetwear look).
2. DRESS LOGIC: A dress can be a complete outfit on its own. If you choose a "dress", the outfit MUST NOT contain a "top" or "bottom". A dress outfit consists of: Dress + Shoes + optional Accessories and Outerwear.
3. OUTFIT STRUCTURE: An outfit should consist of:
   - Option A: One "top", one "bottom", one pair of "shoes", optional "outerwear", and optionally multiple accessories.
   - Option B: One "dress", one pair of "shoes", optional "outerwear", and optionally multiple accessories.
4. NO CLASHING: Avoid visually awkward combinations like dress + pants or duplicate layers that don't make sense (e.g., two heavy coats).
5. MULTIPLE ACCESSORIES: You can include multiple accessories (watch, glasses, bag, hat, jewelry, socks, belt, accessory) in the outfit if they improve the overall look. Do not restrict yourself to a single accessory.
6. SEASONAL APPROPRIATENESS: The outfit must suit the current weather (Temperature: $temp°C, Condition: $condition, Category: $category).
7. FRESHNESS: Avoid these specific combinations (IDs): ${previousOutfitIds.join(', ')}. Try to be diverse and creative.

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
      "category": "top | bottom | shoes | dress | outerwear | bag | hat | socks | jewelry | watch | glasses | belt | accessory"
    }
  ]
}

Current Weather: Temperature: $temp°C, Condition: $condition, Category: $category
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
