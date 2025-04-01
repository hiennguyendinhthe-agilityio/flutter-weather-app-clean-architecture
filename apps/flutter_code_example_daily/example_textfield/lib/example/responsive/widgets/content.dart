import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 3 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: List.generate(
            6,
            (index) => Container(
                  alignment: Alignment.center,
                  color: Colors.amber,
                  child: Text('Item ${index + 1}',
                      style: const TextStyle(fontSize: 24)),
                )),
      ),
    );
  }
}
