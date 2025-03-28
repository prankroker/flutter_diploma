import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_diploma/mainPage.dart';

class QuizPage extends StatefulWidget {
  final String topicId;
  const QuizPage({super.key, required this.topicId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  List<Map<String, dynamic>> mistakes = []; // Для збереження помилкових відповідей

  final user = FirebaseAuth.instance.currentUser;

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('questions')
        .get();

    setState(() {
      questions = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void _answerQuestion(int selectedIndex) {
    if (questions.isEmpty) return;

    int correctIndex = questions[currentQuestionIndex]['correctIndex'];
    if (selectedIndex == correctIndex) {
      score++;
    } else {
      // Зберігаємо невірну відповідь
      mistakes.add({
        'question': questions[currentQuestionIndex]['question'],
        'selectedAnswer': questions[currentQuestionIndex]['options'][selectedIndex],
        'correctAnswer': questions[currentQuestionIndex]['options'][correctIndex],
      });
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _timer?.cancel();
      _saveResult();
      _showResultsDialog(context, score, questions.length);
    }
  }

  Future<void> _saveResult() async {
    await FirebaseFirestore.instance.collection('results').add({
      'uid': user?.uid,
      'topic': widget.topicId,
      'score': score,
      'totalQuestions': questions.length,
      'timeSpent': _elapsedTime,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _showResultsDialog(BuildContext context, int correctAnswers, int totalQuestions) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Результати"),
        content: Text("Ваш результат: $correctAnswers з $totalQuestions\nЧас: $_elapsedTime сек."),
        actions: [
          if (mistakes.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showMistakeAnalysis();
              },
              child: const Text("Розбір помилок"),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.microtask(() {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                }
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _showMistakeAnalysis() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Text("Аналіз помилок"),
        content: Center(child: CircularProgressIndicator()), // Покажемо індикатор завантаження
      ),
    );

    String aiResponse = await _analyzeMistakes(mistakes);

    if (mounted) {
      Navigator.of(context).pop(); // Закриваємо індикатор завантаження
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Розбір помилок"),
          content: SingleChildScrollView(
            child:
          Text(aiResponse),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<String> _analyzeMistakes(List<Map<String, dynamic>> mistakes) async {
    final List<Map<String, String>> messages = [
      {"role": "system", "content": "Explain why the given answers are correct or incorrect, and provide the correct answers if necessary, even if the questions are in another language."},
      {"role": "user", "content": _formatMistakes(mistakes)}
    ];

    final Map<String, Object> data = {
      "model": "llama3.2",
      "messages": messages,
      "stream": false,
      "max_tokens": 100, // Обмеження довжини відповіді
    };

    try {
      final http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData["message"]["content"] ?? "Помилка отримання відповіді.";
      } else {
        return "Не вдалося отримати пояснення від AI.";
      }
    } catch (e) {
      return "Сталася помилка: $e";
    }
  }

  String _formatMistakes(List<Map<String, dynamic>> mistakes) {
    return mistakes.map((mistake) {
      return "Question: ${mistake['question']}\n"
          "Your answer: ${mistake['selectedAnswer']}\n"
          "Correct answer: ${mistake['correctAnswer']}\n";
    }).join("\n");
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Питання ${currentQuestionIndex + 1}/${questions.length}  Час: $_elapsedTime сек."),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(question['options'].length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(index),
                    child: Text(question['options'][index]),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
