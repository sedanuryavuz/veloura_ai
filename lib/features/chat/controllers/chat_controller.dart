import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/gemini_service.dart';

class ChatController extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  final List<MessageModel> messages = [];

  bool isLoading = false;

  void addUserMessage(String text) {
    messages.add(MessageModel(text: text, isUser: true));
    notifyListeners();
  }

  void addAIMessage(String text) {
    messages.add(MessageModel(text: text, isUser: false));
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    addUserMessage(text);
    isLoading = true;
    notifyListeners();

    try {
final response = await sendWithRetry("""
You are a professional fashion stylist.

Top:
Bottom:
Shoes:
Accessories:
Style vibe:

User: $text
""");

      addAIMessage(response);
    } catch (e) {
      addAIMessage("Bir hata oluştu 😭");
    }

    isLoading = false;
    notifyListeners();
  }
  Future<String> sendWithRetry(String text) async {
  try {
    return await _geminiService.sendMessage(text);
  } catch (e) {
    await Future.delayed(const Duration(seconds: 2));
    return await _geminiService.sendMessage(text);
  }
}
}