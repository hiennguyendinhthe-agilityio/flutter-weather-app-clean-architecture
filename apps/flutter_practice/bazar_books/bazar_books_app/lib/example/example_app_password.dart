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
          return const LoginScreen();
        },
      ),
    );
  }
}

class DynamicLinksService {
  Future<String> createResetPasswordLink(
      String email, String resetToken) async {
    final encodedEmail = Uri.encodeComponent(email);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bazarbooks.page.link',
      link: Uri.parse(
        'https://bazarbooks.com/reset-password?email=$encodedEmail&resetToken=$resetToken',
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
        title: 'Reset Password',
        description: 'Click the link to reset your password!',
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return shortLink.shortUrl.toString();
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _shareResetLink() async {
    final String email = _emailController.text.trim();
    final String resetToken = "ABC123";

    final String link =
        await DynamicLinksService().createResetPasswordLink(email, resetToken);
    debugPrint("Reset Password Link: $link");

    Share.share("Click here to reset your password: $link");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your email to generate a reset password link."),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareResetLink,
              child: const Text("Share Reset Link"),
            ),
          ],
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
      debugPrint("❌ Deep Link Error: $error");
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    if (data != null) {
      final Uri deepLink = data.link;
      debugPrint("✅ Deep Link Received: ${deepLink.toString()}");

      final token = deepLink.queryParameters["token"] ?? "N/A";
      final email = deepLink.queryParameters["email"] ?? "N/A";

      if (navigatorKey.currentState != null &&
          navigatorKey.currentState!.mounted) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordScreen(token: token, email: email),
          ),
        );
      }
    }
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  final String email;

  const ResetPasswordScreen(
      {super.key, required this.token, required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void _resetPassword() {
    final String newPassword = _passwordController.text.trim();
    debugPrint(
        "🔥 Reset password for ${widget.email} with token ${widget.token}");
    debugPrint("New Password: $newPassword");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Reset password for: ${widget.email}"),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Success")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🎉 Password Changed Successfully!"),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
