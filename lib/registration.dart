import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diploma/global/common/toast.dart';
import 'package:flutter_diploma/main.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:flutter_diploma/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget{
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Реєстрація';
    return Theme(
      data: buildAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
          centerTitle: true,
        ),
        body: const InputForms(),
      ),
    );
  }
}

class InputForms extends StatefulWidget {
  const InputForms({super.key});

  @override
  State<InputForms> createState() => _InputForms();
}

class _InputForms extends State<InputForms> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Введіть юзернейм',
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Введіть пошту',
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Введіть пароль'
                ),
              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed:(){
                  _signUp();
                },
                child: const Text("Далі"),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Вже маєте аккаунт?"),
                  const SizedBox(height: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: const Text(" Ввійдіть в нього",style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.bold),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async{
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if(user != null){
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        'username':username,
        'email':email
      });

      showToast(message: "User is succesfully created");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}