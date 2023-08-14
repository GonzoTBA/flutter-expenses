import 'package:flutter/material.dart';

class BottomNavigationLayout extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;

  const BottomNavigationLayout({
    Key? key,
    required this.currentIndex,
    required this.screens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Navegación a la pantalla seleccionada
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
