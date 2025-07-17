import 'package:flutter/material.dart';


void main(List<String> args) {
  runApp(SimpleGreetingApp());

}

// Simple example: Greeting application
class SimpleGreetingApp extends StatelessWidget {
  const SimpleGreetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greeting App',
      home: GreetingScreen(),
    );
  }
}

// Greeting screen with button
class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  GreetingScreenState createState() => GreetingScreenState();
}

class GreetingScreenState extends State<GreetingScreen> {
  // State variables
  String greeting = "Hello!";
  int clickCount = 0;
  
  // Function to change greeting
  void changeGreeting() {
    setState(() {
      clickCount++;
      if (clickCount % 3 == 1) {
        greeting = "Hello!";
      } else if (clickCount % 3 == 2) {
        greeting = "Bonjour!";
      } else {
        greeting = "Hola!";
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: Text('First App'),
        backgroundColor: Colors.blue,
      ),
      
      // Main content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display greeting
            Text(
              greeting,
              style: TextStyle(
                fontSize: 30,
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 20), // Spacing
            
            // Display click count
            Text(
              'Clicked: $clickCount times',
              style: TextStyle(fontSize: 16),
            ),
            
            SizedBox(height: 30),
            
            // Button
            ElevatedButton(
              onPressed: changeGreeting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('Change Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}