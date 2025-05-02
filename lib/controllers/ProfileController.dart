import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_diploma/models/UserModel.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProfileModel> loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Отримання даних користувача
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final resultsSnapshot = await _firestore.collection('results')
        .where('uid', isEqualTo: user.uid)
        .get();

    // Обчислення середнього балу
    double averageScore = 0.0;
    if (resultsSnapshot.docs.isNotEmpty) {
      final total = resultsSnapshot.docs.fold(0, (sum, doc) {
        return sum + (doc.data()['score'] as int? ?? 0);
      });
      averageScore = total / resultsSnapshot.docs.length;
    }

    return ProfileModel(
      uid: user.uid,
      email: user.email,
      username: userDoc.data()?['username'],
      registrationDate: user.metadata.creationTime,
      averageScore: averageScore,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}