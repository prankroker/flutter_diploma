import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatModel {
  final List<Map<String, String>> messages = [
    {"role": "system", "content": "You are a helpful assistant for user to improve skills in language. You need to point out all their mistakes and explain how to get better, while handling conversation"},
  ];

  // Стрім для сповіщень про зміни
  final StreamController<List<Map<String, String>>> _messagesController =
  StreamController.broadcast();

  Stream<List<Map<String, String>>> get messagesStream => _messagesController.stream;

  Future<void> sendMessage(String prompt) async {
    final userMessage = {"role": "user", "content": prompt};
    messages.add(userMessage);
    _messagesController.add([...messages]); // Сповістити про зміни

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "model": "llama3.2",
          "messages": messages,
          "stream": false,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        messages.add({"role": "assistant", "content": data["message"]["content"]});
        _messagesController.add([...messages]); // Сповістити про оновлення
      } else {
        messages.removeLast();
        _messagesController.add([...messages]);
      }
    } catch (e) {
      messages.removeLast();
      _messagesController.add([...messages]);
    }
  }

  void dispose() {
    _messagesController.close();
  }
}