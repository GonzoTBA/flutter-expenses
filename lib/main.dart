import 'package:expenses/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:expenses/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Make sure you have imported 'package:firebase_core/firebase_core.dart';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FutureBuilder<void>(
                future: _signInAndNavigate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const HomeScreen();
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )),
            );
          },
          child: const Text('Sign In'),
        ),
      ),
    );
  }

  Future<void> _signInAndNavigate() async {
    await _authService.signInAnonymously();
    // Here, after authentication, you can navigate to the main screen
  }
}
