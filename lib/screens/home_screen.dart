import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
//import 'expenses_list_screen.dart'; // Asegúrate de importar la pantalla ExpensesListScreen
//import 'balance_screen.dart'; // Asegúrate de importar la pantalla BalanceScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                setState(() {
                  _currentIndex = 1; // Cambia a la pantalla de lista de gastos
                });
                _pageController.jumpToPage(1);
              },
              child: const Text('View Expenses List'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 2; // Cambia a la pantalla de balance
                });
                _pageController.jumpToPage(2);
              },
              child: const Text('View Balance'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Expense list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Check balance',
          ),
        ],
      ),
    );
  }
}
