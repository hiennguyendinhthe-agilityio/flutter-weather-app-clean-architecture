import 'package:flutter/material.dart';

// SOLUTION 1: USING PROVIDER
// Provider is the simplest way to manage state

// 1. Create Model to store state
class AppState extends ChangeNotifier {
  // Private variables
  int _counter = 0;
  String _userName = "Not logged in";
  final List<String> _cartItems = [];

  // Getters - to read data
  int get counter => _counter;
  String get userName => _userName;
  List<String> get cartItems => _cartItems;
  int get cartItemCount => _cartItems.length;

  // Methods to change state
  void incrementCounter() {
    _counter++;
    debugPrint("📊 Provider: Counter increased to $_counter");
    notifyListeners(); // Notify UI to update
  }

  void decrementCounter() {
    _counter--;
    debugPrint("📊 Provider: Counter decreased to $_counter");
    notifyListeners();
  }

  void updateUserName(String newName) {
    _userName = newName;
    debugPrint("👤 Provider: Name changed to '$newName'");
    notifyListeners();
  }

  void addToCart(String item) {
    _cartItems.add(item);
    debugPrint("🛒 Provider: Added '$item' to cart");
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      String removedItem = _cartItems.removeAt(index);
      debugPrint("❌ Provider: Removed '$removedItem' from cart");
      notifyListeners();
    }
  }
}

// 2. Main App - Simulating Provider pattern
class ProviderExampleApp extends StatefulWidget {
  const ProviderExampleApp({super.key});

  @override
  ProviderExampleAppState createState() => ProviderExampleAppState();
}

class ProviderExampleAppState extends State<ProviderExampleApp> {
  late AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState();
    // Listen to changes from AppState
    appState.addListener(() {
      setState(() {}); // Rebuild UI when there are changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Example',
      home: ProviderMainScreen(appState: appState),
    );
  }
}

// 3. Main Screen
class ProviderMainScreen extends StatelessWidget {
  final AppState appState;

  const ProviderMainScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    debugPrint("🔄 ProviderMainScreen build");

    return Scaffold(
      appBar: AppBar(
        title: Text('Provider State Management'),
        backgroundColor: Colors.green[400],
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Cart: ${appState.cartItemCount}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.green[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${appState.userName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Cart: ${appState.cartItemCount} items'),
                Text('Counter: ${appState.counter}'),
              ],
            ),
          ),

          // Tabs
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.green,
                    tabs: [
                      Tab(icon: Icon(Icons.person), text: 'Profile'),
                      Tab(icon: Icon(Icons.shopping_cart), text: 'Shopping'),
                      Tab(icon: Icon(Icons.calculate), text: 'Counter'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ProviderProfileWidget(appState: appState),
                        ProviderShoppingWidget(appState: appState),
                        ProviderCounterWidget(appState: appState),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Profile Widget
class ProviderProfileWidget extends StatelessWidget {
  final AppState appState;

  const ProviderProfileWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
      text: appState.userName,
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 80, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'PROFILE SCREEN',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              appState.updateUserName(controller.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Update Name'),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '✅ PROVIDER PATTERN:\n'
              '• Centralized state management\n'
              '• Automatic UI updates\n'
              '• Clean separation of concerns',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green[800]),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. Shopping Widget
class ProviderShoppingWidget extends StatelessWidget {
  final AppState appState;
  final List<String> products = ['iPhone', 'Samsung', 'Laptop', 'Tablet'];

  ProviderShoppingWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.green),
          Text(
            'SHOPPING SCREEN',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Products
          Text('Products:', style: TextStyle(fontSize: 18)),
          ...products
              .map(
                (product) => ListTile(
                  title: Text(product),
                  trailing: ElevatedButton(
                    onPressed: () => appState.addToCart(product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Add'),
                  ),
                ),
              )
              ,

          SizedBox(height: 20),

          // Cart
          Text(
            'Cart (${appState.cartItemCount}):',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: appState.cartItems.isEmpty
                ? Center(child: Text('Cart is empty'))
                : ListView.builder(
                    itemCount: appState.cartItems.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(appState.cartItems[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => appState.removeFromCart(index),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// 6. Counter Widget
class ProviderCounterWidget extends StatelessWidget {
  final AppState appState;

  const ProviderCounterWidget({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calculate, size: 80, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'COUNTER SCREEN',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Text(
            '${appState.counter}',
            style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: appState.decrementCounter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(60, 60),
                ),
                child: Text('-'),
              ),
              ElevatedButton(
                onPressed: appState.incrementCounter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(60, 60),
                ),
                child: Text('+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
