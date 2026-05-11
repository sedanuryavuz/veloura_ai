import 'package:flutter/material.dart';

import '../models/message_model.dart';
import '../services/gemini_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  final GeminiService _geminiService = GeminiService();

  final List<MessageModel> _messages = [];

  bool _isLoading = false;

  Future<void> sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;

    setState(() {
      _messages.add(
        MessageModel(
          text: userMessage,
          isUser: true,
        ),
      );

      _isLoading = true;
    });

    _controller.clear();

    try {
      final response = await _geminiService.sendMessage(
        '''
You are a fashion stylist AI.

Give short and aesthetic outfit suggestions.

User message:
$userMessage
''',
      );

      setState(() {
        _messages.add(
          MessageModel(
            text: response,
            isUser: false,
          ),
        );
      });
    } catch (e,stack) {
       print("HATA:");
  print(e);
  print(stack);
      setState(() {
        _messages.add(
          MessageModel(
            text: 'Bir hata oluştu 😭',
            isUser: false,
            
          ),
        );
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF6F6),

      appBar: AppBar(
        title: const Text("FitMuse"),
        centerTitle: true,
        backgroundColor: const Color(0xffFDF6F6),
      ),

      body: Column(
        children: [

          /// MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),

                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),

                    decoration: BoxDecoration(
                      color: message.isUser
                          ? const Color(0xffE8B4B8)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// LOADING
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: CircularProgressIndicator(),
            ),

          /// INPUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _controller,

                    decoration: InputDecoration(
                      hintText: "Ask for an outfit...",

                      filled: true,
                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                GestureDetector(
                  onTap: sendMessage,

                  child: Container(
                    padding: const EdgeInsets.all(16),

                    decoration: const BoxDecoration(
                      color: Color(0xffE8B4B8),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}