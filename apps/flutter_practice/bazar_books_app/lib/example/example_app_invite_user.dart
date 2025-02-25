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

class DynamicLinkService {
  Future<String> createShortLink({
    required String inviteCode,
    required String name,
    required String productId,
    required String source,
  }) async {
    final encodedName = Uri.encodeComponent(name);
    final encodedSource = Uri.encodeComponent(source);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bazarbooks.page.link',
      link: Uri.parse(
        'https://bazarbooks.com/invite?code=$inviteCode&name=$encodedName&productId=$productId&source=$encodedSource',
      ),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.bazar_books_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.bazarBooksApp',
        minimumVersion: '1.0.1',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Join Invite App!',
        description: 'Click to join using invite code!',
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return shortLink.shortUrl.toString();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _generateAndShareLink() async {
    final String link = await DynamicLinkService().createShortLink(
      inviteCode: "XYZ789",
      name: "John Doe",
      productId: "987",
      source: "messenger",
    );

    print("Short Link: $link"); // Debug log link
    Share.share("Join me on Invite App: $link");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invite Friends")),
      body: Center(
        child: ElevatedButton(
          onPressed: _generateAndShareLink,
          child: const Text("Share Invite Link"),
        ),
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
      print("Deep Link Error: $error");
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    if (data != null) {
      final Uri deepLink = data.link;
      print("✅ Deep Link Received: ${deepLink.toString()}");

      final inviteCode = deepLink.queryParameters["code"] ?? "N/A";
      final name = deepLink.queryParameters["name"] ?? "Unknown";
      final productId = deepLink.queryParameters["productId"] ?? "None";
      final source = deepLink.queryParameters["source"] ?? "Direct";

      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => InviteScreen(
            inviteCode: inviteCode,
            name: name,
            productId: productId,
            source: source,
          ),
        ),
      );
    }
  }
}

class InviteScreen extends StatelessWidget {
  final String inviteCode;
  final String name;
  final String productId;
  final String source;

  const InviteScreen({
    super.key,
    required this.inviteCode,
    required this.name,
    required this.productId,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invitation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You received an invitation!"),
            Text("Invite Code: $inviteCode"),
            Text("Invited by: $name"),
            Text("Product ID: $productId"),
            Text("Shared via: $source"),
            ElevatedButton(
              onPressed: () {
                print("🔥 Processing join request with code: $inviteCode");
              },
              child: const Text("Accept Invitation"),
            ),
          ],
        ),
      ),
    );
  }
}
