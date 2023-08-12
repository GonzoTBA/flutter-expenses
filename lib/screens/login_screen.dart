import 'package:flutter/material.dart';
import 'package:expenses/services/auth_service.dart';

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
          onPressed: () async {
            await _authService.signInAnonymously();
            // Here, after authentication, you can navigate to the main screen
          },
          child: const Text('Sign In'),
        ),
      ),
    );
  }
}