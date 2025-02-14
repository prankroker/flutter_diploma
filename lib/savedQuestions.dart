import 'package:flutter/material.dart';
import 'package:flutter_diploma/themes/theme.dart';

class savedQuestions extends StatelessWidget {
  const savedQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Вимкнення банера debug
      theme: buildAppTheme(), // Використання готової теми
      //home:  // Запуск головної сторінки
    );
  }
}