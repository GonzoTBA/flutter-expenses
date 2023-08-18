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
  List<String> userIDs = [];
  int currentUserTotal = 0;
  int otherUserTotal = 0;
  String otherUserName = ''; // Nombre del otro usuario
  int expenseDifference = 0; // Diferencia de gastos entre los usuarios
  String currentUserName = '';
  int expenseDifferenceFinal = 0;
  String higherPayerName = '';

  @override
  void initState() {
    super.initState();
    _readUserIDs().then((ids) {
      setState(() {
        userIDs = ids;
      });
      _calculateBalances().then((_) {
        _prepareData();
      });
    });
    print('User Ids: $userIDs');
  }

  void _prepareData() {
    // Calculate difference
    expenseDifferenceFinal = expenseDifference.abs();
    // Get higher payer name
    if (expenseDifference >= 0) {
      higherPayerName = currentUserName;
    } else {
      higherPayerName = otherUserName;
    }
    setState(() {
      expenseDifferenceFinal = expenseDifferenceFinal;
      higherPayerName = higherPayerName;
    });
  }

  Future<void> _calculateBalances() async {
    print('Executing function _calculateBalances');
    if (userIDs.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final String currentUserEmail = currentUser.email as String;
        final currentUserId = currentUser.uid;
        final currentUserTotal = await calculateTotalExpensesForUser(currentUserId);
        
        // Get current User Name
        if (currentUserEmail.contains('jmalonda')) {
          currentUserName = 'Javier';
          otherUserName = 'Daniela';
        } else {
          currentUserName = 'Daniela';
          otherUserName = 'Javier';
        }
        print('Current user name: $currentUserName');
        setState(() {
          this.currentUserTotal = currentUserTotal;
        });

        if (userIDs.length >= 2) {
          final otherUserID = userIDs.firstWhere((id) => id != currentUserId);

          final otherUserTotal = await calculateTotalExpensesForUser(otherUserID);
          setState(() {
            this.otherUserTotal = otherUserTotal;
            expenseDifference = currentUserTotal - otherUserTotal;
          });
        }
      }
    }
  }

  Future<List<String>> _readUserIDs() async {
    final usersSnapshot = await _database.child('expenses').once();
    print('Printing usersSnapshot: $usersSnapshot');

    if (usersSnapshot.snapshot.value != null) {
      final Map<dynamic, dynamic>? usersData = usersSnapshot.snapshot.value as Map<dynamic, dynamic>?;
      print('Printing usersData: $usersData');

      if (usersData != null) {
        userIDs = usersData.keys.cast<String>().toList();
        print('Printing userIDs: $userIDs');

        return userIDs;
      }
    }

    return [];
  }

  Future<int> calculateTotalExpensesForUser(String userID) async {
  final userExpensesSnapshot = await _database.child('expenses').child(userID).once();

  int totalExpenses = 0;

  if (userExpensesSnapshot.snapshot.value != null) {
    final Map<dynamic, dynamic>? userExpensesData = userExpensesSnapshot.snapshot.value as Map<dynamic, dynamic>?;
    
    if (userExpensesData != null) {
      userExpensesData.forEach((expenseID, expenseData) {
        final amount = expenseData['amount'] as int;
        totalExpenses += amount;
      });
    }
  }

  return totalExpenses;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$currentUserName total expenses: $currentUserTotal €',
                style: const TextStyle(fontSize: 20.0)),
              Text('$otherUserName total: $otherUserTotal €',
                style: const TextStyle(fontSize: 20.0)),
              const SizedBox(height: 20.0),
              const Divider(height: 5.0),
              const SizedBox(height: 20.0),
              Text('$higherPayerName has a positive balance of $expenseDifferenceFinal €',
                style: const TextStyle(fontSize: 25.0)),
            ],
          ),
        ),
      ),
    );
  }
}

