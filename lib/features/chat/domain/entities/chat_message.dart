import 'ai_outfit_response.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final AiOutfitResponse? outfitResponse;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
    this.outfitResponse,
  });
}
