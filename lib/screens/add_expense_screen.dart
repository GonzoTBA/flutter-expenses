import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:expenses/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    // Establece el enfoque en el campo de amount al inicio
    _amountFocus.requestFocus();
  }

  Future<void> _submitExpense(int amount, String description) async {
    if (amount > 0) {
      final expense = Expense(
        amount: amount, 
        description: description, 
        timestamp: DateTime.now());

      final user = FirebaseAuth.instance.currentUser;
      final userID = user?.uid;

      if (userID != null) {
        final newExpenseRef = _database.child('expenses').child(userID).push();
        await newExpenseRef.set(expense.toJson());
      }

      ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(
        const SnackBar(content: Text('Expense saved successfully!')),
      );

      _amountController.clear();
      _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(_scaffoldContext!).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
    }
  }

  BuildContext? _scaffoldContext; // Variable para capturar el contexto del Scaffold

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              focusNode: _amountFocus,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount (€)',
                hintText: 'Enter the amount spent.',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description (optional).',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final int amount = int.tryParse(_amountController.text) ?? 0;
                final String description = _descriptionController.text;
                _submitExpense(amount, description);
              },
              child: const Text('Submit Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
