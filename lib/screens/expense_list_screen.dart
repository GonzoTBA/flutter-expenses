import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../expense_model.dart';

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
    final dataSnapshot = await _database.child('expenses')
        .orderByChild('timestamp')
        .limitToLast(20)
        .once();

    final dataMap = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (dataMap != null) {
      final List<Expense> loadedExpenses = dataMap.entries.map((entry) {
        final Map<dynamic, dynamic> expenseMap = entry.value;
        return Expense(
          amount: expenseMap['amount'] as int, // Parse as int
          description: expenseMap['description'] as String,
          timestamp: DateTime.parse(expenseMap['timestamp'] as String), // Parse as DateTime
        );
      }).toList();

      setState(() {
        _expenses.addAll(loadedExpenses);
      });
    }
  }

  Future<void> _loadMoreExpenses() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _expenses.length + 1, // Add 1 for loading indicator
        itemBuilder: (context, index) {
          if (index < _expenses.length) {
            final expense = _expenses[index];
            return ListTile(
              title: Text('Amount: ${expense.amount.toString()}'),
              subtitle: Text('Description: ${expense.description}'),
            );
          } else {
            return _isLoading ? const CircularProgressIndicator() : const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
