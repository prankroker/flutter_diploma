import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/RegistrationController.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:flutter_diploma/views/screens/auth/loginPage.dart';

class Registration extends StatefulWidget{
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final RegistrationController registrationController = RegistrationController();
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
    const String appTitle = 'Реєстрація';
    return Theme(
      data: buildAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
          centerTitle: true,
        ),
        body: Center(
          child:Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  key: const ValueKey('username'),
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Введіть юзернейм',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  key: const ValueKey('email_field'),
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Введіть пошту',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  key: const ValueKey('password_field'),
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Введіть пароль'
                  ),
                ),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed:(){
                    registrationController.signUp(context,usernameController.text,emailController.text,passwordController.text);
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
      ),
    );
  }
}