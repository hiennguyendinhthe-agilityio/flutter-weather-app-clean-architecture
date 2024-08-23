import 'package:flutter/material.dart';

class CounterPorvider extends ChangeNotifier {
  int counterValue;

  CounterPorvider({this.counterValue = 0});

  void incrementValue() {
    counterValue++;
    notifyListeners();
  }

  void decrementValue() {
    counterValue--;
    notifyListeners();
  }
}
