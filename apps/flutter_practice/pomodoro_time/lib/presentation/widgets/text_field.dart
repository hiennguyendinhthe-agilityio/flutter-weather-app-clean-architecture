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
    this.suffixIcon,
  });

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Label text displayed above the input.
  final String? labelText;

  /// Hint text displayed inside the input when empty.
  final String? hintText;

  /// Optional validator function for form validation.
  final String? Function(String?)? validator;

  /// Whether the input is read-only.
  final bool readOnly;

  /// Callback triggered when the input is tapped.
  final VoidCallback? onTap;

  /// Whether the input supports multiple lines.
  final bool isMultiline;

  /// Optional widget displayed at the end of the input field.
  final Widget? suffixIcon;
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
            suffixIcon: suffixIcon,
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
