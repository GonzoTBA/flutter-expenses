import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Expenses App!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                );
              },
              child: const Text('Add Expense'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to ExpensesListScreen
              },
              child: const Text('View Expenses List'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to BalanceScreen
              },
              child: const Text('View Balance'),
            ),
          ],
        ),
      ),
    );
  }
}
