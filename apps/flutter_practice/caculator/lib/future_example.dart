import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(FutureExampleApp());
}

class FutureExampleApp extends StatelessWidget {
  const FutureExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DataFetcherScreen());
  }
}

class DataFetcherScreen extends StatefulWidget {
  const DataFetcherScreen({super.key});

  @override
  State<DataFetcherScreen> createState() => _DataFetcherScreenState();
}

class _DataFetcherScreenState extends State<DataFetcherScreen> {
  String _displayMessage = 'On pressing the button, data will be fetched';

  Future<String> _fetchUserData() {
    return Future.delayed(const Duration(seconds: 3), () {
      return 'Data fetched successfully';
    });
  }

  void _getUserDate() async {
    setState(() {
      _displayMessage = 'Loading...';
    });

    String userName = await _fetchUserData();

    setState(() {
      _displayMessage = 'Data fetched: $userName';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _displayMessage,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getUserDate,
              child: const Text('Fetch User Data'),
            ),
          ],
        ),
      ),
    );
  }
}
