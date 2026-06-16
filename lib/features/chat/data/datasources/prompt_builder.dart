import 'package:veloura_ai/features/wardrobe/domain/entities/clothing_item.dart';

class PromptBuilder {
  static String buildSystemPrompt() {
    return """
You are a high-end personal AI Fashion Stylist and Outfit Consultant for Veloura AI.
Your task is to respond to the user's styling requests, questions, or conversation.

GUIDELINES:
1. Be short, aesthetic, conversational, and practical. Speak naturally.
2. If the user asks for outfit suggestions or recommendations, you MUST use ONLY the items provided in the user's wardrobe context. Do not hallucinate or suggest items they do not own.
3. If proposing an outfit, you must select items from their wardrobe that fit the user's description, the occasion, visual harmony, and the current weather.
4. If the user is just having a casual conversation (e.g. greeting you, asking a general question), respond conversationally. In this case, do NOT suggest wardrobe items unless it naturally fits their query.

STRICT JSON OUTPUT FORMAT:
You MUST return your response as a single, valid JSON object. Do NOT wrap the JSON in markdown code blocks (like ```json), do NOT add any text before or after the JSON.
Every response must follow this exact schema:
{
  "title": "Outfit title or 'Veloura Assistant' if not recommending a specific outfit",
  "outfit_items": [
    {
      "id": "item_id",
      "name": "Clothing item name",
      "category": "top | bottom | shoes"
    }
  ],
  "reason": "Your main conversational reply, including short styling explanation or general greeting/response",
  "style": "casual/minimal/streetwear/etc or 'conversational' if not recommending an outfit",
  "weather_note": "Optional weather suggestion or comment based on the weather context"
}
""";
  }

  static String buildUserPrompt({
    required String userRequest,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) {
    final temp = weather['temperature'];
    final condition = weather['condition'] ?? weather['description'] ?? 'Sunny';
    final category = weather['category'] ?? 'sunny';
    final weatherString = temp != null
        ? "Temperature: $temp°C\nCondition: $condition (Category: $category)"
        : "Unknown";

    final wardrobeItemsStr = wardrobe.isNotEmpty
        ? wardrobe.map((item) {
            return "- ID: ${item.id}, Name: ${item.name}, Category: ${item.category.name}, Color: ${item.color}, Style: ${item.style}, Description: ${item.description}";
          }).join("\n")
        : "None (Wardrobe is empty)";

    return """
Current Weather: $weatherString
User's Wardrobe Items:
$wardrobeItemsStr

User Request: "$userRequest"
""";
  }
}
