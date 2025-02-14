import 'package:flutter/material.dart';
import 'package:flutter_diploma/themes/theme.dart';

class settings extends StatelessWidget {
  const settings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Вимкнення банера debug
      theme: buildAppTheme(), // Використання готової теми
      //home:  // Запуск головної сторінки
    );
  }
}