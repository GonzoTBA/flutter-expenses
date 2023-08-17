import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  BalanceScreenState createState() => BalanceScreenState();
}

class BalanceScreenState extends State<BalanceScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int currentUserTotal = 0;
  int otherUserTotal = 0;

  @override
  void initState() {
    super.initState();
    _calculateExpenses();
    _listenForAuthChanges();
  }

  void _listenForAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Usuario autenticado, calcula los gastos
        _calculateExpenses();
      } else {
        // Usuario no autenticado, reinicia los totales
        setState(() {
          currentUserTotal = 0;
          otherUserTotal = 0;
        });
      }
    });
  }

  Future<void> _calculateExpenses() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return; // No hay usuario autenticado
      print('No user authenticated');
    }

    final currentUserID = currentUser.uid;
    final dataSnapshot = await _database.child('expenses').child(currentUserID).once();
    final currentUserExpenses = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    print('Current user expenses: $currentUserExpenses');

    int currentUserTotal = 0;
    if (currentUserExpenses != null) {
      currentUserExpenses.forEach((expenseID, expenseData) {
        final amount = expenseData['amount'] as int;
        currentUserTotal += amount;
      });
    }

    print('Current user total: $currentUserTotal');

    // Obtén la lista de usuarios autenticados
    final usersSnapshot = await _database.child('users').once();
    final usersData = usersSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    int otherUserTotal = 0;
    if (usersData != null) {
      usersData.forEach((userID, userData) {
        // Excluye el usuario actual
        if (userID != currentUserID) {
          final userExpenses = userData['expenses'] as Map<dynamic, dynamic>?;
          if (userExpenses != null) {
            userExpenses.forEach((expenseID, expenseData) {
              final amount = expenseData['amount'] as int;
              otherUserTotal += amount;
            });
          }
        }
      });
    }

    setState(() {
      this.currentUserTotal = currentUserTotal;
      this.otherUserTotal = otherUserTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your total expenses: $currentUserTotal euros'),
            Text('Other user\'s total expenses: $otherUserTotal euros'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: BalanceScreen(),
  ));
}
