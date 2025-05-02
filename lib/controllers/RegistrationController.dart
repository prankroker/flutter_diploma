import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diploma/global/common/toast.dart';
import 'package:flutter_diploma/services/firebase_auth_services.dart';
import 'package:flutter_diploma/views/screens/auth/loginPage.dart';

class RegistrationController {

  final FirebaseAuthService _auth = FirebaseAuthService();

  void signUp(BuildContext context,String username,String email,String password) async{

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if(user != null){
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        'username':username,
        'email':email
      });

      showToast(message: "User is succesfully created");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}