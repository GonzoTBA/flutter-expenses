import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  ExpenseListScreenState createState() => ExpenseListScreenState();
}

class ExpenseListScreenState extends State<ExpenseListScreen> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final List<Expense> _expenses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialExpenses();
    _scrollController.addListener(_loadMoreExpenses);
  }

  Future<void> _loadInitialExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Exit if user is not authenticated
    }

    final userID = user.uid;
    final dataSnapshot = await _database.child('expenses').child(userID)
        .orderByChild('timestamp')
        .limitToLast(20)
        .once();

    final dataMap = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (dataMap != null) {
      final List<Expense> loadedExpenses = dataMap.entries.map((entry) {
        final Map<dynamic, dynamic> expenseMap = entry.value;
        return Expense(
          amount: expenseMap['amount'] as int,
          description: expenseMap['description'] as String,
          timestamp: DateTime.parse(expenseMap['timestamp'] as String),
        );
      }).toList();

      setState(() {
        _expenses.addAll(loadedExpenses);
      });
    }
  }

  Future<void> _loadMoreExpenses() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading) {
        setState(() {
          _isLoading = true;
        });

        // Load more expenses and append them to _expenses list

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 60,
          columns: const [
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Date')),
          ],
          rows: _expenses.map((expense) {
            final formattedDate =
                DateFormat('dd.MM.yyyy').format(expense.timestamp);
            return DataRow(
              cells: [
                DataCell(Text(expense.description)),
                DataCell(Text(expense.amount.toString())),
                DataCell(Text(formattedDate)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
