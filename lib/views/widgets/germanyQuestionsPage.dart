import 'package:flutter/material.dart';
import 'package:flutter_diploma/views/TopicListScreen.dart';

class GermanQuestions extends StatelessWidget {
  const GermanQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return TopicListScreen(language: "Німецька мова");
  }
}