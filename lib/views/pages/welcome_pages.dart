import 'package:first/views/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../data/notifiers.dart';

class WelcomePages extends StatelessWidget {
  const WelcomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('lotties/c.json'),
              FittedBox(
                child: Text(
                  'Welcome to the app!',
                  style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold, letterSpacing: 30.0),
                ),
              ),
              SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  selectedPage.value = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPages();
                      },
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Login'),
              ),

              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  selectedPage.value = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPages();
                      },
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
