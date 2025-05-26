import 'package:flutter/material.dart';

class SwitchSetting extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SwitchSetting({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
