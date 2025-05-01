import 'package:flutter/material.dart';
import 'package:flutter_diploma/quizPage.dart';
import 'package:flutter_diploma/themes/theme.dart';

class GermanQuestions extends StatelessWidget {
  const GermanQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Buttons();
  }
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final List<Map<String, dynamic>> topics = [
    {"id": "GrammarGermany", "title": "Граматика", "questions": 10},
    {"id": "VocabularGermany", "title": "Словниковий запас", "questions": 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Німецька мова"),
          centerTitle: true,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Перехід на сторінку з питаннями та передача topicId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPage(topicId: topic['id']),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${topic['questions']} питань",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}