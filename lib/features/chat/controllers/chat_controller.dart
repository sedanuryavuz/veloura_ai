import 'package:flutter/material.dart';
import '../../../core/constants/prompts.dart';
import '../../outfit/data/datasources/outfit_ai_data_source.dart';
import '../models/message_model.dart';

class ChatController extends ChangeNotifier {
  final OutfitAiDataSource _aiDataSource = OutfitAiDataSourceImpl();

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
      final response = await sendWithRetry(
        Prompts.fashionStylist(text),
      );

      addAIMessage(response);
    } catch (e) {
      addAIMessage("Bir hata oluştu 😭");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String> sendWithRetry(String text) async {
    try {
      return await _aiDataSource.sendMessage(text);
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      return await _aiDataSource.sendMessage(text);
    }
  }
}