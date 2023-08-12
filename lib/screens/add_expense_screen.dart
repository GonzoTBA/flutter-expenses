import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final logger = Logger();

  void _submitExpense() {
    if (_amountController.text.isNotEmpty) {
      final double? amount = double.tryParse(_amountController.text);
      final String description = _descriptionController.text;

      if (amount != null && amount > 0) {
        // Log the amount and description
        logger.i('Amount: $amount, Description: $description');

        // Clear the text fields
        _amountController.clear();
        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount.')),
        );
      }
    }
  }

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
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _submitExpense,
              child: const Text('Submit Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
