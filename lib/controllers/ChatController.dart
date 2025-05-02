import 'package:flutter_diploma/models/ChatModel.dart';

class ChatController {
  final ChatModel model;

  ChatController(this.model);

  void handleUserInput(String text) {
    if (text.isNotEmpty) {
      model.sendMessage(text);
    }
  }
}