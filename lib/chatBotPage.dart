import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class chatBotPage extends StatelessWidget {
  const chatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Чат бот',

      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatMessages = [
    {"role": "system", "content": "You are a helpful assistant. Your purpose is to make dialog with user in the language he uses. If user makes mistake point it out and explain."},
  ];

  Future<void> query(String prompt) async {
    final message = {
      "role": "user",
      "content": prompt,
    };

    chatMessages.add(message);

    final data = {
      "model": "llama3.2",
      "messages": chatMessages,
      "stream": false,
    };

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        chatMessages.add(
          {
            "role": "assistant",
            "content": responseData["message"]["content"],
          },
        );

        _controller.clear();
        setState(() {});
      } else {
        chatMessages.remove(message);
        setState(() {});
      }
    } catch (e) {
      chatMessages.remove(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чат бот"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    if (index == 0) return const SizedBox.shrink();
                    final message = chatMessages[index];
                    return Align(
                      alignment: message["role"] == 'assistant'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: message["role"] == 'assistant'
                              ? Colors.lightBlue[300]
                              : Colors.purple[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message["content"] ?? ''),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Введіть ваш запит",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        query(_controller.text);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}