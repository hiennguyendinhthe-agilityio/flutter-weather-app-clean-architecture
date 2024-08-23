import 'package:app_testing/drawer_menu.dart';
import 'package:app_testing/models/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:provider/provider.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    String text = lorem(paragraphs: 3, words: 50);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.teal,
      ),
      drawer: const DrawerMenu(),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Consumer<UI>(
          builder: (context, ui, child) {
            return RichText(
              text: TextSpan(
                text: text,
                style:
                    TextStyle(fontSize: ui.fontSize, color: Colors.lightBlue),
              ),
            );
          },
        ),
      ),
    );
  }
}
