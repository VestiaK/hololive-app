import 'package:first/views/pages/register_pages.dart';
import 'package:first/views/widget/hero_widget.dart';
import 'package:first/views/widget_tree.dart';
import 'package:flutter/material.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController controllerEmail = TextEditingController(text: 'admin');
  TextEditingController controllerPassword = TextEditingController(text: 'admin');

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                HeroWidget(title: 'Login'),
                SizedBox(height: 20),
                TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controllerPassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onEditingComplete: () {
                    setState(() {});
                  },
                ),
                SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    _handLogin();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterPages();
                        },
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Register'),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handLogin() {
    if (controllerEmail.text == 'admin' && controllerPassword.text == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
