import 'package:flutter/material.dart';
import 'package:flutter_diploma/savedQuestions.dart';
import 'package:flutter_diploma/themeQuestion.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_diploma/profile.dart';
import 'package:flutter_diploma/searchWord.dart';
import 'package:flutter_diploma/settings.dart';


class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Вимкнення банера debug
      theme: buildAppTheme(), // Використання готової теми
      home: const MainPage(), // Запуск головної сторінки
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Тести';

    return Theme(
      data: buildAppTheme(), // Використання теми з файлу
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const themeQuestion()));
                  },
                  icon: const Icon(
                    FontAwesomeIcons.flagUsa,
                    color: Colors.blue,
                  ),
                  label: const Text('Англійська мова'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const savedQuestions()));
                  },
                  icon: const Icon(
                    FontAwesomeIcons.stamp,
                    color: Colors.purple,
                  ),
                  label: const Text('Німецька мова'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Налаштування'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Словник'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
          ],
          currentIndex: 0,
          onTap: (index) {
            // Обробка натискання на елементи навігації
            if(index == 0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const settings()));
            }
            if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const searchWord()));
            }
            if(index == 2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const profile()));
            }
          },
        ),
      ),
    );
  }
}