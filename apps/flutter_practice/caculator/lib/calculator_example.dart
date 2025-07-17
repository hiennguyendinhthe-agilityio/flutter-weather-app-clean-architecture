import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  // State variables
  String display = "0";
  double firstNumber = 0;
  String operation = "";
  bool isNewNumber = true;
  
  // Handle number button press
  void onNumberPressed(String number) {
    setState(() {
      if (isNewNumber) {
        display = number;
        isNewNumber = false;
      } else {
        display = display + number;
      }
    });
  }
  
  // Handle operation button press
  void onOperationPressed(String op) {
    setState(() {
      firstNumber = double.parse(display);
      operation = op;
      isNewNumber = true;
    });
  }
  
  // Calculate result
  void calculate() {
    setState(() {
      double secondNumber = double.parse(display);
      double result = 0;
      
      switch (operation) {
        case '+':
          result = firstNumber + secondNumber;
          break;
        case '-':
          result = firstNumber - secondNumber;
          break;
        case '×':
          result = firstNumber * secondNumber;
          break;
        case '÷':
          result = firstNumber / secondNumber;
          break;
      }
      
      // Display result (remove .0 if integer)
      display = result % 1 == 0 ? result.toInt().toString() : result.toString();
      isNewNumber = true;
    });
  }
  
  // Clear function
  void clear() {
    setState(() {
      display = "0";
      firstNumber = 0;
      operation = "";
      isNewNumber = true;
    });
  }
  
  // Create button widget
  Widget buildButton(String text, Color color, Function() onPressed) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.all(20),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Display screen
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.black,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  display,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Keypad
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Row 1: C and division
                Expanded(
                  child: Row(
                    children: [
                      buildButton('C', Colors.red, clear),
                      buildButton('÷', Colors.orange, () => onOperationPressed('÷')),
                    ],
                  ),
                ),
                
                // Row 2: 7, 8, 9, ×
                Expanded(
                  child: Row(
                    children: [
                      buildButton('7', Colors.grey, () => onNumberPressed('7')),
                      buildButton('8', Colors.grey, () => onNumberPressed('8')),
                      buildButton('9', Colors.grey, () => onNumberPressed('9')),
                      buildButton('×', Colors.orange, () => onOperationPressed('×')),
                    ],
                  ),
                ),
                
                // Row 3: 4, 5, 6, -
                Expanded(
                  child: Row(
                    children: [
                      buildButton('4', Colors.grey, () => onNumberPressed('4')),
                      buildButton('5', Colors.grey, () => onNumberPressed('5')),
                      buildButton('6', Colors.grey, () => onNumberPressed('6')),
                      buildButton('-', Colors.orange, () => onOperationPressed('-')),
                    ],
                  ),
                ),
                
                // Row 4: 1, 2, 3, +
                Expanded(
                  child: Row(
                    children: [
                      buildButton('1', Colors.grey, () => onNumberPressed('1')),
                      buildButton('2', Colors.grey, () => onNumberPressed('2')),
                      buildButton('3', Colors.grey, () => onNumberPressed('3')),
                      buildButton('+', Colors.orange, () => onOperationPressed('+')),
                    ],
                  ),
                ),
                
                // Row 5: 0, =
                Expanded(
                  child: Row(
                    children: [
                      buildButton('0', Colors.grey, () => onNumberPressed('0')),
                      buildButton('=', Colors.green, calculate),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}