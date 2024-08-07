import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:expenses/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Establece el enfoque en el campo de amount al inicio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _amountFocus.requestFocus();
    });
  }

  Future<void> _submitExpense(int amount, String description) async {
    if (description.isEmpty) {
      description = '---';
    }
    if (amount > 0 && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      final userID = user?.uid;

      if (userID != null) {
        final newExpenseRef = _database.child('expenses').child(userID).push();
        final expense = Expense(
          id: newExpenseRef.key,
          amount: amount,
          description: description,
          timestamp: DateTime.now(),
        );
        try {
          await newExpenseRef.set(expense.toJson());

          Fluttertoast.showToast(
            msg: 'Expense saved successfully!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          _amountController.clear();
          _descriptionController.clear();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _amountFocus.requestFocus();
          });
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Failed to save expense. Please try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } finally {
          setState(() {
            _isSubmitting = false;
          });
        }
      } else {
        setState(() {
          _isSubmitting = false;
        });
        Fluttertoast.showToast(
          msg: 'User not authenticated. Please log in.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
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
              autofocus: true,
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
            onPressed: _isSubmitting ? null : () {
              final int amount = int.tryParse(_amountController.text) ?? 0;
              final String description = _descriptionController.text;
              _submitExpense(amount, description);
            },
            child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit Expense'),
            )

            // Logout button for development purposes
            // ElevatedButton(
            //   onPressed: () {
            //     final localContext = context; // Captura el contexto actual antes de entrar en la función asíncrona
            //     FirebaseAuth.instance.signOut().then((_) {
            //       Navigator.pushReplacementNamed(localContext, '/login'); // Redirige usando el contexto capturado
            //     }).catchError((error) {
            //       // Manejo de errores si ocurre algún problema al cerrar sesión
            //     });
            //   },
            //   child: const Text('Cerrar Sesión Temporal'),
            // ),

          ],
        ),
      ),
    );
  }
}
