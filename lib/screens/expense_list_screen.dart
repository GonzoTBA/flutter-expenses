import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  ExpenseListScreenState createState() => ExpenseListScreenState();
}

class ExpenseListScreenState extends State<ExpenseListScreen> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final List<Expense> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialExpenses();
    _scrollController.addListener(_loadMoreExpenses);
  }

  Future<void> _loadInitialExpenses() async {
    setState(() {
      _isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return; // Exit if user is not authenticated
    }

    final userID = user.uid;
    final dataSnapshot = await _database.child('expenses').child(userID)
        .orderByChild('timestamp')
        .limitToLast(50)
        .once();

    final dataMap = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (dataMap != null) {
      final List<Expense> loadedExpenses = dataMap.entries.map((entry) {
        final Map<dynamic, dynamic> expenseMap = entry.value;
        return Expense(
          id: entry.key ?? '',
          amount: expenseMap['amount'] as int,
          description: expenseMap['description'] as String,
          timestamp: DateTime.parse(expenseMap['timestamp'] as String),
        );
      }).toList();

            // Sort the loaded expenses by timestamp in descending order
      loadedExpenses.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      setState(() {
        _expenses.addAll(loadedExpenses);
      });
    }

    setState(() {
      _isLoading = false;
    });
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

  Future<void> _deleteExpense(Expense expense) async {
    print("Intentando borrar gasto con ID: ${expense.id}");
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && expense.id != null) {
      try {
        await _database.child('expenses').child(user.uid).child(expense.id!).remove();
        setState(() {
          _expenses.removeWhere((exp) => exp.id == expense.id);
        });

        Fluttertoast.showToast(
          msg: "Expense deleted successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        print("Error al borrar el gasto: $e");
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, Expense expense) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe hacer una elección
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
                _deleteExpense(expense); // Llama al método de eliminación
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Close keyboard upon loading screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              clipBehavior: Clip.hardEdge,
              headingRowHeight: 56.0,
              columnSpacing: 20.0,
              columns: const [
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Action')),
              ],
              rows: _expenses.map((expense) {
                final formattedDate =
                    DateFormat('dd.MM.yyyy').format(expense.timestamp);
                return DataRow(
                  cells: [
                    DataCell(Text(expense.description)),
                    DataCell(Text(expense.amount.toString())),
                    DataCell(Text(formattedDate)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, expense);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ),
    );
  }
}
