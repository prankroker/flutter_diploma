import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_diploma/themeQuestion.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  final String topicId; // Отримуємо ідентифікатор теми
  const QuizPage({super.key, required this.topicId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  Timer? _timer;
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _startTimer(); // Запускаємо таймер на початку тесту
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
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _timer?.cancel(); // Зупиняємо таймер при завершенні тесту
      _saveResult();
      _showResultsDialog(context, score, questions.length);
    }
  }

  Future<void> _saveResult() async {
    await FirebaseFirestore.instance.collection('results').add({
      'topic': widget.topicId,
      'score': score,
      'totalQuestions': questions.length,
      'timeSpent': _elapsedTime, // Зберігаємо витрачений час
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _showResultsDialog(BuildContext context, int correctAnswers, int totalQuestions) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Щоб користувач не закрив випадково
      builder: (context) => AlertDialog(
        title: const Text("Результати"),
        content: Text("Ваш результат: $correctAnswers з $totalQuestions\nЧас: $_elapsedTime сек."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Закриваємо діалог
              Future.microtask(() {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Buttons()),
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
        title: Text("Питання ${currentQuestionIndex + 1}/${questions.length}       Час: $_elapsedTime сек."),
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
