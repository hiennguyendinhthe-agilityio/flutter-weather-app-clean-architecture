import 'package:flutter/material.dart';
import 'dart:async';

// BLoC PATTERN - Business Logic Component
// Suitable for large applications with complex logic

// 1. EVENTS - Possible events that can occur
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class ResetEvent extends CounterEvent {}

// 2. STATES - Possible states
abstract class CounterState {}

class CounterInitial extends CounterState {
  final int counter;
  CounterInitial(this.counter);
}

class CounterLoading extends CounterState {}

class CounterUpdated extends CounterState {
  final int counter;
  final String message;

  CounterUpdated(this.counter, this.message);
}

class CounterError extends CounterState {
  final String error;
  CounterError(this.error);
}

// 3. BLoC - Business Logic Component
class CounterBloc {
  int _counter = 0;

  // Stream Controllers
  final _eventController = StreamController<CounterEvent>();
  final _stateController = StreamController<CounterState>();

  // Getters
  Stream<CounterState> get stateStream => _stateController.stream;
  Sink<CounterEvent> get eventSink => _eventController.sink;

  CounterBloc() {
    // Listen to events and handle them
    _eventController.stream.listen(_handleEvent);

    // Emit initial state
    _stateController.add(CounterInitial(_counter));
    debugPrint("🏭 CounterBloc initialized with counter = $_counter");
  }

  void _handleEvent(CounterEvent event) {
    debugPrint("📨 Received event: ${event.runtimeType}");

    if (event is IncrementEvent) {
      _handleIncrement();
    } else if (event is DecrementEvent) {
      _handleDecrement();
    } else if (event is ResetEvent) {
      _handleReset();
    }
  }

  void _handleIncrement() {
    debugPrint("⬆️ Handling increment event");

    // Emit loading state
    _stateController.add(CounterLoading());

    // Simulate async operation
    Future.delayed(Duration(milliseconds: 500), () {
      _counter++;
      debugPrint("📊 Counter increased to: $_counter");

      String message = _counter % 10 == 0
          ? "🎉 Milestone: $_counter!"
          : "Counter: $_counter";

      _stateController.add(CounterUpdated(_counter, message));
    });
  }

  void _handleDecrement() {
    debugPrint("⬇️ Handling decrement event");

    if (_counter > 0) {
      _stateController.add(CounterLoading());

      Future.delayed(Duration(milliseconds: 300), () {
        _counter--;
        debugPrint("📊 Counter decreased to: $_counter");

        String message = _counter == 0
            ? "🔄 Back to starting point!"
            : "Counter: $_counter";

        _stateController.add(CounterUpdated(_counter, message));
      });
    } else {
      debugPrint("⚠️ Cannot decrease below 0");
      _stateController.add(CounterError("Cannot decrease below 0!"));
    }
  }

  void _handleReset() {
    debugPrint("🔄 Handling reset event");

    _stateController.add(CounterLoading());

    Future.delayed(Duration(milliseconds: 200), () {
      _counter = 0;
      debugPrint("📊 Counter reset to: $_counter");
      _stateController.add(CounterUpdated(_counter, "🔄 Reset completed!"));
    });
  }

  void dispose() {
    debugPrint("🗑️ CounterBloc dispose");
    _eventController.close();
    _stateController.close();
  }
}

// 4. USER STATE BLoC
abstract class UserEvent {}

class LoginEvent extends UserEvent {
  final String username;
  LoginEvent(this.username);
}

class LogoutEvent extends UserEvent {}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoggedIn extends UserState {
  final String username;
  UserLoggedIn(this.username);
}

class UserLoggedOut extends UserState {}

class UserBloc {
  String? _currentUser;

  final _eventController = StreamController<UserEvent>();
  final _stateController = StreamController<UserState>();

  Stream<UserState> get stateStream => _stateController.stream;
  Sink<UserEvent> get eventSink => _eventController.sink;

  UserBloc() {
    _eventController.stream.listen(_handleEvent);
    _stateController.add(UserInitial());
    debugPrint("👤 UserBloc initialized");
  }

  void _handleEvent(UserEvent event) {
    if (event is LoginEvent) {
      _handleLogin(event.username);
    } else if (event is LogoutEvent) {
      _handleLogout();
    }
  }

  void _handleLogin(String username) {
    debugPrint("🔐 Login with username: $username");
    _stateController.add(UserLoading());

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      _currentUser = username;
      debugPrint("✅ Login successful: $_currentUser");
      _stateController.add(UserLoggedIn(username));
    });
  }

  void _handleLogout() {
    debugPrint("🚪 Logout user: $_currentUser");
    _currentUser = null;
    _stateController.add(UserLoggedOut());
  }

  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}

// 5. APP with BLoC
class BlocExampleApp extends StatelessWidget {
  const BlocExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'BLoC Example', home: BlocMainScreen());
  }
}

class BlocMainScreen extends StatefulWidget {
  const BlocMainScreen({super.key});

  @override
  BlocMainScreenState createState() => BlocMainScreenState();
}

class BlocMainScreenState extends State<BlocMainScreen> {
  late CounterBloc counterBloc;
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    counterBloc = CounterBloc();
    userBloc = UserBloc();
    debugPrint("🚀 BlocMainScreen initialized");
  }

  @override
  void dispose() {
    counterBloc.dispose();
    userBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Pattern Example'),
        backgroundColor: Colors.purple[400],
      ),
      body: Column(
        children: [
          // User Status
          StreamBuilder<UserState>(
            stream: userBloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              UserState state = snapshot.data!;
              String status = "Not logged in";
              Color color = Colors.grey;

              if (state is UserLoading) {
                status = "Logging in...";
                color = Colors.orange;
              } else if (state is UserLoggedIn) {
                status = "Hello, ${state.username}!";
                color = Colors.green;
              } else if (state is UserLoggedOut) {
                status = "Logged out";
                color = Colors.red;
              }

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: color.withValues(alpha: 0.1),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),

          // Counter Section
          Expanded(
            child: StreamBuilder<CounterState>(
              stream: counterBloc.stateStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                CounterState state = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calculate, size: 80, color: Colors.purple),
                      SizedBox(height: 20),
                      Text(
                        'BLoC COUNTER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),

                      // Counter Display
                      if (state is CounterLoading)
                        Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text(
                              'Processing...',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      else if (state is CounterInitial)
                        Text(
                          '${state.counter}',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (state is CounterUpdated)
                        Column(
                          children: [
                            Text(
                              '${state.counter}',
                              style: TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        )
                      else if (state is CounterError)
                        Column(
                          children: [
                            Icon(Icons.error, size: 60, color: Colors.red),
                            SizedBox(height: 10),
                            Text(
                              state.error,
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),

                      SizedBox(height: 40),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("👆 User pressed decrease button");
                              counterBloc.eventSink.add(DecrementEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              minimumSize: Size(60, 60),
                            ),
                            child: Text('-'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("👆 User pressed reset button");
                              counterBloc.eventSink.add(ResetEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              minimumSize: Size(80, 60),
                            ),
                            child: Text('Reset'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint("👆 User pressed increase button");
                              counterBloc.eventSink.add(IncrementEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: Size(60, 60),
                            ),
                            child: Text('+'),
                          ),
                        ],
                      ),

                      SizedBox(height: 40),

                      // Login/Logout buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              userBloc.eventSink.add(LoginEvent("John Doe"));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Login'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              userBloc.eventSink.add(LogoutEvent());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Logout'),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // BLoC Benefits
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple),
                        ),
                        child: Text(
                          '🎯 BLoC BENEFITS:\n'
                          '• Separation of Business Logic\n'
                          '• Reactive Programming\n'
                          '• Easy Testing\n'
                          '• Predictable State Management\n'
                          '• Great for Complex Apps',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.purple[800]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
