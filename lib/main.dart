import 'package:flutter/material.dart';
import 'package:expenses/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expenses/screens/add_expense_screen.dart';

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
  final AuthService _authService = AuthService();
  bool _loggingIn = true;

  @override
  void initState() {
    super.initState();
    _signInAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loggingIn
            ? const CircularProgressIndicator()
            : Container(), // No muestra nada cuando no está iniciando sesión
      ),
    );
  }

  Future<void> _signInAndNavigate() async {
    await _authService.signInAnonymously();
    setState(() {
      _loggingIn = false;
    });

    // Delay the navigation slightly to avoid using context across async gaps
    await _navigateToAddExpenseScreen();
  }

  Future<void> _navigateToAddExpenseScreen() async {
    final navigator = Navigator.of(context);
    await navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );
  }
}
