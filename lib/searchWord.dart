import 'package:flutter/material.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class searchWord extends StatefulWidget {
  const searchWord({super.key});

  @override
  State<searchWord> createState() => _SearchWordState();
}

class _SearchWordState extends State<searchWord> {
  final TextEditingController _controller = TextEditingController();
  String _wordMeaning = "тут буде виводитися значення слова";
  bool _isLoading = false;

  Future<void> _fetchWordDefinition(String word) async {
    setState(() {
      _isLoading = true;
      _wordMeaning = "";
    });

    final url = Uri.parse(
        'https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final definition = data[0]['meanings'][0]['definitions'][0]['definition'];
        setState(() {
          _wordMeaning = definition;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _wordMeaning = "Слово '$word' не знайдено.";
        });
      } else {
        setState(() {
          _wordMeaning = "Помилка сервера. Спробуйте пізніше.";
        });
      }
    } catch (e) {
      setState(() {
        _wordMeaning = "Сталася помилка: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchWord() {
    final term = _controller.text.trim();
    if (term.isNotEmpty) {
      _fetchWordDefinition(term);
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
          ],
        ),
      ),
    );
  }
}

