import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/LoginController.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:flutter_diploma/views/screens/auth/registrationPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final LoginController loginController = LoginController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Авторизація';

    return Theme(
      data: buildAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(appTitle),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  key: const ValueKey('email_field'),
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Введіть email',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  key: const ValueKey('password_field'),
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Введіть пароль',
                  ),
                ),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed:(){
                    loginController.signIn(context,emailController.text,passwordController.text);
                  },
                  child: const Text("Далі"),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FontAwesomeIcons.google,color: Colors.cyan,),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        loginController.signInWithGoogle(context);
                      },
                      child: const Text(" Google auth",style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Немає аккаунта?"),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Registration()));
                      },
                      child: const Text(" Зареєструйтеся",style: TextStyle(color: Colors.cyan,fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}