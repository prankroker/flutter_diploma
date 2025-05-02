import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/ChatController.dart';

class ChatScreen extends StatefulWidget {
  final ChatController controller;
  const ChatScreen({super.key, required this.controller});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Слухаємо зміни в моделі
    widget.controller.model.messagesStream.listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чат бот"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.controller.model.messages.length,
              itemBuilder: (context, index) {
                if (index == 0) return const SizedBox.shrink();
                final message = widget.controller.model.messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              onSubmitted: (text) => _handleSend(),
              decoration: InputDecoration(
                labelText: "Введіть запит",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message["role"] == 'assistant' ? Colors.blue[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message["content"] ?? ''),
    );
  }

  void _handleSend() {
    if (_textController.text.isNotEmpty) {
      widget.controller.handleUserInput(_textController.text);
      _textController.clear();
    }
  }
}
