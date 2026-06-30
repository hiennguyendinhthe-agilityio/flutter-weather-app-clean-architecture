import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ProductCard(
            productId: 'product1',
            productName: 'IPhone 13',
            price: '\$1000',
            color: Colors.blue.shade100,
            icon: Icons.phone_iphone,
          ),

          const SizedBox(height: 16.0),

          ProductCard(
            productId: 'product2',
            productName: 'Macbook Pro',
            price: '\$1200',
            color: Colors.purple.shade100,
            icon: Icons.laptop_mac,
          ),

          const SizedBox(height: 16.0),

          ProductCard(
            productId: 'product3',
            productName: 'AirPods',
            price: '\$200',
            color: Colors.green.shade100,
            icon: Icons.headphones,
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productId;
  final String productName;
  final String price;
  final Color color;
  final IconData icon;
  const ProductCard({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: productId,
              productName: productName,
              price: price,
              color: color,
              icon: icon,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Hero(
                tag: productId,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
              ),

              const SizedBox(width: 16.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const Spacer(),

              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String productName;
  final String price;
  final Color color;
  final IconData icon;
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.price,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Column(
        children: [
          const SizedBox(height: 16.0),

          Center(
            child: Hero(
              tag: productId,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 100),
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          Text(
            productName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8.0),

          Text(
            price,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const Spacer(),

          ElevatedButton.icon(
            onPressed: () {},
            label: const Text('Add Product'),
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
    );
  }
}
