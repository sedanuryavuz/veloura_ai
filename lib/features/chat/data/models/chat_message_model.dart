import '../../domain/entities/chat_message.dart';
import 'ai_outfit_response_model.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.text,
    required super.isUser,
    required super.createdAt,
    super.outfitResponse,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      outfitResponse: json['outfitResponse'] != null
          ? AiOutfitResponseModel.fromJson(json['outfitResponse'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'createdAt': createdAt.toIso8601String(),
      'outfitResponse': outfitResponse != null
          ? (outfitResponse as AiOutfitResponseModel).toJson()
          : null,
    };
  }
}
