import 'package:first/data/notifiers.dart';
import 'package:first/views/pages/welcome_pages.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: darkmode,
      builder: (context, dark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.greenAccent,
              brightness: dark ? Brightness.light : Brightness.dark,
            ),
          ),
          home: WelcomePages(),
        );
      },
    );
  }
}
