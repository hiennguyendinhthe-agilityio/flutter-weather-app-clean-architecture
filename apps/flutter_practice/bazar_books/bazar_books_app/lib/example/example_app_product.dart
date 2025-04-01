import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Builder(
        builder: (context) {
          DeepLinkHandler.init(context);
          return const HomeScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      "productId": "P001",
      "name": "Nike Air Max",
      "price": 199.99,
      "imageUrl":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "productId": "P002",
      "name": "Adidas UltraBoost",
      "price": 179.99,
      "imageUrl":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
    {
      "productId": "P003",
      "name": "Puma RS-X",
      "price": 159.99,
      "imageUrl":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product List")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Image.network(product["imageUrl"],
                  width: 50, height: 50, fit: BoxFit.cover),
              title: Text(product["name"]),
              subtitle: Text("\$${product["price"]}"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productId: product["productId"],
                      name: product["name"],
                      price: product["price"],
                      imageUrl: product["imageUrl"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DynamicLinkService {
  Future<String> createProductShareLink({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
  }) async {
    final encodedName = Uri.encodeComponent(name);
    final encodedImage = Uri.encodeComponent(imageUrl);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bazarbooks.page.link',
      link: Uri.parse(
        'https://bazarbooks.com/product?productId=$productId&name=$encodedName&price=$price&image=$encodedImage',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.bazar_books_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.bazarBooksApp',
        minimumVersion: '1.0.1',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: name,
        description: 'Check out this amazing product for just \$$price!',
        imageUrl: Uri.parse(imageUrl),
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return shortLink.shortUrl.toString();
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  void _shareProduct() async {
    final String link = await DynamicLinkService().createProductShareLink(
      productId: productId,
      name: name,
      price: price,
      imageUrl: imageUrl,
    );

    debugPrint("Product Share Link: $link");
    Share.share("Check out this product: $link");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Column(
        children: [
          Image.network(imageUrl, height: 250),
          Text(name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("\$$price",
              style: const TextStyle(fontSize: 20, color: Colors.green)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _shareProduct,
            child: const Text("Share Product"),
          ),
        ],
      ),
    );
  }
}

class DeepLinkHandler {
  static void init(BuildContext context) {
    FirebaseDynamicLinks.instance.getInitialLink().then(_handleDeepLink);

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      _handleDeepLink(data);
    }).onError((error) {
      debugPrint("❌ Deep Link Error: $error");
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    if (data != null) {
      final Uri deepLink = data.link;
      debugPrint("✅ Deep Link Received: ${deepLink.toString()}");

      final productId = deepLink.queryParameters["productId"] ?? "N/A";
      final name =
          Uri.decodeComponent(deepLink.queryParameters["name"] ?? "Unknown");
      final price =
          double.tryParse(deepLink.queryParameters["price"] ?? "0") ?? 0;
      final imageUrl =
          Uri.decodeComponent(deepLink.queryParameters["image"] ?? "");

      if (navigatorKey.currentState != null &&
          navigatorKey.currentState!.mounted) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: productId,
              name: name,
              price: price,
              imageUrl: imageUrl,
            ),
          ),
        );
      }
    }
  }
}
