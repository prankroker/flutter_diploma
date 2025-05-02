import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/QuizController.dart';
import 'package:flutter_diploma/views/screens/mainPage.dart';

class QuizPage extends StatefulWidget {
  final String topicId;
  const QuizPage({super.key, required this.topicId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late final QuizController controller;

  @override
  void initState() {
    super.initState();
    controller = QuizController(widget.topicId);
    controller.onTimeTick = () => setState(() {});
    controller.loadQuestions().then((_) {
      setState(() {});
      controller.startTimer();
    });
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }

  void _handleAnswer(int selectedIndex) async {
    final isFinished = controller.answerQuestion(selectedIndex);
    setState(() {});
    if (isFinished) {
      controller.stopTimer();
      await controller.saveResult();
      _showResults();
    }
  }

  void _showResults() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Результати"),
        content: Text(
            "Ваш результат: ${controller.score} з ${controller.questions.length}\nЧас: ${controller.elapsedTime} сек."),
        actions: [
          if (controller.mistakes.isNotEmpty)
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showMistakeAnalysis() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Text("Аналіз помилок"),
        content: Center(child: CircularProgressIndicator()),
      ),
    );

    final result = await controller.analyzeMistakes();

    if (!mounted) return;
    Navigator.of(context).pop(); // close loading
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Розбір помилок"),
        content: SingleChildScrollView(child: Text(result)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.currentIndex >= controller.questions.length) {
      return const Scaffold(
        body: Center(child: Text("Тест завершено.")),
      );
    }

    final question = controller.questions[controller.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Питання ${controller.currentIndex + 1}/${controller.questions.length}  Час: ${controller.elapsedTime} сек.",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question.question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(question.options.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _handleAnswer(index),
                    child: Text(question.options[index]),
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