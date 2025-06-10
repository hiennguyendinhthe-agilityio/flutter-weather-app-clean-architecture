import 'package:flutter/material.dart';

InputDecoration buildCommonDecoration({
  required BuildContext context,
  String? hintText,
  Widget? suffixIcon,
  bool isMultiline = false,
}) {
  return InputDecoration(
    hintText: hintText,
    labelStyle: const TextStyle(fontSize: 14),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: isMultiline ? 12 : 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    suffixIcon: suffixIcon,
  );
}
