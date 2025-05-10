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
          Topic(id: "GrammarGermany", title: "Граматика A1", questions: 10),
          Topic(id: "GrammarGermanyA2", title: "Граматика А2", questions: 10),
          Topic(id: "VocabularGermany", title: "Словниковий запас A1", questions: 10),
          Topic(id: "VocabularGermanyA2", title: "Словниковий запас А2", questions: 10)
        ];
      case 'Англійська мова':
        return [
          Topic(id: "Grammar", title: "Граматика A1", questions: 10),
          Topic(id: "GrammarA2", title: "Граматика А2", questions: 10),
          Topic(id: "GrammarB1", title: "Граматика В1", questions: 10),
          Topic(id: "Vocabulary", title: "Словниковий запас A1", questions: 10),
          Topic(id: "VocabularyA2", title: "Словниковий запас А2", questions: 10),
          Topic(id: "VocabularyB1", title: "Словниковий запас В1", questions: 10)
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