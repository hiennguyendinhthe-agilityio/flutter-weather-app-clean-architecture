// 📁 pt_text_field.dart
import 'package:flutter/material.dart';

class PtTextField extends StatelessWidget {
  const PtTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.isMultiline = false,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: isMultiline ? null : 1,
          style: theme.textTheme.labelLarge,
          decoration: InputDecoration(
            errorBorder: theme.inputDecorationTheme.errorBorder,
            hintText: hintText,
            hintStyle: theme.textTheme.labelLarge?.copyWith(
              color: theme.hintColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.8,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            fillColor: theme.inputDecorationTheme.fillColor ?? Colors.white,
            filled: true,
            errorStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
