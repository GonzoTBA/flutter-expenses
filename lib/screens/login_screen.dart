import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expenses/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _navigateToHomeScreen();
    }
  }

  void _signInAndNavigate() async {
    await _auth.signInAnonymously();
    await _navigateToHomeScreen();
  }

  Future<void> _navigateToHomeScreen() async {
    final navigator = Navigator.of(context);
    await navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _signInAndNavigate,
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}
