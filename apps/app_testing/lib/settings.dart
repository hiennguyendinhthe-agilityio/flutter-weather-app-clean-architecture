import 'package:app_testing/drawer_menu.dart';
import 'package:app_testing/models/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Settings',
        ),
      ),
      drawer: const DrawerMenu(),
      body: Consumer<UI>(
        builder: (context, ui, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  'Font Size: ${ui.fontSize.toInt()}',
                  style: TextStyle(
                    fontSize: ui.fontSize,
                  ),
                ),
              ),
              Slider(
                min: 0.5,
                value: ui.sliderFontSize,
                onChanged: (newValue) {
                  ui.fontSize = newValue;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
