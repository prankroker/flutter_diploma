import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diploma/main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);

    final creationTime = user?.metadata.creationTime;
    final daysSinceRegistration = creationTime != null? DateTime.now().difference(creationTime).inDays:0;


      return Scaffold(
        appBar: AppBar(
          title: const Text('Профіль'),
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
              FutureBuilder<DocumentSnapshot>(
                future: docRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return const Text("Помилка при завантаженні даних");
                  }
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final username = data['username'] ?? "Без імені";

                  return Text(
                    username,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
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
            StreamBuilder(stream:
            FirebaseFirestore.instance.collection('results').where('uid', isEqualTo: user.uid).snapshots(),
                builder: (context,snapshot){
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text("Помилка при завантаженні даних");
                }

                int sumScore = 0;
                int countDocs = snapshot.data!.docs.length;

                for (DocumentSnapshot document in snapshot.data!.docs) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  int score = data['score'] ?? 0;
                  sumScore += score;
                }
                double avgScore = sumScore/countDocs;
                return Center(child: Text(
    "Середній бал по темах: ${avgScore.toStringAsFixed(2)}/10"
    ),);
            }
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
      );
  }
}