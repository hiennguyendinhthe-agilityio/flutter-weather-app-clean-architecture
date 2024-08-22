import 'package:flutter/material.dart';

const kTile = 'Provider';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
            child: Center(
              child: Text(
                kTile,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          getListTile(
            const Text(
              'Home',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          getLine(),
          getListTile(
            const Text(
              'About',
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
          ),
          getLine(),
          getListTile(
            const Text('Settings'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
          getLine(),
          getListTile(
            const Text('Counter'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/counter');
            },
          ),
        ],
      ),
    );
  }

  Widget getLine() {
    return SizedBox(
      height: 0.5,
      child: Container(
        color: Colors.grey,
      ),
    );
  }

  Widget getListTile(Widget title, {Function()? onTap}) {
    return ListTile(
      title: title,
      onTap: onTap,
    );
  }
}
