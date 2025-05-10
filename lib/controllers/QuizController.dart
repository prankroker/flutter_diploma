import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_diploma/models/QuizModel.dart';
import 'package:http/http.dart' as http;

class QuizController {
  final String topicId;
  final List<QuizQuestion> questions = [];
  final List<Mistake> mistakes = [];
  int currentIndex = 0;
  int score = 0;
  int elapsedTime = 0;
  Timer? _timer;
  final user = FirebaseAuth.instance.currentUser;
  int? _selectedAnswer;

  int? get selectedAnswer => _selectedAnswer;
  set selectedAnswer(int? value) => _selectedAnswer = value;
  Function()? onTimeTick;

  QuizController(this.topicId);

  Future<void> loadQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('topics')
        .doc(topicId)
        .collection('questions')
        .get();

    questions.addAll(snapshot.docs.map((e) => QuizQuestion.fromMap(e.data())));
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime++;
      onTimeTick?.call();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  bool answerQuestion(int selectedIndex) {
    if (currentIndex >= questions.length) return true; // запобігає виходу за межі масиву

    final question = questions[currentIndex];
    if (selectedIndex == question.correctIndex) {
      score++;
    } else {
      mistakes.add(Mistake(
        question: question.question,
        selectedAnswer: question.options[selectedIndex],
        correctAnswer: question.options[question.correctIndex],
      ));
    }
    currentIndex++;
    return currentIndex >= questions.length;
  }

  Future<void> saveResult() async {
    await FirebaseFirestore.instance.collection('results').add({
      'uid': user?.uid,
      'topic': topicId,
      'score': score,
      'totalQuestions': questions.length,
      'timeSpent': elapsedTime,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> analyzeMistakes() async {
    final List<Map<String, String>> messages = [
      {
        "role": "system",
        "content":
        "Explain and analyze strictly in English only, no matter what language is used in the questions or answers (e.g., German, Spanish, etc.). For each answer, explain why it is correct or incorrect, and provide the correct answer when necessary. Do not use any language other than English in your explanation."
      },
      {
        "role": "user",
        "content": _formatMistakes(),
      }
    ];

    final Map<String, Object> data = {
      "model": "llama3.2",
      "messages": messages,
      "stream": false,
      "max_tokens": 100,
    };

    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:11434/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        return decoded["message"]["content"] ?? "Помилка отримання відповіді.";
      } else {
        return "Не вдалося отримати пояснення від AI.";
      }
    } catch (e) {
      return "Сталася помилка: $e";
    }
  }

  String _formatMistakes() {
    return mistakes.map((m) {
      return "Question: ${m.question}\nYour answer: ${m.selectedAnswer}\nCorrect answer: ${m.correctAnswer}\n";
    }).join("\n");
  }
}