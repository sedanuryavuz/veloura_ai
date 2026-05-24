import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../../../wardrobe/domain/entities/clothing_item.dart';

class ChatProvider extends ChangeNotifier {
  final SendChatMessageUseCase sendChatMessageUseCase;

  ChatProvider({required this.sendChatMessageUseCase});

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void clearChat() {
    _messages.clear();
    _error = null;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String text,
    required List<ClothingItem> wardrobe,
    required Map<String, dynamic> weather,
  }) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      createdAt: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final aiMessage = await sendChatMessageUseCase.execute(
        message: text,
        wardrobe: wardrobe,
        weather: weather,
      );
      _messages.add(aiMessage);
    } catch (e) {
      _error = e.toString();
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Sorry, I encountered an error. Please try again. 😭",
        isUser: false,
        createdAt: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
