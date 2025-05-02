import 'package:flutter/material.dart';
import 'package:flutter_diploma/views/TopicListScreen.dart';

class EnglishQuestions extends StatelessWidget {
  const EnglishQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return TopicListScreen(language: "Англійська мова");
  }
}