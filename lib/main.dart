import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expenses/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loggingIn = false;
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loggingIn ? null : _signInOrRegister,
                child: Text(_loggingIn ? 'Logging in...' : 'Sign In/Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInOrRegister() async {
    setState(() {
      _loggingIn = true;
    });

    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      UserCredential userCredential;

      // Try to sign in
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (signInError) {
        // If sign in fails, try to register a new account
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      _logger.i('User signed in: ${userCredential.user?.uid}');

      // Navigate to home screen
      await _navigateToHomeScreen();
    } catch (e) {
      _logger.e('Error signing in/creating account: $e');
      setState(() {
        _loggingIn = false;
      });
    }
  }

  Future<void> _navigateToHomeScreen() async {
    final navigator = Navigator.of(context);
    await navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
