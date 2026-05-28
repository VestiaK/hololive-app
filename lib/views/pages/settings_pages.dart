import 'package:flutter/material.dart';

import '../../data/notifiers.dart';

class Settings extends StatefulWidget {
  const Settings({super.key, required this.title, });


final String title;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        //opsional klo mau back kemana 
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onEditingComplete: () {
                  setState(() {});
                },
              ),
              Text(controller.text),
              ValueListenableBuilder(
                valueListenable: isChecked,
                builder: (context, a, child) {
                  return Checkbox(
                    value: a,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked.value = value;
                      });
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isChecked,
                builder: (context, a, child) {
                  return CheckboxListTile(
                    title: Text('aku kpop'),
                    value: a,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked.value = value;
                      });
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isSwitch,
                builder: (context, b, child) {
                  return Switch(
                    value: b,
                    onChanged: (bool value) {
                      setState(() {
                        isSwitch.value = value;
                      });
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isSwitch,
                builder: (context, b, child) {
                  return SwitchListTile(
                    title: Text('aku wibu'),
                    value: b,
                    onChanged: (bool value) {
                      setState(() {
                        isSwitch.value = value;
                      });
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isSlider,
                builder: (context, a, child) {
                  return Slider(
                    max: 10,
                    divisions: 10,
                    value: a,
                    onChanged: (double value) {
                      setState(() {
                        isSlider.value = value;
                      });
                    },
                  );
                },
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.black38,
                ),
              ),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (context) {
                    return AboutDialog();
                  },);
              }, child: Text('about'),),
              Divider(
                color: Colors.greenAccent,
                thickness: 5.0,
                endIndent: 100,
              ),
              ElevatedButton(onPressed: () {
                showDialog(context: context, builder: (context) {
                    return AlertDialog(
                    title: Text('awasss'),
                    content: Text('kontol'),
                    actions: [
                      FilledButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Close'))
                    ],);
                  },);
              }, child: Text('alert'))
            ],
          ),
        ),
      ),
    );
  }
}
