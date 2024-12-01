import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    this.icon,
    this.title,
    this.onTap,
  });

  final IconData? icon;
  final String? title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.03),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.purple)),
      title: Text(
        title ?? '',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
