import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_diploma/global/common/toast.dart';

class FirebaseAuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {

    if(email.isEmpty || password.isEmpty){
      showToast(context: context, message: 'пошта або пароль не мають бути пусті');
      return null;
    }

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        showToast(context: context, message: 'дана пошта вже використовується');
      }else if(e.code == 'invalid-email'){
        showToast(context: context, message: 'пошта в неправильному форматі');
      }else if(e.code == 'weak-password'){
        showToast(context: context, message: 'слабкий пароль');
      }else{
        showToast(context: context, message: 'Error: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {

    if(email.isEmpty || password.isEmpty){
      showToast(context: context, message: 'пошта або пароль не мають бути пусті');
      return null;
    }

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential' || e.code == 'invalid-email'){
        showToast(context: context, message: 'Неправильний пароль або пошта');
      }else{
        showToast(context: context, message: 'Error: ${e.code}');
      }
    }
    return null;
  }
}