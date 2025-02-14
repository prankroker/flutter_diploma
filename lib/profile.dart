import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diploma/main.dart';
import 'package:flutter_diploma/themes/theme.dart';

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final creationTime = user?.metadata.creationTime;
    final daysSinceRegistration = creationTime != null? DateTime.now().difference(creationTime).inDays:0;

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Вимкнення банера debug
      theme: buildAppTheme(), // Використання готової теми
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Профіль'),
          backgroundColor: Colors.pink[50],
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                user!.email!.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.email!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Дата вашої реєстрації: ${creationTime != null ? "${creationTime.year}-${creationTime.month}-${creationTime.day}"  : 'Невідомо'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Днів з моменту реєстрації: $daysSinceRegistration',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text('Вийти з аккаунта'),
            ),
          ],
        ),
        ),
      ),
    );
  }
}