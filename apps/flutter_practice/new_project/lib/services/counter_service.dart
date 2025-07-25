import 'package:injectable/injectable.dart';

@injectable
class CounterService {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
  }

  void decrement() {
    _count--;
  }

  void reset() {
    _count = 0;
  }
}
