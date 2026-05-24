import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'prompt_builder.dart';
import 'ai_response_parser.dart';
import '../models/ai_outfit_response_model.dart';
import '../../../wardrobe/domain/entities/clothing_item.dart';

abstract class ChatRemoteDataSource {
  Future<AiOutfitResponseModel> getAIResponse({
    required String message,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final GenerativeModel _model;

  ChatRemoteDataSourceImpl()
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
          systemInstruction: Content.system(PromptBuilder.buildSystemPrompt()),
        );

  @override
  Future<AiOutfitResponseModel> getAIResponse({
    required String message,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) async {
    final userPrompt = PromptBuilder.buildUserPrompt(
      userRequest: message,
      wardrobe: wardrobe,
      weather: weather,
    );

    final response = await _model.generateContent([
      Content.text(userPrompt),
    ]);

    final rawText = response.text ?? '';
    return AiResponseParser.parse(rawText);
  }
}
