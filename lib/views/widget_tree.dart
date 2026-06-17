import 'package:first/data/notifiers.dart';
import 'package:first/views/pages/home_pages.dart';
import 'package:first/views/pages/settings_pages.dart';
import 'package:first/views/widget/nav_widget.dart';
import 'package:flutter/material.dart';

import 'package:first/views/pages/profile_pages.dart';

List<Widget> pages = [MyHome(), ProfilePages()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vtuber App'),
        actions: [
          IconButton(
            onPressed: () {
              darkmode.value = !darkmode.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: darkmode,
              builder: (context, dark, child) {
                return Icon(dark ? Icons.dark_mode : Icons.light_mode);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Settings(
                      
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (context, cu, child) {
          return pages.elementAt(cu);
        },
      ),

      bottomNavigationBar: NavWidget(),
    );
  }
}
