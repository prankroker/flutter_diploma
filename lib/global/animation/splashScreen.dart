import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diploma/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Expanded(
              child: Center(
                child: LottieBuilder.asset("assets/Lottie/Animation - 1730745990910.json"),
              ),
            )
          ],
        ),

        nextScreen: const Login());
  }
}
