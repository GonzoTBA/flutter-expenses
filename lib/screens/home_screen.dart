import 'package:flutter/material.dart';
import 'package:expenses/screens/add_expense_screen.dart';
import 'package:expenses/screens/expense_list_screen.dart';

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
      body: _setBody(),
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

  Widget _setBody() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemCount: 3, // Number of pages/screens
      itemBuilder: (context, index) {
        if (index == 0) {
          return const AddExpenseScreen();
        } else if (index == 1) {
          return const ExpenseListScreen();
        } else {
          // Handle other screens if needed
          return Container();
        }
      },
    );
  }
}