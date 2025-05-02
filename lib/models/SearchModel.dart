import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart';

class SearchModel extends ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final List<Map<String, String>> _messages = [
    {
      "role": "system",
      "content": "You are a helpful assistant that will explain what word means its grammar and usage in real world situations",
    },
  ];

  String _wordMeaning = "тут буде виводитися значення слова";
  bool _isLoading = false;
  bool _speechEnabled = false;
  Map? _currentVoice;

  // Геттери для доступу ззовні
  bool get isListening => _speechToText.isListening;
  String get wordMeaning => _wordMeaning;
  bool get isLoading => _isLoading;
  bool get speechEnabled => _speechEnabled;

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  Future<void> initTTS() async {
    final voices = await _flutterTts.getVoices;
    if (voices != null) {
      final filteredVoices = voices.where((v) => v["name"].contains("en")).toList();
      if (filteredVoices.isNotEmpty) {
        _currentVoice = filteredVoices.first;
        await _flutterTts.setVoice({"name": _currentVoice!["name"], "locale": _currentVoice!["locale"]});
      }
    }
  }

  Future<void> startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(result) {
    _wordMeaning = result.recognizedWords;
    notifyListeners();
  }

  Future<void> searchWord(String term) async {
    if (term.isEmpty) {
      _wordMeaning = "Введіть термін для пошуку.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _wordMeaning = "";
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "model": "llama3.2",
          "messages": [..._messages, {"role": "user", "content": term}],
          "stream": false,
          "max_tokens": 30,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _wordMeaning = data["message"]["content"];
      } else {
        _wordMeaning = "Помилка: ${response.statusCode}";
      }
    } catch (e) {
      _wordMeaning = "Помилка сервера: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    } else {
      await _flutterTts.speak(text);
    }
    _isSpeaking = !_isSpeaking;
    notifyListeners();
  }

  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
      notifyListeners();
    }
  }
}