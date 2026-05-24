import 'package:veloura_ai/features/wardrobe/domain/entities/clothing_item.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendChatMessage({
    required String message,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  });
}
