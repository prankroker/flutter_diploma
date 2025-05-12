import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_diploma/services/firebase_auth_services.dart';
import 'package:flutter_diploma/services/user_repository.dart';
import 'package:flutter_diploma/global/common/toast.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_diploma/views/screens/mainPage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {

  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  void signIn(BuildContext context, String email, String password) async{

    User? user = await _auth.signInWithEmailAndPassword(context, email, password);

    if(user != null){
      showToast(context: context,message: "User is succesfully signIn");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
    }
  }

  Future<String> _loadClientId() async {
    return await rootBundle.loadString('assets/WebClientID.txt');
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        final String clientId = await _loadClientId();
        userCredential = await _firebaseAuth.signInWithPopup(GoogleProvider(clientId: clientId) as AuthProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      User? user = userCredential.user;
      if (user != null) {
        await _userRepository.saveUserToFirestore(user);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
      }
    } catch (e) {
      showToast(context: context, message: "Помилка входу через Google: $e");
    }
  }
}