import 'package:flutter/material.dart';
import 'package:flutter_diploma/chatBotPage.dart';
import 'package:flutter_diploma/germanyQuestionsPage.dart';
import 'package:flutter_diploma/englishQuestionPage.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_diploma/profilePage.dart';
import 'package:flutter_diploma/searchWord.dart';


class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainPage();
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EnglishQuestions()));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GermanQuestions()));
                  },
                  icon: const Icon(
                    Icons.abc,
                    color: Colors.purple,
                  ),
                  label: const Text('Німецька мова'),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                  },
                  icon: const Icon(
                      Icons.chat,
                      color: Colors.purple
                  ),
                  label:const Text('Чат бот'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Словник'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профіль'),
          ],
          onTap: (index) {
            // Обробка натискання на елементи навігації

            if(index == 0){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchWord()));
            }
            if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
            }
          },
        ),
      ),
    );
  }
}