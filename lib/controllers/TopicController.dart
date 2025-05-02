import 'package:flutter/material.dart';
import 'package:flutter_diploma/models/TopicModel.dart';
import 'package:flutter_diploma/views/screens/quizPage.dart';

class TopicController {
  final String language;
  final List<Topic> topics;

  TopicController({required this.language}) : topics = _loadTopics(language);

  static List<Topic> _loadTopics(String language) {
    switch (language) {
      case 'Німецька мова':
        return [
          Topic(id: "GrammarGermany", title: "Граматика", questions: 10),
          Topic(id: "VocabularGermany", title: "Словниковий запас", questions: 10),
        ];
      case 'Англійська мова':
        return [
          Topic(id: "Grammar", title: "Граматика", questions: 10),
          Topic(id: "Vocabulary", title: "Словниковий запас", questions: 10),
        ];
      default:
        return [];
    }
  }

  void handleTopicTap(BuildContext context, String topicId) {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => QuizPage(topicId: topicId),
    ));
  }
}