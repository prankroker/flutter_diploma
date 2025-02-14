import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_diploma/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter_diploma/global/animation/splashScreen.dart';
import 'package:flutter_diploma/global/common/toast.dart';
import 'package:flutter_diploma/mainPage.dart';
import 'package:flutter_diploma/registration.dart';
import 'package:flutter_diploma/themes/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future main() async {//підключення бази даних і запуск програми
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: "AIzaSyAwu0yadvTwc_stANvgBcoqnMx0-8et43A",
    appId: "1:1074077607697:web:ce8e6a3acf56180c1e0eb0",
    messagingSenderId: "1074077607697",
    projectId: "mobilka-ai-feat")
    );
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyHome());
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//відключення прапорця дебаг
      theme: buildAppTheme(),// застосуваня тем
      home: const SplashScreen(),// виклик класу та його запуск
    );
  }
}

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        body: const InputForms(),
      ),
    );
  }
}

class InputForms extends StatefulWidget{
  const InputForms({super.key});

  @override
  State<InputForms> createState() => _InputForms();
}

class _InputForms extends State<InputForms>{

  final FirebaseAuthService _auth = FirebaseAuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var _firebaseAuth;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Введіть email',
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Введіть пароль',
                ),
              ),
              const SizedBox(height: 20,),
              TextButton(
                onPressed:(){
                  _signIn();
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
                      _signInWithGoogle();
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
    );
  }

  void _signIn() async{

    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if(user != null){
      showToast(message: "User is succesfully signIn");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  _signInWithGoogle()async{

    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if(googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }catch(e){
      showToast(message: "Some error occured in Google login");
    }

  }

}