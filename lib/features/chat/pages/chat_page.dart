import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/typing_indicator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, controller, _) {
        scrollDown();

        return Scaffold(
          backgroundColor: const Color(0xffFDF6F6),
          appBar: AppBar(
            title: const Text("Veloura AI"),
            centerTitle: true,
            backgroundColor: const Color(0xffFDF6F6),
          ),
          body: Container(
            decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xffFDF6F6), 
        Color(0xffF7F7FB), 
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: controller.messages[index],
                      );
                    },
                  ),
                ),
            
                if (controller.isLoading)
                  const TypingIndicator(),
            
                ChatInput(
                  controller: _controller,
                  onSend: () {
                    controller.sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}