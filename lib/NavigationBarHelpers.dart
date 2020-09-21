import 'package:flutter/material.dart';

import 'Theme.dart';

class SalusBottomNavigationBar extends StatelessWidget {
  final index;

  SalusBottomNavigationBar(this.index);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // onTap: (tappedIndex) => {},
        selectedItemColor: Salus.headerTextBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: "Schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.ballot_outlined), activeIcon: Icon(Icons.ballot), label: "Grocery List"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), activeIcon: Icon(Icons.account_circle), label: "Account")
        ],
      );
  }
}