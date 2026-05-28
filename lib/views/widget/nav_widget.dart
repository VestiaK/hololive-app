import 'package:first/data/notifiers.dart';
import 'package:flutter/material.dart';

class NavWidget extends StatelessWidget {
  const NavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPage,
      builder: (context, cu, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home_mini), label: 'home'),
            NavigationDestination(icon: Icon(Icons.person_3), label: 'Profile'),
          ],
          onDestinationSelected: (int value) {
            selectedPage.value = value; 
          },
          selectedIndex: cu,
        );
      },
    );
  }
}
