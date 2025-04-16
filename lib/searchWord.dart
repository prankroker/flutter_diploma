import 'package:flutter/material.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class searchWord extends StatefulWidget {
  const searchWord({super.key});

  @override
  State<searchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<searchWord> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;//it is optional
  final TextEditingController _controller = TextEditingController();
  String _wordMeaning = "тут буде виводитися значення слова";
  bool _isLoading = false;
  bool speechEnabled = false;

  @override
  void initState(){
    super.initState();
    initSpeech();
    initTTS();
  }
  //speech to text part
  void initSpeech() async{
    speechEnabled = await _speechToText.initialize();

  }

  void _startListening() async{
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {

    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {

    });
  }

  void _onSpeechResult(result){
    setState(() {
      _controller.text = result.recognizedWords;
    });
  }
  //text to speech part
  void initTTS(){
    _flutterTts.getVoices.then((data) {
      try{
        List<Map> _voices = List<Map>.from(data);
        _voices = _voices.where((_voice) => _voice["name"].contains("en")).toList();
        _currentVoice = _voices.first;
        setVoice(_currentVoice!);
      }catch(e){
        print(e);
      }
    });
  }

  void setVoice(Map voice){
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  Future<void> query(String prompt) async{
    setState(() {
      _isLoading = true;
      _wordMeaning = "";
    });

    final List<Map<String, String>> messages = [
      {"role": "system", "content": "You are helpful assistant in language learning process. Explain the meaning of entered word. If user enters word wrong, clarify it. Words may be in English or German. DO NOT ASK QUESTIONS, please"},
      {"role": "user", "content": prompt}
    ];

    final Map<String, Object> data = {
      "model": "llama3.2",
      "messages": messages, // Передаємо масив
      "stream": false,
      "max_tokens":50,// Обмеження на довжину відповіді
    };

    try{
      final http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type":"application/json"},
        body: json.encode(data)
      );

      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        final definition = responseData["message"]["content"];
        setState(() {
          _wordMeaning = definition;
        });
      }else if (response.statusCode == 404) {
        setState(() {
          _wordMeaning = "Слово '$prompt' не знайдено.";
        });
      }
    }catch(e){
      setState(() {
        _wordMeaning = "Помилка сервера. Спробуйте пізніше. $e";
      });
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchWord() {
    final term = _controller.text.trim();
    if (term.isNotEmpty) {
      query(term);
    } else {
      setState(() {
        _wordMeaning = "Введіть термін для пошуку.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Словник"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Введіть термін",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchWord,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Center(
              child: Text(
                _wordMeaning,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            FloatingActionButton(heroTag: "Mic" , backgroundColor: Colors.lightBlue[200],
              onPressed: _speechToText.isListening? _stopListening : _startListening, tooltip: "Listen", child: Icon(
              _speechToText.isNotListening? Icons.mic_off : Icons.mic,
              color:Colors.black
            ),),
            const SizedBox(width: 20),
            FloatingActionButton(heroTag: "Speak" ,backgroundColor: Colors.lightBlue[200],
              onPressed: () {
              _flutterTts.speak(_wordMeaning);
            }, child: const Icon(Icons.volume_up),)]),
          ],
        ),
      ),
    );
  }
}

