import 'package:flutter/material.dart';
import 'package:expenses/services/auth_service.dart';
import 'package:expenses/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  void _signInAndNavigate(BuildContext context) async {
    await _authService.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            _signInAndNavigate(context);
            // Here, after authentication, you can navigate to the main screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}