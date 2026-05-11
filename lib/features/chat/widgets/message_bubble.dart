import 'package:flutter/material.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),

        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [
                    Color(0xffE8B4B8),
                    Color(0xffF2C6C8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Colors.white,
                    Color(0xffF4F4F6),
                  ],
                ),

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 15,
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}