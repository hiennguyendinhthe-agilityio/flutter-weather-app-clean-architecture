import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_design/widgets/buttons/elevated_button.dart';
import 'package:bazar_books_design/widgets/images/image.dart';
import 'package:flutter/material.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BazUiBuiltInImage.imgCongratulation(),
            const SizedBox(height: 40),
            Text(
              S.of(context).congratulationTitle,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).congratulationSubTitle,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            BazUiElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => true,
                );
              },
              text: S.of(context).getStartedTitle,
            ),
          ],
        ),
      ),
    );
  }
}
