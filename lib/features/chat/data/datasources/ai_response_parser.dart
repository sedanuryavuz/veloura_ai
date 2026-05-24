import 'dart:convert';
import '../models/ai_outfit_response_model.dart';

class AiResponseParser {
  static AiOutfitResponseModel parse(String rawResponse) {
    try {
      final cleaned = _cleanJson(rawResponse);
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return AiOutfitResponseModel.fromJson(json);
    } catch (e) {
      // Fallback model if JSON parsing fails completely
      return AiOutfitResponseModel(
        title: "Veloura Assistant",
        outfitItems: const [],
        reason: rawResponse.trim().replaceAll("```json", "").replaceAll("```", ""),
        style: "conversational",
        weatherNote: null,
      );
    }
  }

  static String _cleanJson(String text) {
    String cleaned = text.trim();
    
    // Check if the response contains markdown code block wrappers
    if (cleaned.contains("```json")) {
      final startIdx = cleaned.indexOf("```json") + 7;
      final endIdx = cleaned.lastIndexOf("```");
      if (endIdx > startIdx) {
        cleaned = cleaned.substring(startIdx, endIdx).trim();
      }
    } else if (cleaned.contains("```")) {
      final startIdx = cleaned.indexOf("```") + 3;
      final endIdx = cleaned.lastIndexOf("```");
      if (endIdx > startIdx) {
        cleaned = cleaned.substring(startIdx, endIdx).trim();
      }
    }

    // Double check: extract everything between first '{' and last '}'
    final startBracket = cleaned.indexOf('{');
    final endBracket = cleaned.lastIndexOf('}');
    if (startBracket != -1 && endBracket != -1 && endBracket > startBracket) {
      return cleaned.substring(startBracket, endBracket + 1);
    }

    return cleaned;
  }
}
