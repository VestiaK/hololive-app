
import 'package:first/views/widget_tree.dart';
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
                        return WidgetTree();
                      },
                    ),
                  );
                },
                child: Text('login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
