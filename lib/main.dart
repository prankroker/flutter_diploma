import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_diploma/global/animation/splashScreen.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {//підключення бази даних і запуск програми
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  if(kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(apiKey: dotenv.env["API_KEY"]??"",
            appId: dotenv.env["APP_ID"]??"",
            messagingSenderId: dotenv.env["MSG_ID"]??"",
            projectId: "mobilka-ai-feat")
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//відключення прапорця дебаг
      theme: buildAppTheme(),// застосуваня тем
      home: const SplashScreen(),// виклик класу та його запуск
    );
  }
}