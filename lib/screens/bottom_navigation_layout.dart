import 'package:flutter/material.dart';
import 'package:expenses/screens/add_expense_screen.dart';
import 'package:expenses/screens/expense_list_screen.dart';

class BottomNavigationLayout extends StatefulWidget {
  const BottomNavigationLayout({
    Key? key,
  }) : super(key: key);

  @override
  BottomNavigationLayoutState createState() => BottomNavigationLayoutState();
}

class BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  int _currentIndex = 0; // Inicialmente, muestra la primera pantalla

  final List<Widget> _screens = [
    const AddExpenseScreen(), // Cambia por tus pantallas reales
    const ExpenseListScreen(), // Cambia por tus pantallas reales
    // CheckBalanceScreen(), // Cambia por tus pantallas reales
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice actual al hacer tap en un ítem
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
      );
  }
}
