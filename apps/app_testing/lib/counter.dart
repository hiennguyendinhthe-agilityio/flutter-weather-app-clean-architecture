import 'package:app_testing/drawer_menu.dart';
import 'package:app_testing/models/counter_porvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Couter App',
        ),
        backgroundColor: Colors.teal,
      ),
      drawer: const DrawerMenu(),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Consumer<CounterPorvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                Text(context.watch<CounterPorvider>().counterValue.toString()),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterPorvider>().incrementValue();
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CounterPorvider>().decrementValue();
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
