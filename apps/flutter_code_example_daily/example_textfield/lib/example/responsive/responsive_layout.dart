import 'package:example_textfield/example/responsive/widgets/content.dart';
import 'package:example_textfield/example/responsive/widgets/footer.dart';
import 'package:example_textfield/example/responsive/widgets/header.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;

    final bool isWideScreen = screenWidth > 600;
    final bool isExtraWide = screenWidth > 900;

    return Column(
      children: [
        const Header(),
        Expanded(
          child: isExtraWide
              ? const Row(
                  children: [
                    Sidebar(), // Khi màn hình cực rộng, hiển thị Sidebar
                    Expanded(child: Content()),
                  ],
                )
              : const Content(),
        ),
        if (!isWideScreen)
          const Footer(), // Footer chỉ hiển thị trên màn hình nhỏ
      ],
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: Colors.blueGrey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title:
                  const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
