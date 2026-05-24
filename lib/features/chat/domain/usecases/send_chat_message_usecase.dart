import 'package:veloura_ai/features/wardrobe/domain/entities/clothing_item.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository chatRepository;

  SendChatMessageUseCase({required this.chatRepository});

  Future<ChatMessage> execute({
    required String message,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) {
    return chatRepository.sendChatMessage(
      message: message,
      wardrobe: wardrobe,
      weather: weather,
    );
  }
}
