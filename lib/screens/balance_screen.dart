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
  String otherUserName = ''; 
  int expenseDifference = 0; 
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

    if (usersSnapshot.snapshot.value != null) {
      final Map<dynamic, dynamic>? usersData = usersSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (usersData != null) {
        userIDs = usersData.keys.cast<String>().toList();

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
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                child: ListTile(
                  title: Text(
                    '$currentUserName total expenses',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$currentUserTotal €',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                child: ListTile(
                  title: Text(
                    '$otherUserName total expenses',
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$otherUserTotal €',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
                Card(
                  color: Colors.blueAccent,
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                  child: Padding( 
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: const Text(
                        'Balance',
                        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        '$higherPayerName has a positive balance of $expenseDifferenceFinal €',
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
