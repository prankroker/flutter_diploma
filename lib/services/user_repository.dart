import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  Future<void> saveUserToFirestore(User user) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection("users").doc(user.uid);

    DocumentSnapshot docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'username': user.displayName ?? "Google User",
        'email': user.email,
      });
    }
  }
}