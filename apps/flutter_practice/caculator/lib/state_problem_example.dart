import 'package:flutter/material.dart';

class StateProblemApp extends StatelessWidget {
  const StateProblemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'State Management Problems', home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int counter = 0;
  String userName = "Not logged in";
  List<String> cartItems = [];

  @override
  Widget build(BuildContext context) {
    debugPrint("🔄 MainScreen build - Counter: $counter");

    return Scaffold(
      appBar: AppBar(
        title: Text('State Management Problems'),
        backgroundColor: Colors.red[400],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: $userName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Cart: ${cartItems.length} items'),
                Text('Counter: $counter'),
              ],
            ),
          ),

          Expanded(
            child: PageView(
              children: [
                ProfileWidget(
                  userName: userName,
                  onNameChanged: (newName) {
                    setState(() {
                      userName = newName;
                    });
                    debugPrint("👤 Name changed: $newName");
                  },
                ),

                ShoppingWidget(
                  cartItems: cartItems,
                  onAddToCart: (item) {
                    setState(() {
                      cartItems.add(item);
                    });
                    debugPrint("🛒 Added to cart: $item");
                  },
                  onRemoveFromCart: (index) {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                    debugPrint("❌ Removed from cart: index $index");
                  },
                ),

                CounterWidget(
                  counter: counter,
                  onIncrement: () {
                    setState(() {
                      counter++;
                    });
                    debugPrint("➕ Counter increased: $counter");
                  },
                  onDecrement: () {
                    setState(() {
                      counter--;
                    });
                    debugPrint("➖ Counter decreased: $counter");
                  },
                ),
              ],
            ),
          ),

          Container(
            height: 60,
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Shopping', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Counter', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String userName;
  final Function(String) onNameChanged;

  const ProfileWidget({
    super.key,
    required this.userName,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🏗️ ProfileWidget build");
    TextEditingController controller = TextEditingController(text: userName);

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
              onNameChanged(controller.text);
            },
            child: Text('Update Name'),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⚠️ PROBLEM: Must pass data via props!\n'
              'When app grows → very complex!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange[800]),
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingWidget extends StatelessWidget {
  final List<String> cartItems;
  final Function(String) onAddToCart;
  final Function(int) onRemoveFromCart;

  const ShoppingWidget({
    super.key,
    required this.cartItems,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🏗️ ShoppingWidget build - Items: ${cartItems.length}");

    List<String> products = ['iPhone', 'Samsung', 'Laptop', 'Tablet'];

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

          Text('Available Products:', style: TextStyle(fontSize: 18)),
          ...products.map(
            (product) => ListTile(
              title: Text(product),
              trailing: ElevatedButton(
                onPressed: () => onAddToCart(product),
                child: Text('Add'),
              ),
            ),
          ),

          SizedBox(height: 20),

          Text('Cart (${cartItems.length}):', style: TextStyle(fontSize: 18)),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(cartItems[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemoveFromCart(index),
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⚠️ PROBLEM: Complex code, hard to maintain!\n'
              'Callback hell!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800]),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterWidget({
    super.key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("🏗️ CounterWidget build - Counter: $counter");

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
            '$counter',
            style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onDecrement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(60, 60),
                ),
                child: Text('-'),
              ),
              ElevatedButton(
                onPressed: onIncrement,
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⚠️ PROBLEM: All changes must\n'
              'go through parent widget!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.yellow[800]),
            ),
          ),
        ],
      ),
    );
  }
}
