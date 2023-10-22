import 'package:cocktail_recipe_generator/Screens/homePage.dart';
import 'package:cocktail_recipe_generator/Screens/searchTab.dart';
import 'package:flutter/material.dart';

import 'favouritesTab.dart';

class BottomNavBar extends StatefulWidget {

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomePage(),
    SearchPage(),
    FavoritesTab(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex], // Show the selected tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
